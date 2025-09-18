// Archivo: lib/screens/caregiver_panel_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package.pastillero_inteligente/models/user_profile.dart';
import 'package:pastillero_inteligente/providers/auth_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

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

    // AHORA: Obtenemos la lista de pacientes del perfil del cuidador
    final List<PatientInfo> patients = userProfile.managedPatients ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Cuidador'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // AHORA: Usamos el nuevo getter 'isPrincipalCuidador'
          if (userProfile.isPrincipalCuidador)
            IconButton(
              icon: const Icon(LucideIcons.userPlus),
              tooltip: 'Añadir paciente',
              onPressed: () {
                // Lógica para añadir paciente
              },
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
              // AHORA: Usamos los datos de la lista de pacientes
              title: Text(patient.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Edad: ${patient.age} años'),
              trailing: const Icon(LucideIcons.chevronRight),
              onTap: () {
                // TODO: Navegar a la pantalla de detalles del paciente
              },
            ),
          );
        },
      ),
    );
  }
}