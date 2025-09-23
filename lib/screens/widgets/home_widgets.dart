import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pastillero_inteligente/models/medication.dart';
import 'package:pastillero_inteligente/models/medication_intake.dart';
import 'package:pastillero_inteligente/models/user_profile.dart';
import 'package:pastillero_inteligente/providers/medication_provider.dart';
import 'package:pastillero_inteligente/services/database_service.dart';
import 'package:uuid/uuid.dart';

class WelcomeHeader extends StatelessWidget {
  final UserProfile userProfile;

  const WelcomeHeader({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hola, ${userProfile.name.split(' ').first}!',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          '¡Es hora de cuidar de ti!',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}

class NextMedicationCard extends ConsumerWidget {
  final String patientId;

  const NextMedicationCard({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allMedications = ref
        .watch(medicationProvider)
        .where((m) => m.patientId == patientId)
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
      color: Theme.of(context).primaryColor.withAlpha(25),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: nextMed == null
            ? const Row(
                children: [
                  Icon(LucideIcons.checkCircle2, color: Colors.green, size: 32),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'No tienes más medicamentos por hoy. ¡Buen trabajo!',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.alarmClock,
                          size: 32, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('PRÓXIMA TOMA',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(nextMed.name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('Dosis: ${nextMed.dosage}'),
                          ],
                        ),
                      ),
                      Text(nextMed.time,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      const uuid = Uuid();
                      final now = DateTime.now();
                      final scheduledTime = DateTime(
                          now.year,
                          now.month,
                          now.day,
                          int.parse(nextMed!.time.split(':')[0]),
                          int.parse(nextMed.time.split(':')[1]));

                      final intake = MedicationIntake(
                        id: uuid.v4(),
                        medicationId: nextMed.id,
                        medicationName: nextMed.name,
                        patientId: patientId,
                        scheduledTime: scheduledTime,
                        takenTime: now,
                        status: IntakeStatus.taken,
                      );
                      await DatabaseService.instance.insertIntake(intake);
                      ref
                          .read(medicationProvider.notifier)
                          .loadMedications(patientId);
                    },
                    child: const Text('Marcar como Tomada'),
                  )
                ],
              ),
      ),
    );
  }
}

class PatientSummaryCard extends StatelessWidget {
  final UserProfile userProfile;

  const PatientSummaryCard({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    final patients = userProfile.managedPatients ?? [];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tus Pacientes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (patients.isEmpty)
              const Text('Aún no gestionas a ningún paciente.')
            else
              ...patients.map((p) => ListTile(
                    title: Text(p.name),
                    subtitle: Text('${p.age} años'),
                    trailing: ElevatedButton(
                      child: const Text('Ver Meds'),
                      onPressed: () =>
                          context.push('/patient_medications/${p.uid}'),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
