// Archivo: lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Notificaciones'),
            value: true,
            onChanged: (v) {},
          ),
          ListTile(
            leading: const Icon(LucideIcons.gem),
            title: const Text('Gestión de suscripción'),
            onTap: () {
              context.go('/paywall');
            },
          ),
          ListTile(
            leading: const Icon(LucideIcons.info),
            title: const Text('Acerca de'),
            subtitle: const Text('Versión 0.1.0'),
          ),
        ],
      ),
    );
  }
}