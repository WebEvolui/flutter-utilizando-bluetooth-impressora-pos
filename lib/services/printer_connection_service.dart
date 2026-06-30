import 'package:flutter/foundation.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrinterConnectionService {
  static Future<void> connect(String macAddress) async {
    try {
      await PrintBluetoothThermal.connect(macPrinterAddress: macAddress);
    } catch (e) {
      if (kDebugMode) {
        print("Error connecting to printer: $e");
      }
    }
  }

  static Future<void> disconnect() async {
    try {
      await PrintBluetoothThermal.disconnect;
    } catch (e) {
      if (kDebugMode) {
        print("Error disconnecting from printer: $e");
      }
    }
  }
}
