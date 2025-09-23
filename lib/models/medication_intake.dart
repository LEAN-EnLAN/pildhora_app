/// Represents the status of a medication intake.
enum IntakeStatus { taken, missed, skipped }

/// Represents a single event of a user taking a medication.
class MedicationIntake {
  /// A unique identifier for this intake event.
  final String id;

  /// The ID of the medication that was taken.
  final String medicationId;

  /// The name of the medication, denormalized for easier display in history.
  final String medicationName;

  /// The ID of the patient who took the medication.
  final String patientId;

  /// The time the medication was scheduled to be taken.
  final DateTime scheduledTime;

  /// The actual time the medication was marked as taken.
  final DateTime takenTime;

  /// The status of the intake (e.g., taken, missed).
  final IntakeStatus status;

  /// Creates a new [MedicationIntake] instance.
  MedicationIntake({
    required this.id,
    required this.medicationId,
    required this.medicationName,
    required this.patientId,
    required this.scheduledTime,
    required this.takenTime,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicationId': medicationId,
      'medicationName': medicationName,
      'patientId': patientId,
      'scheduledTime': scheduledTime.toIso8601String(),
      'takenTime': takenTime.toIso8601String(),
      'status': status.toString(),
    };
  }

  factory MedicationIntake.fromMap(Map<String, dynamic> map) {
    return MedicationIntake(
      id: map['id'],
      medicationId: map['medicationId'],
      medicationName: map['medicationName'],
      patientId: map['patientId'],
      scheduledTime: DateTime.parse(map['scheduledTime']),
      takenTime: DateTime.parse(map['takenTime']),
      status:
          IntakeStatus.values.firstWhere((e) => e.toString() == map['status']),
    );
  }
}
