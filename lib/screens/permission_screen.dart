import 'dart:io';

import 'package:curso_impressora_pos/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../app_colors.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Permissões',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Bluetooth icon
              Icon(
                Icons.bluetooth,
                size: 100,
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
              const SizedBox(height: 24),
              // Main text
              const Text(
                'Precisamos de acesso\nao seu Bluetooth',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              // Description text
              const Text(
                'Para continuar a impressão, a aplicação precisa de autorização do seu dispositivo para acessar o Bluetooth.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 3),
              // Primary button - Autorizar Bluetooth
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    if (Platform.isAndroid || Platform.isIOS || Platform.isWindows) {
                      await Permission.bluetoothScan.request();
                      await Permission.bluetoothConnect.request();

                      if ((await Permission.bluetoothScan.isGranted &&
                          await Permission.bluetoothConnect.isGranted) ||
                          await Permission.bluetooth.isGranted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => HomeScreen()),
                        );
                      }
                    } else if (Platform.isMacOS ) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => HomeScreen()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Autorizar Bluetooth',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Secondary button - Agora não
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    // Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: AppColors.white,
                  ),
                  child: const Text(
                    'Agora não',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
