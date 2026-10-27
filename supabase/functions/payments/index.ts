// supabase/functions/payments/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createDynamicQris, checkTransaction } from "./providers/duitku.ts";
import type { PaymentRequest } from "./types.ts";
import { log } from "./utils.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // GANTI BAGIAN INI DI index.ts
    const url = new URL(req.url);
    const segments = url.pathname.split("/").filter(Boolean);

    // Validasi sederhana: pastikan path mengandung 'payments'
    // Ini lebih toleran terhadap variasi URL Supabase
    if (segments.length > 0 && !segments.some((s) => s === "payments")) {
      throw new Error("Invalid route. Use /payments endpoint.");
    }

    if (req.method === "POST") {
      const body = await req.json();
      // Default ke 'generate' jika tidak ada action (backward compatible)
      const action = body.action || "generate";

      log("Processing Action:", { action, orderId: body.orderId });

      // AKSI 1: Generate QRIS
      if (action === "generate") {
        if (!body.amount || !body.orderId) {
          throw new Error("Missing amount or orderId for generate");
        }
        const result = await createDynamicQris(body as PaymentRequest);
        return new Response(JSON.stringify(result), {
          status: result.success ? 200 : 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      // AKSI 2: Cek Status Transaksi
      if (action === "check") {
        if (!body.orderId) {
          throw new Error("Missing orderId for check");
        }
        const result = await checkTransaction(body.orderId as string);
        return new Response(JSON.stringify(result), {
          status: 200,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }

      throw new Error(`Unknown action: ${action}`);
    }

    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err) {
    log("Server Error:", String(err));
    return new Response(
      JSON.stringify({ success: false, message: String(err) }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      },
    );
  }
});
