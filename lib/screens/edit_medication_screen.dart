import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pastillero_inteligente/models/medication.dart';
import 'package:pastillero_inteligente/providers/medication_provider.dart';

import 'package:pastillero_inteligente/services/notification_service.dart';

class EditMedicationScreen extends ConsumerStatefulWidget {
  final Medication medication;

  const EditMedicationScreen({super.key, required this.medication});

  @override
  EditMedicationScreenState createState() => EditMedicationScreenState();
}

class EditMedicationScreenState extends ConsumerState<EditMedicationScreen> {
  late final TextEditingController nameController;
  late final TextEditingController dosageController;
  late final TextEditingController timeController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.medication.name);
    dosageController = TextEditingController(text: widget.medication.dosage);
    timeController = TextEditingController(text: widget.medication.time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Medicamento'),
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
                final updatedMedication = Medication(
                  id: widget.medication.id,
                  patientId: widget.medication.patientId,
                  name: nameController.text,
                  dosage: dosageController.text,
                  time: timeController.text,
                );
                await ref.read(medicationProvider.notifier).editMedication(updatedMedication);
                await NotificationService().cancelNotification(updatedMedication.id);
                await NotificationService().scheduleDailyNotification(updatedMedication);
                if (context.mounted) context.pop();
              },
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
