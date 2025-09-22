import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastillero_inteligente/models/medication.dart';
import 'package:pastillero_inteligente/services/database_service.dart';

/// Manages the state of the medications list, acting as an intermediary
/// between the UI and the [DatabaseService].
class MedicationNotifier extends StateNotifier<List<Medication>> {
  MedicationNotifier() : super([]);

  /// Loads all medications for a specific patient from the database into the state.
  Future<void> loadMedications(String patientId) async {
    final medications = await DatabaseService.instance.getMedications(patientId);
    state = medications;
  }

  /// Adds a new medication to the database and reloads the state.
  Future<void> addMedication(Medication medication) async {
    await DatabaseService.instance.insertMedication(medication);
    await loadMedications(medication.patientId);
  }

  /// Removes a medication from the database and reloads the state.
  Future<void> removeMedication(String medicationId, String patientId) async {
    await DatabaseService.instance.deleteMedication(medicationId);
    await loadMedications(patientId);
  }

  /// Updates an existing medication in the database and reloads the state.
  Future<void> editMedication(Medication updatedMedication) async {
    await DatabaseService.instance.updateMedication(updatedMedication);
    await loadMedications(updatedMedication.patientId);
  }
}

/// The provider that exposes the [MedicationNotifier] to the UI.
final medicationProvider = StateNotifierProvider<MedicationNotifier, List<Medication>>((ref) {
  return MedicationNotifier();
});
