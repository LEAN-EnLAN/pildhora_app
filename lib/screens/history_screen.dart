import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pastillero_inteligente/models/medication_intake.dart';
import 'package:pastillero_inteligente/providers/auth_provider.dart';
import 'package:pastillero_inteligente/services/database_service.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends ConsumerState<HistoryScreen> {
  late Future<List<MedicationIntake>> _intakesFuture;

  @override
  void initState() {
    super.initState();
    final userId = ref.read(userProfileProvider)?.uid;
    if (userId != null) {
      _intakesFuture = DatabaseService.instance.getIntakes(userId);
    } else {
      _intakesFuture = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Tomas'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<List<MedicationIntake>>(
        future: _intakesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.history, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text('No hay registros de tomas.',
                      style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          final intakes = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: intakes.length,
            itemBuilder: (context, index) {
              final intake = intakes[index];
              final formattedTime =
                  DateFormat('HH:mm, dd MMM').format(intake.takenTime);
              return Card(
                child: ListTile(
                  leading:
                      const Icon(LucideIcons.checkCircle, color: Colors.green),
                  title: Text(intake.medicationName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Tomada a las: $formattedTime'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
