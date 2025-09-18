import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PatientMedicationsScreen extends StatelessWidget {
  final String patientId;

  const PatientMedicationsScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicamentos del Paciente'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
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
              Text(
                'Aquí se mostrará la lista de medicamentos del paciente con id: $patientId',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
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
