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
    // Obtenemos el perfil del usuario logueado.
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        // Mostramos el tipo de perfil en el título.
        title: Text('Pildhora - ${userProfile?.type.name.capitalize() ?? 'Usuario'}'),
        actions: [
          // Botón para cerrar sesión.
          IconButton(
            onPressed: () {
              // Cerramos sesión y el redirect en main.dart nos llevará al login.
              ref.read(userProfileProvider.notifier).logout();
            },
            icon: const Icon(LucideIcons.logOut),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch, // Centra los elementos horizontalmente
          children: [
            Text(
              '¡Bienvenido a Pildhora!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 32),

            // Opciones comunes para todos los usuarios
            _buildActionCard(
              context,
              icon: LucideIcons.bluetooth,
              title: 'Vincular dispositivo',
              route: '/pair',
              color: Colors.teal,
            ),
            _buildActionCard(
              context,
              icon: LucideIcons.history,
              title: 'Historial de tomas',
              route: '/history',
              color: Colors.blueGrey,
            ),
            _buildActionCard(
              context,
              icon: LucideIcons.settings,
              title: 'Configuración',
              route: '/settings',
              color: Colors.grey,
            ),

            // Opciones específicas para el rol de Cuidador
            if (userProfile?.type == ProfileType.cuidador) ...[
              _buildActionCard(
                context,
                icon: LucideIcons.users,
                title: 'Panel de Cuidadores',
                route: '/caregiver_panel',
                color: Colors.deepPurple,
              ),
              // Aquí podríamos agregar más opciones si fuera necesario.
            ],

            // Opciones específicas para el rol de Paciente
            if (userProfile?.type == ProfileType.paciente) ...[
              _buildActionCard(
                context,
                icon: LucideIcons.pill,
                title: 'Mis Medicamentos',
                route: '/my_medications', // Ruta de ejemplo, aún no creada
                color: Colors.orange,
              ),
              _buildActionCard(
                context,
                icon: LucideIcons.phone,
                title: 'Contactar Cuidador',
                route: '/contact_caregiver', // Ruta de ejemplo, aún no creada
                color: Colors.pinkAccent,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para crear las tarjetas de acción de forma reutilizable.
  Widget _buildActionCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String route,
        required Color color, // Añadimos color para diferenciar visualmente
      }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4, // Sombra para destacar la tarjeta
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Bordes redondeados
      child: ListTile(
        leading: Icon(icon, color: color, size: 28), // Icono con color temático
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400),
        onTap: () => context.go(route),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

// Extensión para capitalizar la primera letra de un String.
extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return this[0].toUpperCase() + this.substring(1);
  }
}