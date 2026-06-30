import 'package:curso_impressora_pos/models/items.dart';
import 'package:curso_impressora_pos/screens/paired_devices_screen.dart';
import 'package:curso_impressora_pos/viewmodel/checkout_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import '../app_colors.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final checkoutViewmodel = CheckoutViewmodel();

  List<Item> items = [
    Item(name: 'Caviar', price: 100.0),
    Item(name: 'Salada', price: 15.0),
    Item(name: 'Sorvete', price: 20.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplicativo Delivery'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.print, color: Colors.black87),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PairedDevicesScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Spacer(),
            Padding(
              padding: EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    final double total = items.fold(
                      0.0,
                      (sum, item) => sum + item.price,
                    );
                    if (await PrintBluetoothThermal.bluetoothEnabled) {
                      if (await PrintBluetoothThermal.connectionStatus) {
                        checkoutViewmodel.printReceipt(items, total);
                      } else {
                        if(!context.mounted) {
                          return;
                        }

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Nenhum dispositivo conectado'),
                            content: Text(
                              'Por favor, conecte um dispositivo antes de imprimir.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('Ok'),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      if(!context.mounted) {
                        return;
                      }

                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  Icons.bluetooth_disabled,
                                  size: 48,
                                  color: AppColors.primary,
                                ),
                                SizedBox(height: 24),
                                Text(
                                  'Ativar Bluetooth',
                                  style: TextStyle(fontSize: 24),
                                ),
                                SizedBox(height: 24),
                                Text(
                                  'Para continuar a impressão, a aplicação precisa do bluetooth ativo.',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                    foregroundColor: WidgetStatePropertyAll(AppColors.white),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                  child: Text('Imprimir', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
