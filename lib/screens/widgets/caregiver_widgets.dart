import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pastillero_inteligente/models/medication.dart';
import 'package:pastillero_inteligente/models/medication_intake.dart';
import 'package:pastillero_inteligente/models/user_profile.dart';
import 'package:pastillero_inteligente/providers/medication_provider.dart';
import 'package:pastillero_inteligente/services/database_service.dart';

final adherenceProvider = FutureProvider.autoDispose
    .family<double, List<String>>((ref, patientIds) async {
  final intakes =
      await DatabaseService.instance.getIntakesForPatients(patientIds);
  final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

  final recentIntakes = intakes
      .where((intake) => intake.scheduledTime.isAfter(sevenDaysAgo))
      .toList();

  if (recentIntakes.isEmpty) {
    return 100.0;
  }

  final takenCount = recentIntakes
      .where((intake) => intake.status == IntakeStatus.taken)
      .length;
  final scheduledCount = recentIntakes.length;

  return (takenCount / scheduledCount) * 100;
});

class AdherenceSummaryCard extends ConsumerWidget {
  final List<String> patientIds;

  const AdherenceSummaryCard({super.key, required this.patientIds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adherence = ref.watch(adherenceProvider(patientIds));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            adherence.when(
              data: (percentage) => SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: percentage / 100,
                      strokeWidth: 6,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        percentage > 90
                            ? Colors.green
                            : (percentage > 70 ? Colors.orange : Colors.red),
                      ),
                    ),
                    Text('${percentage.toStringAsFixed(0)}%',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
              loading: () => const SizedBox(
                width: 60,
                height: 60,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => const SizedBox(
                width: 60,
                height: 60,
                child:
                    Center(child: Icon(LucideIcons.xCircle, color: Colors.red)),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cumplimiento General',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text('Últimos 7 días', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientStatusCard extends ConsumerWidget {
  final PatientInfo patient;

  const PatientStatusCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allMedications = ref
        .watch(medicationProvider)
        .where((m) => m.patientId == patient.uid)
        .toList();
    allMedications.sort((a, b) => a.time.compareTo(b.time));

    Medication? nextMed;
    if (allMedications.isNotEmpty) {
      final now = TimeOfDay.now();
      final nextMedIndex = allMedications.indexWhere((m) {
        try {
          final medTime = TimeOfDay(
              hour: int.parse(m.time.split(':')[0]),
              minute: int.parse(m.time.split(':')[1]));
          return medTime.hour > now.hour ||
              (medTime.hour == now.hour && medTime.minute >= now.minute);
        } catch (e) {
          return false;
        }
      });

      if (nextMedIndex != -1) {
        nextMed = allMedications[nextMedIndex];
      } else {
        nextMed = allMedications.first;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/patient_details/${patient.uid}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      patient.name.substring(0, 1),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(patient.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Edad: ${patient.age} años'),
                      ],
                    ),
                  ),
                  const Icon(LucideIcons.chevronRight),
                ],
              ),
              const Divider(height: 24),
              if (nextMed != null)
                Row(
                  children: [
                    Icon(LucideIcons.alarmClock,
                        size: 20, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Próxima toma: ${nextMed.name} a las ${nextMed.time}',
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              else
                const Row(
                  children: [
                    Icon(LucideIcons.checkCircle2,
                        color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'No hay más medicamentos por hoy.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
