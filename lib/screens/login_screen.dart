// Archivo: lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:pastillero_inteligente/models/user_profile.dart';
import 'package:pastillero_inteligente/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegister = false;

  final Map<String, dynamic> _mockUsers = {
    "paciente@test.com": {
      "password": "123",
      "profile": UserProfile(email: "paciente@test.com", type: ProfileType.paciente),
    },
    "cuidador@test.com": {
      "password": "123",
      "profile": UserProfile(
        email: "cuidador@test.com",
        type: ProfileType.cuidador,
        role: CaregiverRole.principal,
      ),
    },
  };

  void _authenticate() {
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();

    if (_isRegister) {
      if (_mockUsers.containsKey(email)) {
        _showSnack("El usuario ya existe");
      } else {
        _showSnack("No se puede registrar en la demo");
      }
      return;
    }

    if (_mockUsers.containsKey(email) && _mockUsers[email]['password'] == pass) {
      final userProfile = _mockUsers[email]['profile'] as UserProfile;
      ref.read(userProfileProvider.notifier).login(userProfile);
      _showSnack("Bienvenido ${userProfile.email} 👋");
    } else {
      _showSnack("Credenciales inválidas");
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.pill, size: 64, color: Color(0xFF00796B)),
                const SizedBox(height: 16),
                Text(
                  _isRegister ? "Crear cuenta" : "Iniciar sesión",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1D1F),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _authenticate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C4CC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _isRegister ? "Registrarse" : "Iniciar sesión",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() => _isRegister = !_isRegister);
                  },
                  child: Text(_isRegister
                      ? "¿Ya tienes cuenta? Inicia sesión"
                      : "¿No tienes cuenta? Regístrate"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}