import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pastillero_inteligente/models/medication.dart';
import 'package:pastillero_inteligente/providers/medication_provider.dart';
import 'package:pastillero_inteligente/services/notification_service.dart';
import 'package:uuid/uuid.dart';

class AddMedicationScreen extends ConsumerWidget {
  final String patientId;

  const AddMedicationScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final dosageController = TextEditingController();
    final timeController = TextEditingController();
    const uuid = Uuid();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Medicamento'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre del Medicamento'),
            ),
            TextField(
              controller: dosageController,
              decoration: const InputDecoration(labelText: 'Dosis'),
            ),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: 'Hora (HH:MM)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final newMedication = Medication(
                  id: uuid.v4(),
                  patientId: patientId,
                  name: nameController.text,
                  dosage: dosageController.text,
                  time: timeController.text,
                );
                await ref.read(medicationProvider.notifier).addMedication(newMedication);
                await NotificationService().scheduleDailyNotification(newMedication);
                if (context.mounted) context.pop();
              },
              child: const Text('Guardar Medicamento'),
            ),
          ],
        ),
      ),
    );
  }
}
