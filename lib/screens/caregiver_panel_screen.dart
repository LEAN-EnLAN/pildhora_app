// Archivo: lib/screens/caregiver_panel_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pastillero_inteligente/providers/auth_provider.dart';
import 'package:pastillero_inteligente/models/user_profile.dart';


class CaregiverPanelScreen extends ConsumerWidget {
  const CaregiverPanelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final isPrincipal = userProfile?.isPrincipalCuidador ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Cuidadores'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rol: ${isPrincipal ? 'Cuidador Principal' : 'Cuidador Normal'}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(LucideIcons.user),
                title: const Text('Mi Paciente'),
                subtitle: const Text('María García - 76 años'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Navegar a la pantalla del paciente.
                },
              ),
            ),
            if (isPrincipal) ...[
              SizedBox(height: 24),
              Text(
                'Gestión de Cuidadores',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(LucideIcons.userPlus),
                  title: const Text('Agregar nuevo cuidador'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Lógica para agregar un cuidador.
                  },
                ),
              ),
            ],
            // TODO: Agregar más lógica para más de 3 cuidadores (Paywall)
          ],
        ),
      ),
    );
  }
}