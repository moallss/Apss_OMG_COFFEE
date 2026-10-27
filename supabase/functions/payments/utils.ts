// supabase/functions/payments/utils.ts

export function log(message: string, data?: any) {
  const ts = new Date().toISOString();
  console.log(`[${ts}] PAYMENTS: ${message}`, data ? JSON.stringify(data) : "");
}

/**
 * Menghitung Signature HMAC-SHA256 sesuai spesifikasi Duitku V2.
 * Formula: HMAC_SHA256(merchantCode + merchantOrderId + paymentAmount, apiKey)
 */
export async function generateDuitkuSignature(
  merchantCode: string,
  orderId: string,
  amount: number,
  apiKey: string,
): Promise<string> {
  const encoder = new TextEncoder();

  // 1. Buat stringToSign
  const stringToSign = `${merchantCode}${orderId}${amount}`;

  // 2. Import key untuk HMAC
  const keyData = encoder.encode(apiKey);
  const cryptoKey = await crypto.subtle.importKey(
    "raw",
    keyData,
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"],
  );

  // 3. Sign data
  const signatureBuffer = await crypto.subtle.sign(
    "HMAC",
    cryptoKey,
    encoder.encode(stringToSign),
  );

  // 4. Convert ke Hex String Lowercase
  return Array.from(new Uint8Array(signatureBuffer))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}

/**
 * Signature untuk CEK TRANSAKSI — BEDA dari inquiry!
 * Formula: HMAC_SHA256(merchantCode + merchantOrderId, apiKey) — TANPA amount.
 * (Sumber: dokumentasi resmi Duitku V2, bagian "Cek Transaksi")
 */
export async function generateDuitkuCheckSignature(
  merchantCode: string,
  orderId: string,
  apiKey: string,
): Promise<string> {
  const encoder = new TextEncoder();
  const stringToSign = `${merchantCode}${orderId}`; // tanpa amount!
  const keyData = encoder.encode(apiKey);
  const cryptoKey = await crypto.subtle.importKey(
    "raw",
    keyData,
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const signatureBuffer = await crypto.subtle.sign(
    "HMAC",
    cryptoKey,
    encoder.encode(stringToSign),
  );
  return Array.from(new Uint8Array(signatureBuffer))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}
