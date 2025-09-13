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
  final CaregiverRole? role; // Rol del cuidador (principal o normal)
  final String? principalCaregiverEmail; // Email del cuidador principal asociado

  UserProfile({
    required this.email,
    required this.type,    this.role,
    this.principalCaregiverEmail, // Nuevo campo
  }) {
    // Validación: solo los cuidadores deben tener un rol.
    if (type != ProfileType.cuidador && role != null) {
      throw ArgumentError('Solo los perfiles de tipo Cuidador pueden tener un rol.');
    }
    // Validación: el rol es obligatorio si el tipo es cuidador.
    if (type == ProfileType.cuidador && role == null) {
      throw ArgumentError('Los perfiles de tipo Cuidador deben tener un rol especificado (principal o normal).');
    }
    // Validación: principalCaregiverEmail solo tiene sentido si no eres el principal o eres paciente
    if (type == ProfileType.cuidador && role == CaregiverRole.principal && principalCaregiverEmail != null) {
      // Un cuidador principal no debería tener este campo apuntando a otro (o a sí mismo innecesariamente)
      // Podrías permitir que apunte a sí mismo si simplifica alguna lógica, pero generalmente es redundante.
      // Aquí decidimos que no debería estar presente para el principal.
      // print('Advertencia: principalCaregiverEmail no es necesario para un Cuidador Principal.');
      // O lanzar un error si es una restricción estricta:
      // throw ArgumentError('Un Cuidador Principal no debe tener un principalCaregiverEmail asignado.');
    }
  }

  // Determina si el usuario es un cuidador principal.
  bool get isPrincipalCuidador => type == ProfileType.cuidador && role == CaregiverRole.principal;

  // Determina si el usuario es un paciente.
  bool get isPaciente => type == ProfileType.paciente;

  // Determina si el usuario es un cuidador normal (no principal).
  bool get isNormalCuidador => type == ProfileType.cuidador && role == CaregiverRole.normal;

  // Método de fábrica para crear una copia con algunos campos actualizados (opcional pero útil)
  UserProfile copyWith({
    String? email,
    ProfileType? type,
    CaregiverRole? role,
    String? principalCaregiverEmail,
    bool allowNullRole = false, // Para casos donde temporalmente se quiera limpiar el rol
  }) {
    return UserProfile(
      email: email ?? this.email,
      type: type ?? this.type,
      // Si el nuevo tipo no es cuidador, el rol debe ser null
      role: (type ?? this.type) == ProfileType.cuidador
          ? (allowNullRole ? role : (role ?? this.role))
          : null,
      principalCaregiverEmail: principalCaregiverEmail ?? this.principalCaregiverEmail,
    );
  }

  // Ejemplo de serialización/deserialización (si usas Firestore, JSON, etc.)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'type': type.name, // Guardar el nombre del enum para legibilidad
      'role': role?.name,
      'principalCaregiverEmail': principalCaregiverEmail,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      email: json['email'] as String,
      type: ProfileType.values.byName(json['type'] as String),
      role: json['role'] != null ? CaregiverRole.values.byName(json['role'] as String) : null,
      principalCaregiverEmail: json['principalCaregiverEmail'] as String?,
    );
  }
}
