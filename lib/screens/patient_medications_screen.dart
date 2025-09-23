import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pastillero_inteligente/providers/medication_provider.dart';
import 'package:pastillero_inteligente/services/notification_service.dart';

class PatientMedicationsScreen extends ConsumerStatefulWidget {
  final String patientId;

  const PatientMedicationsScreen({super.key, required this.patientId});

  @override
  PatientMedicationsScreenState createState() =>
      PatientMedicationsScreenState();
}

class PatientMedicationsScreenState
    extends ConsumerState<PatientMedicationsScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar los medicamentos cuando la pantalla se inicia
    Future.microtask(() => ref
        .read(medicationProvider.notifier)
        .loadMedications(widget.patientId));
  }

  @override
  Widget build(BuildContext context) {
    final medications = ref.watch(medicationProvider);

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
        child: Column(
          children: [
            Expanded(
              child: medications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(LucideIcons.pill,
                              size: 80, color: Theme.of(context).primaryColor),
                          const SizedBox(height: 20),
                          Text(
                            'No hay medicamentos para el paciente con id: ${widget.patientId}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: medications.length,
                      itemBuilder: (context, index) {
                        final med = medications[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(med.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                'Dosis: ${med.dosage} - Hora: ${med.time}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(LucideIcons.edit,
                                      color: Colors.blue),
                                  onPressed: () => context.push(
                                      '/patient_medications/${widget.patientId}/edit/${med.id}'),
                                ),
                                IconButton(
                                  icon: const Icon(LucideIcons.trash2,
                                      color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title:
                                            const Text('Confirmar Eliminación'),
                                        content: Text(
                                            '¿Estás seguro de que quieres eliminar ${med.name}?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => context.pop(),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await NotificationService()
                                                  .cancelNotification(med.id);
                                              await ref
                                                  .read(medicationProvider
                                                      .notifier)
                                                  .removeMedication(
                                                      med.id, widget.patientId);
                                              if (context.mounted)
                                                context.pop();
                                            },
                                            child: const Text('Eliminar'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(LucideIcons.plusCircle),
              label: const Text('Agregar Medicamento'),
              onPressed: () {
                context.push(
                    '/patient_medications/${widget.patientId}/add_medication');
              },
            ),
          ],
        ),
      ),
    );
  }
}
