import 'package:curso_impressora_pos/screens/printer_settings.dart';
import 'package:curso_impressora_pos/services/paired_devices_service.dart';
import 'package:curso_impressora_pos/services/printer_connection_service.dart';
import 'package:flutter/material.dart';
import '../app_colors.dart';

class PairedDevicesScreen extends StatelessWidget {
  const PairedDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Dispositivos pareados',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black87),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => PrinterSettings()));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text("Bluetooth", style: TextStyle(fontSize: 22)),
                ),
              ),
              FutureBuilder(
                future: PairedDevicesService.getPairedDevices(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SliverList.builder(
                      itemBuilder: (context, index) => ListTile(
                        onTap: () async {
                          try {
                            await PrinterConnectionService.connect(
                              snapshot.data![index].macAdress,
                            );

                            if (!context.mounted) {
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('impressora conectada')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Não foi possivel se conectar'),
                              ),
                            );
                          }
                        },
                        title: Text(snapshot.data![index].name),
                        subtitle: Text(snapshot.data![index].macAdress),
                        leading: Icon(Icons.print),
                      ),
                      itemCount: snapshot.data!.length,
                    );
                  } else {
                    return SliverToBoxAdapter(child: Container());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
