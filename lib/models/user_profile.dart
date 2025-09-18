// Archivo: lib/models/user_profile.dart

class UserProfile {
  final String uid;
  final String? email;
  final String role; // 'paciente' o 'cuidador'
  final bool isPrincipalCuidador;

  // Mock data for UI prototyping
  final String mockPatientName;
  final int mockPatientAge;
  final List<String> managedCaregiversNames;

  UserProfile({
    required this.uid,
    this.email,
    this.role = 'paciente',
    this.isPrincipalCuidador = false,
    this.mockPatientName = 'Paciente Asignado',
    this.mockPatientAge = 0,
    this.managedCaregiversNames = const [],
  });
}
