// Archivo: lib/screens/my_medications_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MyMedicationsScreen extends StatelessWidget {
  const MyMedicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Medicamentos'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.of(context).pop(), // O usa GoRouter si prefieres
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(LucideIcons.pill, size: 80, color: Theme.of(context).primaryColor),
              const SizedBox(height: 20),
              const Text(
                'Aquí se mostrará la lista de tus medicamentos.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(LucideIcons.plusCircle),
                label: const Text('Agregar Medicamento'),
                onPressed: () {
                  // TODO: Implementar la lógica para agregar un nuevo medicamento
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Funcionalidad "Agregar Medicamento" pendiente.')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
