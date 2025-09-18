// Archivo: lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pastillero_inteligente/providers/auth_provider.dart';
import 'package:pastillero_inteligente/models/user_profile.dart';

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
              // Navegar a la pantalla de configuración
              context.push('/settings');
            },
          ),
        ],
      ),
      body: userProfile == null
          ? const Center(child: CircularProgressIndicator())
          : _buildUserView(context, userProfile),
    );
  }

  Widget _buildUserView(BuildContext context, UserProfile userProfile) {
    if (userProfile.type == ProfileType.paciente) {
      return _buildPatientView(context);
    } else {
      return _buildCaregiverView(context);
    }
  }

  // Vista para el paciente
  Widget _buildPatientView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hola, ¡cuida de ti!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
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
  Widget _buildCaregiverView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Panel de Cuidador',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
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
            onTap: () => context.push('/add_caregiver'), // <-- ¡Ruta de ejemplo!
          ),
        ],
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