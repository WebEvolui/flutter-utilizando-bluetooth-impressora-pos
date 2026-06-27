import 'package:curso_impressora_pos/models/items.dart';
import 'package:curso_impressora_pos/viewmodel/checkout_viewmodel.dart';
import 'package:flutter/material.dart';
import '../app_colors.dart';

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
                    checkoutViewmodel.printReceipt(items, total);
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
                  child: Text('Continuar', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
