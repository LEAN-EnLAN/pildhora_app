import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pastillero_inteligente/models/medication.dart';
import 'package:pastillero_inteligente/providers/auth_provider.dart';
import 'package:pastillero_inteligente/models/user_profile.dart';
import 'package:pastillero_inteligente/providers/medication_provider.dart';
import 'package:pastillero_inteligente/models/medication_intake.dart';
import 'package:pastillero_inteligente/services/database_service.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pildhora'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      body: userProfile == null
          ? const Center(child: CircularProgressIndicator())
          : _buildUserView(context, ref, userProfile),
    );
  }

  Widget _buildUserView(BuildContext context, WidgetRef ref, UserProfile userProfile) {
    if (userProfile.type == ProfileType.paciente) {
      return _buildPatientView(context, ref, userProfile);
    } else {
      return _buildCaregiverView(context, ref, userProfile);
    }
  }

  // Vista para el paciente
  Widget _buildPatientView(BuildContext context, WidgetRef ref, UserProfile userProfile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
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
          const SizedBox(height: 24),
          _buildNextMedicationCard(context, ref, userProfile.uid),
          const SizedBox(height: 24),
          _buildActionCard(
            context: context,
            icon: LucideIcons.settings2,
            title: 'Configurar Pastillero',
            subtitle: 'Ajustes de tu dispositivo',
            onTap: () => context.push('/device_settings'),
          ),
          const SizedBox(height: 16),
          _buildActionCard(
            context: context,
            icon: LucideIcons.history,
            title: 'Historial de Tomas',
            subtitle: 'Revisa tus tomas pasadas',
            onTap: () => context.push('/history'),
          ),
          const SizedBox(height: 16),
          _buildActionCard(
            context: context,
            icon: LucideIcons.phoneCall,
            title: 'Contactar Cuidador',
            subtitle: 'Habla con la persona a tu cargo',
            onTap: () => context.push('/contact_caregiver'),
          ),
        ],
      ),
    );
  }

  // Vista para el cuidador
  Widget _buildCaregiverView(BuildContext context, WidgetRef ref, UserProfile userProfile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Panel de Cuidador',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildPatientSummaryCard(context, userProfile),
          const SizedBox(height: 24),
          _buildActionCard(
            context: context,
            icon: LucideIcons.users,
            title: 'Gestionar Pacientes',
            subtitle: 'Ver el estado de tus pacientes',
            onTap: () => context.push('/caregiver_panel'),
          ),
          const SizedBox(height: 16),
          _buildActionCard(
            context: context,
            icon: LucideIcons.userPlus,
            title: 'Añadir nuevo paciente',
            subtitle: 'Invita a un paciente para cuidarlo',
            onTap: () => context.push('/add_caregiver'),
          ),
        ],
      ),
    );
  }

  // WIDGET NUEVO: Tarjeta de próximo medicamento para el paciente
  Widget _buildNextMedicationCard(BuildContext context, WidgetRef ref, String patientId) {
    final allMedications = ref.watch(medicationProvider).where((m) => m.patientId == patientId).toList();
    allMedications.sort((a, b) => a.time.compareTo(b.time));

    Medication? nextMed;
    if (allMedications.isNotEmpty) {
      final now = TimeOfDay.now();
      final nextMedIndex = allMedications.indexWhere((m) {
        try {
          final medTime = TimeOfDay(hour: int.parse(m.time.split(':')[0]), minute: int.parse(m.time.split(':')[1]));
          return medTime.hour > now.hour || (medTime.hour == now.hour && medTime.minute >= now.minute);
        } catch (e) {
          return false; // Ignorar si el formato de hora es incorrecto
        }
      });

      if (nextMedIndex != -1) {
        // Se encontró un medicamento para más tarde hoy
        nextMed = allMedications[nextMedIndex];
      } else {
        // No hay más medicamentos para hoy, mostrar el primero de la lista (para mañana)
        nextMed = allMedications.first;
      }
    }

    return Card(
      color: Theme.of(context).primaryColor.withOpacity(0.1),
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.alarmClock, size: 32, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('PRÓXIMA TOMA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(nextMed.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('Dosis: ${nextMed.dosage}'),
                          ],
                        ),
                      ),
                      Text(nextMed.time, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      const uuid = Uuid();
                      final now = DateTime.now();
                      final scheduledTime = DateTime(now.year, now.month, now.day, int.parse(nextMed!.time.split(':')[0]), int.parse(nextMed.time.split(':')[1]));
                      
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
                      // Forzar la actualización de la UI mostrando que la toma se ha realizado
                      // (la lógica actual ya coge el siguiente, así que un refresh es suficiente)
                      ref.read(medicationProvider.notifier).loadMedications(patientId);
                    },
                    child: const Text('Marcar como Tomada'),
                  )
                ],
              ),
      ),
    );
  }

  // WIDGET NUEVO: Tarjeta de resumen de pacientes para el cuidador
  Widget _buildPatientSummaryCard(BuildContext context, UserProfile userProfile) {
    final patients = userProfile.managedPatients ?? [];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tus Pacientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (patients.isEmpty)
              const Text('Aún no gestionas a ningún paciente.')
            else
              ...patients.map((p) => ListTile(
                    title: Text(p.name),
                    subtitle: Text('${p.age} años'),
                    trailing: ElevatedButton(
                      child: const Text('Ver Meds'),
                      onPressed: () => context.push('/patient_medications/${p.uid}'),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  // Widget reutilizable para las tarjetas de acción
  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
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
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
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