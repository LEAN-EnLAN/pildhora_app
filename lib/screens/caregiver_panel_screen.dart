// Archivo: lib/screens/caregiver_panel_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pastillero_inteligente/providers/auth_provider.dart';

class CaregiverPanelScreen extends ConsumerWidget {
  const CaregiverPanelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    if (userProfile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Panel de Cuidadores')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final isPrincipal = userProfile.isPrincipalCuidador;
    final managedCaregivers = userProfile.managedCaregiversNames ?? [];
    final caregiverCount = managedCaregivers.length;
    final patientName = userProfile.mockPatientName ?? 'Paciente Asignado';
    final patientAge = userProfile.mockPatientAge;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Cuidadores'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rol: ${isPrincipal ? 'Cuidador Principal' : 'Cuidador Normal'}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                child: ListTile(
                  leading: const Icon(LucideIcons.userCircle2),
                  title: Text(patientName),
                  subtitle: Text(patientAge != null && patientAge > 0
                      ? '$patientAge años'
                      : 'Edad no disponible'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    context.go('/patient_details_screen');
                  },
                ),
              ),
              if (isPrincipal) ...[
                const SizedBox(height: 24),
                Text(
                  'Gestión de Cuidadores',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(LucideIcons.userPlus),
                    title: const Text('Agregar nuevo cuidador'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      if (caregiverCount < 3) { // Límite de ejemplo para mockup
                        context.go('/add_caregiver');
                      } else {
                        context.go('/paywall');
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                if (managedCaregivers.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Cuidadores Agregados:',
                       style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: managedCaregivers.length,
                  itemBuilder: (context, index) {
                    final caregiverName = managedCaregivers[index];
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        leading: const Icon(LucideIcons.user),
                        title: Text(caregiverName),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'make_principal') {
                              // TODO: Lógica para convertir a $caregiverName en principal
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('TODO: Convertir a $caregiverName en principal')),
                              );
                            } else if (value == 'remove') {
                              // TODO: Lógica para eliminar a $caregiverName
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('TODO: Eliminar a $caregiverName')),
                              );
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'make_principal',
                              child: ListTile(
                                leading: Icon(LucideIcons.crown),
                                title: Text('Convertir en Principal'),
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'remove',
                              child: ListTile(
                                leading: Icon(LucideIcons.userMinus, color: Colors.red),
                                title: Text('Eliminar Cuidador', style: TextStyle(color: Colors.red)),
                              ),
                            ),
                          ],
                          icon: const Icon(Icons.more_vert),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
