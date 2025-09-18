// Archivo: lib/models/user_profile.dart

class UserProfile {
  final String uid;
  final String? email;
  final String? name;
  final String role; // 'paciente', 'cuidador'
  final bool isPrincipalCuidador;
  final String? mockPatientName;
  final int? mockPatientAge;
  final List<String>? managedCaregiversNames;

  UserProfile({
    required this.uid,
    this.email,
    this.name,
    this.role = 'paciente',
    this.isPrincipalCuidador = false,
    this.mockPatientName = 'Paciente Asignado',
    this.mockPatientAge = 0,
    this.managedCaregiversNames = const [],
  });
}
