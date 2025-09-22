import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:pastillero_inteligente/models/user_profile.dart';
import 'package:pastillero_inteligente/providers/auth_provider.dart';

class CaregiverPanelScreen extends ConsumerWidget {
  const CaregiverPanelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    if (userProfile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List<PatientInfo> patients = userProfile.managedPatients ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Cuidador'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (userProfile.isPrincipalCuidador)
            IconButton(
              icon: const Icon(LucideIcons.userPlus),
              tooltip: 'Añadir paciente',
              onPressed: () => context.push('/add_caregiver'),
            ),
        ],
      ),
      body: patients.isEmpty
          ? const Center(
              child: Text(
                'No tienes pacientes asignados.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        patient.name.substring(0, 1),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(patient.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Edad: ${patient.age} años'),
                    trailing: const Icon(LucideIcons.chevronRight),
                    onTap: () => context.push('/patient_details/${patient.uid}'),
                  ),
                );
              },
            ),
    );
  }
}