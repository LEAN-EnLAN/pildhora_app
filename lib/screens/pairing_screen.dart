// Archivo: lib/screens/pairing_screen.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PairingScreen extends StatefulWidget {
  const PairingScreen({super.key});

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  bool _isPairing = false;
  bool _isPaired = false;

  Future<void> _simulatePairing() async {
    setState(() => _isPairing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isPairing = false;
      _isPaired = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vincular dispositivo')),
      body: Center(
        child: _isPairing
            ? const CircularProgressIndicator()
            : _isPaired
            ? const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.checkCircle, size: 80, color: Colors.green),
            SizedBox(height: 16),
            Text(
              '✅ Dispositivo vinculado correctamente',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
          ],
        )
            : ElevatedButton.icon(
          onPressed: _simulatePairing,
          icon: const Icon(LucideIcons.bluetooth),
          label: const Text('Iniciar vinculación'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
      ),
    );
  }
}