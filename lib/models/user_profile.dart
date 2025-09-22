// Archivo: lib/models/user_profile.dart

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

// Clase para almacenar la información de contacto de un cuidador.
@immutable
class CaregiverInfo {
  final String name;
  final String phone;
  final String email;

  const CaregiverInfo({
    required this.name,
    required this.phone,
    required this.email,
  });
}

// NUEVA CLASE: Para representar la información básica de un paciente gestionado.
@immutable
class PatientInfo {
  final String uid;
  final String name;
  final int age;

  const PatientInfo({
    required this.uid,
    required this.name,
    required this.age,
  });
}


@immutable
class UserProfile {
  final String uid;
  final String name;
  final int age;
  final String email;
  final ProfileType type;
  final CaregiverRole? role; // Solo para cuidadores
  final CaregiverInfo? caregiverInfo; // Info del cuidador asignado al paciente
  final List<PatientInfo>? managedPatients; // Lista de pacientes para un cuidador

  const UserProfile({
    required this.uid,
    required this.name,
    required this.age,
    required this.email,
    required this.type,
    this.role,
    this.caregiverInfo,
    this.managedPatients,
  });

  bool get isPrincipalCuidador => role == CaregiverRole.principal;

  UserProfile copyWith({
    String? uid,
    String? name,
    int? age,
    String? email,
    ProfileType? type,
    ValueGetter<CaregiverRole?>? role,
    ValueGetter<CaregiverInfo?>? caregiverInfo,
    List<PatientInfo>? managedPatients,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      age: age ?? this.age,
      email: email ?? this.email,
      type: type ?? this.type,
      role: role != null ? role() : this.role,
      caregiverInfo: caregiverInfo != null ? caregiverInfo() : this.caregiverInfo,
      managedPatients: managedPatients ?? this.managedPatients,
    );
  }
}