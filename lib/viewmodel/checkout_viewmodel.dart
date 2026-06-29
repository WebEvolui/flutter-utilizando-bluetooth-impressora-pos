import 'package:curso_impressora_pos/models/items.dart';
import 'package:curso_impressora_pos/services/paired_devices_service.dart';
import 'package:curso_impressora_pos/services/printer_connection_service.dart';
import 'package:curso_impressora_pos/services/printing_service.dart';
import 'package:curso_impressora_pos/utils/printer_settings_utils.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutViewmodel {
  Future<void> printReceipt(List<Item> items, double total) async {
    await PrintingService.printReceipt(await _prepareReceipt(items, total));
  }

  Future<List<int>> _prepareReceipt(List<Item> items, double total) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final PaperSize paperSize = PaperSizeUtils.getPaperSize(
      prefs.getInt('paperSize') ?? 1,
    );
    final PosTextSize fontSize = FontSizeUtils.getFontSize(
      prefs.getInt('fontSize') ?? 1,
    );

    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    Generator generator = Generator(paperSize, profile);
    bytes += generator.reset();
    bytes += generator.feed(2);
    bytes += generator.text(
      'Restaurante Evolui',
      styles: PosStyles(align: PosAlign.center, height: PosTextSize.size2),
    );
    bytes += generator.reset();
    bytes += generator.feed(1);
    bytes += generator.qrcode('https://www.evolui.dev', size: QRSize.size8);
    bytes += generator.feed(1);
    for (var item in items) {
      bytes += generator.row([
        PosColumn(
          text: item.name,
          width: 6,
          styles: PosStyles(align: PosAlign.left, height: fontSize),
        ),
        PosColumn(
          text: 'R\$ ${item.price.toStringAsFixed(2)}',
          width: 6,
          styles: PosStyles(align: PosAlign.right, height: fontSize),
        ),
      ]);
    }
    bytes += generator.reset();
    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
        text: "Total",
        width: 6,
        styles: PosStyles(align: PosAlign.left, height: fontSize),
      ),
      PosColumn(
        text: total.toStringAsFixed(2),
        width: 6,
        styles: PosStyles(align: PosAlign.right, height: fontSize),
      ),
    ]);
    bytes += generator.feed(3);
    return bytes;
  }
}
