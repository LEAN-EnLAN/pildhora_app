import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pastillero_inteligente/models/user_profile.dart';
import 'package:pastillero_inteligente/providers/auth_provider.dart';
import 'package:pastillero_inteligente/screens/widgets/home_widgets.dart';
import 'package:pastillero_inteligente/widgets/animated_list_item.dart';

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

  Widget _buildUserView(
      BuildContext context, WidgetRef ref, UserProfile userProfile) {
    if (userProfile.type == ProfileType.paciente) {
      return _buildPatientView(context, ref, userProfile);
    } else {
      return _buildCaregiverView(context, ref, userProfile);
    }
  }

  Widget _buildPatientView(
      BuildContext context, WidgetRef ref, UserProfile userProfile) {
    final children = [
      WelcomeHeader(userProfile: userProfile),
      const SizedBox(height: 24),
      NextMedicationCard(patientId: userProfile.uid),
      const SizedBox(height: 24),
      ActionCard(
        icon: LucideIcons.settings2,
        title: 'Configurar Pastillero',
        subtitle: 'Ajustes de tu dispositivo',
        onTap: () => context.push('/device_settings'),
      ),
      const SizedBox(height: 16),
      ActionCard(
        icon: LucideIcons.history,
        title: 'Historial de Tomas',
        subtitle: 'Revisa tus tomas pasadas',
        onTap: () => context.push('/history'),
      ),
      const SizedBox(height: 16),
      ActionCard(
        icon: LucideIcons.phoneCall,
        title: 'Contactar Cuidador',
        subtitle: 'Habla con la persona a tu cargo',
        onTap: () => context.push('/contact_caregiver'),
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(children.length, (index) {
          return AnimatedListItem(index: index, child: children[index]);
        }),
      ),
    );
  }

  Widget _buildCaregiverView(
      BuildContext context, WidgetRef ref, UserProfile userProfile) {
    final children = [
      const Text(
        'Panel de Cuidador',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 24),
      PatientSummaryCard(userProfile: userProfile),
      const SizedBox(height: 24),
      ActionCard(
        icon: LucideIcons.users,
        title: 'Gestionar Pacientes',
        subtitle: 'Ver el estado de tus pacientes',
        onTap: () => context.push('/caregiver_panel'),
      ),
      const SizedBox(height: 16),
      ActionCard(
        icon: LucideIcons.userPlus,
        title: 'Añadir nuevo paciente',
        subtitle: 'Invita a un paciente para cuidarlo',
        onTap: () => context.push('/add_caregiver'),
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(children.length, (index) {
          return AnimatedListItem(index: index, child: children[index]);
        }),
      ),
    );
  }
}
