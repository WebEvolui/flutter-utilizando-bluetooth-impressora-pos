import 'package:flutter/foundation.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PairedDevicesService {
  static Future<List<BluetoothInfo>> getPairedDevices() async {
    List<BluetoothInfo> devices = [];
    try {
      devices = await PrintBluetoothThermal.pairedBluetooths;
    } catch (e) {
      if (kDebugMode) {
        print("Error retrieving paired devices: $e");
      }
    }
    return devices;
  }
}
