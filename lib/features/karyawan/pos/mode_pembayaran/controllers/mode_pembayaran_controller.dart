import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../pos_karyawan/controllers/pos_controller.dart';
import '../../ringkasan_pesanan/controllers/ringkasan_pesanan_controller.dart';

class ModePembayaranController extends GetxController {
  final POSController posController = Get.find<POSController>();
  final RingkasanPesananController ringkasanController =
      Get.find<RingkasanPesananController>();

  // ==========================================
  // STATE PEMBAYARAN
  // ==========================================
  final selectedMethod = 'Tunai'.obs;
  final cashReceived = 0.obs;
  final cashController = TextEditingController();

  // Snapshot struk
  final trxId = ''.obs;
  final trxDate = ''.obs;
  final receiptMethod = ''.obs;
  final receiptTotal = 0.obs;
  final receiptCash = 0.obs;
  final receiptChange = 0.obs;

  // ==========================================
  // GETTER
  // ==========================================
  int get grandTotal => ringkasanController.grandTotal;

  int get change => cashReceived.value - grandTotal;
  bool get isCashSufficient => cashReceived.value >= grandTotal;

  bool get canProcess {
    if (selectedMethod.value == 'Tunai') return isCashSufficient;
    return true; // QRIS selalu bisa (dummy)
  }

  String formatRupiah(int angka) {
    return 'Rp ${angka.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        )}';
  }

  // ==========================================
  // ACTIONS
  // ==========================================
  void selectMethod(String method) => selectedMethod.value = method;

  void onCashChanged(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    cashReceived.value = cleaned.isEmpty ? 0 : int.parse(cleaned);
  }

  void setCash(int amount) {
    cashReceived.value = amount;
    cashController.text = amount.toString();
  }

  bool processPayment() {
    if (!canProcess) return false;
    trxId.value =
        '#TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    trxDate.value =
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';
    receiptMethod.value = selectedMethod.value;
    receiptTotal.value = grandTotal;
    receiptCash.value =
        selectedMethod.value == 'Tunai' ? cashReceived.value : grandTotal;
    receiptChange.value = selectedMethod.value == 'Tunai' ? change : 0;
    return true;
  }

  // Transaksi baru = kosongkan cart + tutup 3 halaman (sukses, pembayaran, ringkasan)
  void finishTransaction() {
    posController.cart.clear();
    ringkasanController.localCart.clear();
    cashReceived.value = 0;
    cashController.clear();
    selectedMethod.value = 'Tunai';
    Get.back(); // tutup sukses
    Get.back(); // tutup sheet pembayaran
    Get.back(); // tutup sheet ringkasan
  }

  @override
  void onClose() {
    cashController.dispose();
    super.onClose();
  }
}
