import 'package:curso_impressora_pos/utils/printer_settings_utils.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrintingService {
  static Future<void> printReceipt(List<int> bytes) async {
    try {
      await PrintBluetoothThermal.writeBytes(bytes);
    } catch (e) {
      print("Error printing receipt: $e");
    }
  }

  static Future<void> printTest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    PaperSize paperSize = PaperSizeUtils.getPaperSize(prefs.getInt('paperSize') ?? 1);
    PosTextSize fontSize = FontSizeUtils.getFontSize(prefs.getInt('fontSize') ?? 1);

    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    Generator generator = Generator(paperSize, profile);
    bytes += generator.reset();
    bytes += generator.feed(2);
    bytes += generator.text(
      'Restaurante Evolui',
      styles: PosStyles(align: PosAlign.center, height: fontSize),
    );
    bytes += generator.feed(1);
    bytes += generator.text(
      'Itens consumidos size 1',
      styles: PosStyles(align: PosAlign.left, height: PosTextSize.size1),
    );
    bytes += generator.feed(2);
    await PrintingService.printReceipt(bytes);

  }
}
