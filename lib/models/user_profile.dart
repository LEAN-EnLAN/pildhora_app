// Archivo: lib/models/user_profile.dart

<<<<<<< Updated upstream
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
=======
import 'package:flutter/foundation.dart';

// Enum para el tipo de perfil de usuario
enum ProfileType {
  paciente,
  cuidador,
}

// Enum para el rol del cuidador
enum CaregiverRole {
  principal,
  secundario,
}

// NUEVA CLASE para almacenar la información de contacto de un cuidador.
// Esto mantiene el modelo UserProfile más limpio.
@immutable
class CaregiverInfo {
  final String name;
  final String phone;
  final String email;

  const CaregiverInfo({
    required this.name,
    required this.phone,
    required this.email,
>>>>>>> Stashed changes
  });
}


@immutable
class UserProfile {
  final String email;
  final ProfileType type;
  final CaregiverRole? role; // Solo para cuidadores

  // NUEVO CAMPO: Información del cuidador asignado al paciente.
  // Es opcional, ya que un paciente puede no tener un cuidador todavía.
  final CaregiverInfo? caregiverInfo;

  const UserProfile({
    required this.email,
    required this.type,
    this.role,
    this.caregiverInfo, // Añadido al constructor
  });

  // Metodo copyWith para crear una copia del objeto con valores actualizados.
  // Es una buena práctica para objetos inmutables, especialmente con Riverpod.
  UserProfile copyWith({
    String? email,
    ProfileType? type,
    ValueGetter<CaregiverRole?>? role,
    ValueGetter<CaregiverInfo?>? caregiverInfo,
  }) {
    return UserProfile(
      email: email ?? this.email,
      type: type ?? this.type,
      role: role != null ? role() : this.role,
      caregiverInfo: caregiverInfo != null ? caregiverInfo() : this.caregiverInfo,
    );
  }
}