import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../pos_karyawan/controllers/pos_controller.dart';

class RingkasanPesananController extends GetxController {
  final POSController posController = Get.find<POSController>();

  // ==========================================
  // KERANJANG LOKAL (Copy) - Performa instant!
  // ==========================================
  final localCart = <Map<String, dynamic>>[].obs;

  // ==========================================
  // STATE
  // ==========================================
  final selectedMethod = 'Tunai'.obs;
  final cashReceived = 0.obs;
  final cashController = TextEditingController();
  final catatanController = TextEditingController();

  // Snapshot struk
  final trxId = ''.obs;
  final trxDate = ''.obs;
  final receiptMethod = ''.obs;
  final receiptTotal = 0.obs;
  final receiptCash = 0.obs;
  final receiptChange = 0.obs;

  // ==========================================
  // PAJAK (Opsional)
  // ==========================================
  final useTax = true.obs;
  final taxPercent = 10;

  @override
  void onInit() {
    super.onInit();
    resync();
  }

  // Salin cart POS → lokal (saat sheet dibuka)
  void resync() {
    localCart.assignAll(
      posController.cart.map((e) => Map<String, dynamic>.from(e)).toList(),
    );
  }

  // Simpan cart lokal → POS (saat sheet ditutup)
  void commitToPos() {
    posController.cart.assignAll(
      localCart.map((e) => Map<String, dynamic>.from(e)).toList(),
    );
    posController.cart.refresh();
  }

  // ==========================================
  // GETTER (Semua dari LOCAL - instant)
  // ==========================================
  List get cartItems => localCart;

  int get totalItem =>
      localCart.fold(0, (sum, i) => sum + (i['quantity'] as int));

  int get subtotal => localCart.fold(
      0, (sum, i) => sum + (i['harga'] as int) * (i['quantity'] as int));

  int get tax => useTax.value ? (subtotal * taxPercent / 100).round() : 0;
  int get grandTotal => subtotal + tax;

  int get change => cashReceived.value - grandTotal;
  bool get isCashSufficient => cashReceived.value >= grandTotal;

  bool get canProcess {
    if (totalItem == 0) return false;
    if (selectedMethod.value == 'Tunai') return isCashSufficient;
    return true;
  }

  String formatRupiah(int angka) {
    return 'Rp ${angka.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        )}';
  }

  // ==========================================
  // AKSI KERANJANG LOKAL (Super cepat!)
  // ==========================================
  void increaseItem(int idx) {
    if (idx < 0 || idx >= localCart.length) return;
    final item = Map<String, dynamic>.from(localCart[idx]);
    item['quantity'] = (item['quantity'] as int) + 1;
    localCart[idx] = item;
  }

  void decreaseItem(int idx) {
    if (idx < 0 || idx >= localCart.length) return;
    final qty = localCart[idx]['quantity'] as int;
    if (qty > 1) {
      final item = Map<String, dynamic>.from(localCart[idx]);
      item['quantity'] = qty - 1;
      localCart[idx] = item;
    } else {
      localCart.removeAt(idx);
    }
  }

  void removeItem(int idx) {
    if (idx >= 0 && idx < localCart.length) localCart.removeAt(idx);
  }

  // ==========================================
  // PEMBAYARAN
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

  // Batalkan = kosongkan cart + tutup
  void batalkanPesanan() {
    posController.cart.clear();
    localCart.clear();
    _reset();
    Get.back();
  }

  // Transaksi baru = kosongkan semua + tutup semua halaman
  void finishTransaction() {
    posController.cart.clear();
    localCart.clear();
    _reset();
    Get.back();
    Get.back();
    Get.back();
  }

  void _reset() {
    cashReceived.value = 0;
    cashController.clear();
    catatanController.clear();
    selectedMethod.value = 'Tunai';
  }

  @override
  void onClose() {
    cashController.dispose();
    catatanController.dispose();
    super.onClose();
  }
}
