// supabase/functions/payments/types.ts

export interface PaymentRequest {
  method: "qris_dynamic" | "qris_static";
  amount: number;
  orderId: string;
  customerName?: string;
}

export interface PaymentResponse {
  success: boolean;
  qrString?: string;
  transactionId: string;
  status: "CREATED" | "PENDING" | "PAID" | "FAILED";
  message?: string;
}
