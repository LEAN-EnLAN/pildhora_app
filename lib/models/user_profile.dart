// Archivo: lib/models/user_profile.dart

enum ProfileType {
  paciente,
  cuidador,
}

enum CaregiverRole {
  principal,
  normal,
}

class UserProfile {
  final String email;
  final ProfileType type;
  final CaregiverRole? role;

  UserProfile({
    required this.email,
    required this.type,
    this.role,
  });

  bool get isPrincipalCuidador => type == ProfileType.cuidador && role == CaregiverRole.principal;
  bool get isPaciente => type == ProfileType.paciente;
}