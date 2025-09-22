/// Represents a single medication with its scheduling details.
class Medication {
  /// A unique identifier for the medication.
  final String id;

  /// The ID of the patient this medication belongs to.
  final String patientId;

  /// The name of the medication.
  final String name;

  /// The dosage for a single intake (e.g., "1 pill", "10mg").
  final String dosage;

  /// The scheduled time for the intake, in HH:mm format.
  final String time;

  /// Creates a new [Medication] instance.
  Medication({
    required this.id,
    required this.patientId,
    required this.name,
    required this.dosage,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'name': name,
      'dosage': dosage,
      'time': time,
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'],
      patientId: map['patientId'],
      name: map['name'],
      dosage: map['dosage'],
      time: map['time'],
    );
  }
}
