// Archivo: lib/screens/home_screen.dart

import 'package.flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pastillero_inteligente/providers/auth_provider.dart';
<<<<<<< Updated upstream
=======
import 'package:pastillero_inteligente/widgets/custom_card.dart';
import 'package:pastillero_inteligente/widgets/medication_list.dart';
>>>>>>> Stashed changes

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    if (userProfile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Lógica para decidir qué vista mostrar
    bool isPatientView = userProfile.role == 'paciente';

    return Scaffold(
      appBar: AppBar(
<<<<<<< Updated upstream
        title: Text(isPatientView ? 'Mi Pildhora' : 'Panel de Cuidador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: isPatientView
              ? _buildPatientView(context)
              : _buildCaregiverView(context),
        ),
=======
        title: const Text('Píldhora App'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings),
            onPressed: () => context.go('/settings'),
          ),
          IconButton(
            icon: const Icon(LucideIcons.logOut),
            onPressed: () {
              ref.read(authProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: userProfile == null
          ? const Center(child: CircularProgressIndicator())
          : userProfile.role == 'paciente'
              ? _buildPatientView(context)
              : _buildCaregiverView(context, ref),
    );
  }

  Widget _buildPatientView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Hola, [Nombre del Paciente]',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          CustomCard(
            title: 'Mi Pastillero',
            icon: LucideIcons.box,
            onTap: () {
              // Navegar a la pantalla del pastillero
            },
          ),
          const SizedBox(height: 16),
          CustomCard(
            title: 'Mis Cuidadores',
            icon: LucideIcons.users,
            onTap: () {
              // Navegar a la pantalla de cuidadores
            },
          ),
          const SizedBox(height: 16),
          const MedicationList(),
        ],
>>>>>>> Stashed changes
      ),
    );
  }

<<<<<<< Updated upstream
  // Vista para el Paciente
  List<Widget> _buildPatientView(BuildContext context) {
    return [
      const Text(
        'Mis Medicamentos',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
=======
  Widget _buildCaregiverView(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Panel de Cuidador',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          CustomCard(
            title: 'Gestionar Paciente',
            icon: LucideIcons.user,
            onTap: () => context.go('/caregiver_panel_screen'),
          ),
          const SizedBox(height: 16),
          CustomCard(
            title: 'Historial de Tomas',
            icon: LucideIcons.history,
            onTap: () => context.go('/history'),
          ),
          const SizedBox(height: 16),
          CustomCard(
            title: 'Vincular Dispositivo',
            icon: LucideIcons.wifi, // Icono de Wifi
            onTap: () => context.go('/pairing'),
          ),
        ],
>>>>>>> Stashed changes
      ),
      const SizedBox(height: 16),
      // Placeholder para la lista de medicamentos
      const Card(
        child: ListTile(
          leading: Icon(LucideIcons.pill),
          title: Text('Aquí irá la lista de medicamentos.'),
        ),
      ),
      const SizedBox(height: 24),
      Card(
        child: ListTile(
          leading: const Icon(LucideIcons.wifi),
          title: const Text('Vincular dispositivo'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/pair'),
        ),
      ),
      Card(
        child: ListTile(
          leading: const Icon(LucideIcons.history),
          title: const Text('Ver historial de tomas'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/history'),
        ),
      ),
      Card(
        child: ListTile(
          leading: const Icon(LucideIcons.users),
          title: const Text('Contactar a mi cuidador'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Lógica para contactar
          },
        ),
      ),
    ];
  }

  // Vista para el Cuidador
  List<Widget> _buildCaregiverView(BuildContext context) {
    return [
      const Text(
        'Panel de Cuidador',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      Card(
        child: ListTile(
          leading: const Icon(LucideIcons.userCheck),
          title: const Text('Gestionar Cuidadores'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/caregiver_panel'),
        ),
      ),
      Card(
        child: ListTile(
          leading: const Icon(LucideIcons.pill),
          title: const Text('Gestionar Medicamentos'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Lógica para gestionar medicamentos del paciente
          },
        ),
      ),
      Card(
        child: ListTile(
          leading: const Icon(LucideIcons.history),
          title: const Text('Ver historial del paciente'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.go('/history'),
        ),
      ),
    ];
  }
}
