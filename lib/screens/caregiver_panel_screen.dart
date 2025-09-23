import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:pastillero_inteligente/models/user_profile.dart';
import 'package:pastillero_inteligente/providers/auth_provider.dart';
import 'package:pastillero_inteligente/screens/widgets/caregiver_widgets.dart';

class CaregiverPanelScreen extends ConsumerStatefulWidget {
  const CaregiverPanelScreen({super.key});

  @override
  ConsumerState<CaregiverPanelScreen> createState() =>
      _CaregiverPanelScreenState();
}

class _CaregiverPanelScreenState extends ConsumerState<CaregiverPanelScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);

    if (userProfile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final List<PatientInfo> allPatients = userProfile.managedPatients ?? [];
    final filteredPatients = allPatients
        .where((patient) =>
            patient.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: AdherenceSummaryCard(
                patientIds: allPatients.map((p) => p.uid).toList()),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar paciente...',
                prefixIcon: const Icon(LucideIcons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
          Expanded(
            child: filteredPatients.isEmpty
                ? const Center(
                    child: Text(
                      'No se encontraron pacientes.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: filteredPatients.length,
                    itemBuilder: (context, index) {
                      final patient = filteredPatients[index];
                      return PatientStatusCard(patient: patient);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
