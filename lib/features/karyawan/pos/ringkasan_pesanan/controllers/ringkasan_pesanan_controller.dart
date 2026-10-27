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

  // ===== QRIS (statis/dinamis + status) =====
  final qrisMode = 'STATIS'.obs; // STATIS / DINAMIS (fallback)
  final qrisGenerated = false.obs; // QR dinamis sudah dibuat?
  final qrisPaid = false.obs; // pembayaran QRIS masuk?

  // Snapshot struk
  final trxId = ''.obs;
  final trxDate = ''.obs; // tanggal saja, mis. "Sab, 30 Apr 2026"
  final trxTime = ''.obs; // jam saja,  mis. "09:14 WIB"  (poin 1)
  final costumerId = ''.obs; // INV-####-YYYY (poin 3c)
  final orderTime = ''.obs; // jam pesan  "HH:mm WIB"
  final doneTime = ''.obs; // jam selesai "HH:mm WIB"
  final durationMin = 0.obs; // durasi pengerjaan (menit)
  DateTime? _orderAt;
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
    // jam pesan = saat sheet ringkasan dibuka untuk order ini
    _orderAt = DateTime.now();
    orderTime.value = _fmtClock(_orderAt!);
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
    // QRIS dinamis: tidak boleh selesai sebelum status "SUDAH MASUK"
    if (qrisMode.value == 'DINAMIS' && !qrisPaid.value) return false;
    return true;
  }

  String _fmtClock(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')} WIB';

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
    final now = DateTime.now();
    trxId.value = '#TRX-${now.millisecondsSinceEpoch.toString().substring(7)}';
    // poin 1: format tanggal DD/MM/YYYY
    trxDate.value =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    trxTime.value =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} WIB';
    // poin 3c: ID kostumer gaya invoice (fiktif sampai backend pelanggan siap)
    final inv = (now.millisecondsSinceEpoch % 9000) + 1000;
    costumerId.value = 'INV-$inv-${now.year}';
    orderTime.value = _fmtClock(now); // #2: jam pesan = saat bayar selesai
    doneTime.value = _fmtClock(now);
    durationMin.value =
        _orderAt == null ? 0 : now.difference(_orderAt!).inMinutes;

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

  // Dipanggil dari HALAMAN STRUK: kosongkan order + tutup struk & ringkasan.
  // Asumsi stack: [shell/POS, ringkasan(sheet), struk] => pop x2 kembali ke POS.
  // Jika POS-mu adalah route tersendiri (bukan tab), sesuaikan jumlah Get.back().
  void completeAndClose() {
    posController.cart.clear();
    localCart.clear();
    _reset();
    Get.back(); // pop struk
    Get.back(); // pop ringkasan
  }

  void _reset() {
    cashReceived.value = 0;
    cashController.clear();
    catatanController.clear();
    selectedMethod.value = 'Tunai';
    qrisMode.value = 'STATIS';
    qrisGenerated.value = false;
    qrisPaid.value = false;
  }

  @override
  void onClose() {
    cashController.dispose();
    catatanController.dispose();
    super.onClose();
  }
}
