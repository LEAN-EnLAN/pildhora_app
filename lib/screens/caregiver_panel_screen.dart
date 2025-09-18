// Archivo: lib/screens/caregiver_panel_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pastillero_inteligente/providers/auth_provider.dart';

// Provider para obtener el número de cuidadores gestionados
final caregiverCountProvider = Provider<int>((ref) {
  final userProfile = ref.watch(userProfileProvider);
  // Usamos la longitud de la lista de nombres de cuidadores gestionados
  return userProfile?.managedCaregiversNames.length ?? 0;
});


class CaregiverPanelScreen extends ConsumerWidget {
  const CaregiverPanelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final caregiverCount = ref.watch(caregiverCountProvider);

    // Límite de cuidadores para la versión gratuita
    const int caregiverLimit = 3;

    if (userProfile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final bool isPrincipal = userProfile.isPrincipalCuidador;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Cuidador'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de información del rol
            Card(
              child: ListTile(
                leading: Icon(isPrincipal ? LucideIcons.crown : LucideIcons.user, color: Theme.of(context).primaryColor),
                title: Text(isPrincipal ? 'Cuidador Principal' : 'Cuidador Normal'),
                subtitle: Text(isPrincipal
                    ? 'Puedes gestionar a otros cuidadores.'
                    : 'Asistes al cuidador principal.'),
              ),
            ),
            const SizedBox(height: 20),

            // Sección "Mi Paciente"
            const Text('Gestión del Paciente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(LucideIcons.userCircle),
                title: Text(userProfile.mockPatientName),
                subtitle: Text('${userProfile.mockPatientAge} años'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.go('/patient_details');
                },
              ),
            ),
            const SizedBox(height: 20),

            // Opciones solo para el Cuidador Principal
            if (isPrincipal) ...[
              const Text('Gestión de Cuidadores', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              // Opción para agregar un nuevo cuidador
              Card(
                child: ListTile(
                  leading: const Icon(LucideIcons.userPlus),
                  title: const Text('Agregar nuevo cuidador'),
                  subtitle: Text('$caregiverCount de $caregiverLimit cuidadores agregados'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    if (caregiverCount < caregiverLimit) {
                      context.go('/add_caregiver');
                    } else {
                      // Si se alcanza el límite, ir a la pantalla de paywall
                      context.go('/paywall');
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),

              // Lista de cuidadores gestionados
              ...userProfile.managedCaregiversNames.map((name) {
                return Card(
                  margin: const EdgeInsets.only(top: 8.0),
                  child: ListTile(
                    leading: const Icon(LucideIcons.user, color: Colors.grey),
                    title: Text(name),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'promote') {
                          // TODO: Implementar la lógica para convertir en cuidador principal.
                          // Esto implicaría:
                          // 1. Cambiar `isPrincipalCuidador` de este usuario a `true`.
                          // 2. Cambiar `isPrincipalCuidador` del cuidador actual (el que usa la app) a `false`.
                          // 3. Actualizar ambos perfiles en la base de datos/estado.
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('TODO: Promover a $name')),
                          );
                        } else if (value == 'delete') {
                          // TODO: Implementar la lógica para eliminar al cuidador.
                          // Esto implicaría:
                          // 1. Eliminar el nombre de la lista `managedCaregiversNames`.
                          // 2. Eliminar/desvincular el perfil de usuario del cuidador.
                          // 3. Actualizar el perfil en la base de datos/estado.
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('TODO: Eliminar a $name')),
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'promote',
                          child: Text('Convertir en Cuidador Principal'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Eliminar Cuidador'),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }
}
