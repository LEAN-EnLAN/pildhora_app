// Archivo: lib/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pastillero_inteligente/models/user_profile.dart'; // Importación correcta

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  UserProfileNotifier() : super(null);

  void login(UserProfile profile) {
    state = profile;
  }

  void logout() {
    state = null;
  }
}

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile?>(
      (ref) => UserProfileNotifier(),
);