// supabase/functions/payments/providers/duitku.ts
import type { PaymentRequest, PaymentResponse } from "../types.ts";
import {
  log,
  generateDuitkuSignature,
  generateDuitkuCheckSignature,
} from "../utils.ts";

const DUITKU_SANDBOX_URL =
  "https://sandbox.duitku.com/webapi/api/merchant/v2/inquiry";
const DUITKU_CHECK_URL =
  "https://sandbox.duitku.com/webapi/api/merchant/v2/checkTransaction";

// ==========================================
// CEK STATUS TRANSAKSI (untuk polling "SUDAH MASUK")
// ==========================================
// Type: application/x-www-form-urlencoded (BUKAN json — beda dari inquiry!)
// Signature: HMAC_SHA256(merchantCode + merchantOrderId, apiKey) — TANPA amount.
// statusCode: 00=Success(lunas), 01=Pending, 02=Cancelled.
export interface CheckResult {
  success: boolean;
  status: "PENDING" | "PAID" | "CANCELLED" | "FAILED";
  message?: string;
}

export async function checkTransaction(orderId: string): Promise<CheckResult> {
  const merchantCode = Deno.env.get("DUITKU_MERCHANT_CODE");
  const apiKey = Deno.env.get("DUITKU_API_KEY");

  if (!merchantCode || !apiKey) {
    log("FATAL: Missing credentials in env vars (check).");
    return { success: false, status: "FAILED", message: "Config Error" };
  }

  try {
    const signature = await generateDuitkuCheckSignature(
      merchantCode,
      orderId,
      apiKey,
    );

    // Body form-urlencoded (sesuai docs: Type x-www-form-urlencoded)
    const formBody = new URLSearchParams({
      merchantCode: merchantCode,
      merchantOrderId: orderId,
      signature: signature,
    }).toString();

    log("Checking Transaction at Duitku...", { orderId });

    const response = await fetch(DUITKU_CHECK_URL, {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: formBody,
    });

    // FIX: Validasi content-type sebelum parse JSON
    const contentType = response.headers.get("content-type");
    if (!contentType || !contentType.includes("application/json")) {
      const text = await response.text();
      log("Duitku returned non-JSON response:", text.substring(0, 200));
      return {
        success: false,
        status: "FAILED",
        message: "Duitku returned invalid response (not JSON)",
      };
    }

    const result = await response.json();
    log("Received Check Response from Duitku:", result);

    // Error shape: { "Message": "..." }
    if (result.Message) {
      return { success: false, status: "FAILED", message: result.Message };
    }

    // statusCode: 00=Success(lunas), 01=Pending, 02=Cancelled
    switch (result.statusCode) {
      case "00":
        return { success: true, status: "PAID", message: "Lunas" };
      case "01":
        return {
          success: true,
          status: "PENDING",
          message: "Menunggu pembayaran",
        };
      case "02":
        return { success: true, status: "CANCELLED", message: "Dibatalkan" };
      default:
        return {
          success: false,
          status: "FAILED",
          message: result.statusMessage || "Unknown status",
        };
    }
  } catch (err) {
    log("Exception during Duitku check:", String(err));
    return { success: false, status: "FAILED", message: String(err) };
  }
}

export async function createDynamicQris(
  req: PaymentRequest,
): Promise<PaymentResponse> {
  const merchantCode = Deno.env.get("DUITKU_MERCHANT_CODE");
  const apiKey = Deno.env.get("DUITKU_API_KEY");

  if (!merchantCode || !apiKey) {
    log("FATAL: Missing credentials in env vars.");
    return {
      success: false,
      transactionId: "",
      status: "FAILED",
      message: "Config Error",
    };
  }

  try {
    const signature = await generateDuitkuSignature(
      merchantCode,
      req.orderId,
      req.amount,
      apiKey,
    );

    const body = {
      merchantCode: merchantCode,
      paymentAmount: req.amount,
      merchantOrderId: req.orderId,
      productDetails: `OMG COFFEE - Order ${req.orderId}`,
      email: "test@omgcoffee.com",
      phoneNumber: "081234567890",
      additionalParam: "",
      paymentMethod: "SP", // ShopeePay QRIS. (NQ=Nobu gagal provisioning di sandbox; SQ=Nusapay cadangan)      customerVaName: "Pelanggan OMG",
      returnUrl: "https://example.com/return",
      callbackUrl: "https://example.com/callback",
      expiryPeriod: 10,
      signature: signature,
    };

    log("Sending Request to Duitku...", {
      orderId: req.orderId,
      paymentMethod: body.paymentMethod,
    });

    const response = await fetch(DUITKU_SANDBOX_URL, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(body),
    });

    const result = await response.json();
    log("Received Response from Duitku:", result);

    // FIX #2: parsing sesuai struktur ASLI dari PDF.
    // Error  -> { "Message": "..." }            (M kapital, tanpa statusCode)
    // Sukses -> { ..., "statusCode":"00", "qrString":"...", "reference":"..." }  ("00" bukan "200"!)

    if (result.Message) {
      return {
        success: false,
        transactionId: "",
        status: "FAILED",
        message: result.Message,
      };
    }

    if (result.statusCode === "00" || result.qrString || result.reference) {
      return {
        success: true,
        qrString: result.qrString || "",
        transactionId: result.reference || req.orderId,
        status: "PENDING",
        message: "QR Berhasil Dibuat",
      };
    }

    return {
      success: false,
      transactionId: "",
      status: "FAILED",
      message:
        result.statusMessage || "Unknown Error (unrecognized response shape)",
    };
  } catch (err) {
    log("Exception during Duitku call:", String(err));
    return {
      success: false,
      transactionId: "",
      status: "FAILED",
      message: String(err),
    };
  }
}
