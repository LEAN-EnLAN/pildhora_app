// Archivo: lib/screens/paywall_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suscripción Premium')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(LucideIcons.gem, size: 80, color: Colors.teal),
            const SizedBox(height: 20),
            const Text(
              'Desbloquea todas las funciones',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Con Premium obtienes:\n'
                  '• Informes médicos avanzados\n'
                  '• Exportación de datos\n'
                  '• Monitoreo de múltiples cuidadores\n'
                  '• Predicciones con IA\n',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Simulación de compra exitosa')),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Suscribirme'),
            ),
            TextButton(
              onPressed: () => context.go('/'),
              child: const Text('Quizás más tarde'),
            ),
          ],
        ),
      ),
    );
  }
}