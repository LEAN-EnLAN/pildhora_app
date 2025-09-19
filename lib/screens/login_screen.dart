import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pastillero_inteligente/models/user_profile.dart';
import 'package:pastillero_inteligente/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegister = false;

  late AnimationController _logoAnimationController;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;

  late AnimationController _formAnimationController;
  late Animation<Offset> _formSlideAnimation;

  final Map<String, dynamic> _mockUsers = {
    "paciente@test.com": {
      "password": "123",
      "profile": UserProfile(
        uid: "paciente-123",
        name: "Juan Paciente",
        age: 68,
        email: "paciente@test.com",
        type: ProfileType.paciente,
        caregiverInfo: const CaregiverInfo(
          name: "Carlos Cuidador",
          phone: "+1 234 567 890",
          email: "cuidador@test.com",
        ),
      ),
    },
    "cuidador@test.com": {
      "password": "123",
      "profile": UserProfile(
        uid: "cuidador-456",
        name: "Carlos Cuidador",
        age: 45,
        email: "cuidador@test.com",
        type: ProfileType.cuidador,
        role: CaregiverRole.principal,
        managedPatients: const [
          PatientInfo(uid: "paciente-123", name: "Juan Paciente", age: 68),
          PatientInfo(uid: "paciente-789", name: "Maria Paciente", age: 72),
        ],
      ),
    },
  };

  @override
  void initState() {
    super.initState();

    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoAnimationController, curve: Curves.easeIn),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoAnimationController, curve: Curves.elasticOut),
    );

    _formAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _formSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _formAnimationController, curve: Curves.easeInOut),
    );

    _logoAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _formAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _formAnimationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _logoFadeAnimation,
                  child: ScaleTransition(
                    scale: _logoScaleAnimation,
                    child: _buildLogo(theme),
                  ),
                ),
                const SizedBox(height: 24),
                SlideTransition(
                  position: _formSlideAnimation,
                  child: _buildForm(theme),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(ThemeData theme) {
    return Column(
      children: [
        Icon(LucideIcons.pill, size: 80, color: theme.primaryColor),
        const SizedBox(height: 16),
        Text(
          "Pildhora",
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildForm(ThemeData theme) {
    return Column(
      children: [
        Text(
          _isRegister ? "Crear Cuenta" : "Bienvenido de Vuelta",
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 28),
        ),
        const SizedBox(height: 32),
        _buildEmailField(theme),
        const SizedBox(height: 16),
        _buildPasswordField(theme),
        const SizedBox(height: 32),
        _buildLoginButton(theme),
        const SizedBox(height: 16),
        _buildSwitchModeButton(theme),
      ],
    );
  }

  Widget _buildEmailField(ThemeData theme) {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: "Email",
        prefixIcon: Icon(LucideIcons.mail),
      ),
    );
  }

  Widget _buildPasswordField(ThemeData theme) {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "Contraseña",
        prefixIcon: Icon(LucideIcons.lock),
      ),
    );
  }

  Widget _buildLoginButton(ThemeData theme) {
    return ElevatedButton(
      onPressed: _authenticate,
      child: Text(_isRegister ? "Registrarse" : "Iniciar Sesión"),
    );
  }

  Widget _buildSwitchModeButton(ThemeData theme) {
    return TextButton(
      onPressed: () {
        setState(() => _isRegister = !_isRegister);
      },
      child: Text(
        _isRegister
            ? "¿Ya tienes una cuenta? Inicia sesión"
            : "¿No tienes una cuenta? Regístrate",
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}