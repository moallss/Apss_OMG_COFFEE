import 'package:get/get.dart';

import '../../ringkasan_pesanan/controllers/ringkasan_pesanan_controller.dart';
import '../../pos_karyawan/controllers/pos_controller.dart';

class StrukController extends GetxController {
  // ===== snapshot (diisi onInit, statis setelah load) =====
  String trxId = '';
  String trxDate = '';
  String trxTime = '';
  String costumerId = '';
  String orderTime = '';
  String doneTime = '';
  int durationMin = 0;
  String kasir = '';
  String shift = 'Shift 1'; // TODO(sumber-data): shift belum ada di controller
  String methodDisplay = '';
  bool isCash = true;
  int totalItem = 0;
  int subtotal = 0;
  int taxPercent = 0;
  int tax = 0;
  bool useTax = false;
  int grandTotal = 0;
  int receiptCash = 0;
  int receiptChange = 0;
  String catatan = '';
  List<Map<String, dynamic>> items = const [];

  @override
  void onInit() {
    super.onInit();
    final r = Get.find<RingkasanPesananController>();
    final p = Get.find<POSController>();

    // salin dalam (deep) agar tidak ikut ter-clear saat "Pesanan Baru"
    items = r.cartItems
        .map((e) => Map<String, dynamic>.from(e))
        .toList(growable: false);

    trxId = r.trxId.value;
    trxDate = r.trxDate.value;
    trxTime = r.trxTime.value;
    costumerId = r.costumerId.value;
    orderTime = r.orderTime.value;
    doneTime = r.doneTime.value;
    durationMin = r.durationMin.value;
    totalItem = r.totalItem;
    subtotal = r.subtotal;
    taxPercent = r.taxPercent;
    tax = r.tax;
    useTax = r.useTax.value;
    grandTotal = r.grandTotal;
    receiptCash = r.receiptCash.value;
    receiptChange = r.receiptChange.value;
    methodDisplay = r.receiptMethod.value;
    isCash = methodDisplay != 'QRIS';
    kasir = p.userName.value;
    catatan = r.catatanController.text.trim();
  }

  // "+ PESANAN BARU": kosongkan order di sumber, lalu tutup struk & ringkasan.
  // Stack saat ini: [.., POS, ringkasan(sheet), struk] => pop x2 kembali ke POS.
  void pesanBaru() {
    final r = Get.find<RingkasanPesananController>();
    r.posController.cart.clear();
    r.localCart.clear();
    Get.back(); // pop struk
    Get.back(); // pop ringkasan (instance ringkasan ikut di-close oleh GetX)
  }
}
