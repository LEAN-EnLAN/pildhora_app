// Archivo: lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Importamos todas las pantallas
import 'package:pastillero_inteligente/screens/home_screen.dart';
import 'package:pastillero_inteligente/screens/pairing_screen.dart';
import 'package:pastillero_inteligente/screens/history_screen.dart';
import 'package:pastillero_inteligente/screens/paywall_screen.dart';
import 'package:pastillero_inteligente/screens/settings_screen.dart';
import 'package:pastillero_inteligente/screens/login_screen.dart';
import 'package:pastillero_inteligente/screens/caregiver_panel_screen.dart'; // Pantalla del cuidador

// Importamos nuestros providers
import 'package:pastillero_inteligente/providers/auth_provider.dart';
import 'package:pastillero_inteligente/models/user_profile.dart';

void main() {
  runApp(const ProviderScope(child: PildhoraApp()));
}

class PildhoraApp extends ConsumerWidget {
  const PildhoraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observamos el estado del perfil del usuario
    final userProfile = ref.watch(userProfileProvider);

    // Configuración del router para la navegación
    final router = GoRouter(
      // Redirecciona según el estado de autenticación del usuario
      redirect: (BuildContext context, GoRouterState state) {
        final isLoggingIn = state.uri.toString() == '/login';

        // Si no hay usuario logueado y no está en la pantalla de login, redirige al login
        if (userProfile == null && !isLoggingIn) {
          return '/login';
        }

        // Si hay usuario logueado y está intentando ir al login, redirige al home
        if (userProfile != null && isLoggingIn) {
          return '/';
        }

        // Si no hay ninguna condición especial, permite la navegación normal
        return null;
      },
      routes: [
        // Ruta para la pantalla de login
        GoRoute(
          path: '/login',
          builder: (c, s) => const LoginScreen(),
        ),
        // Ruta principal (Home)
        GoRoute(
          path: '/',
          builder: (c, s) => const HomeScreen(),
        ),
        // Ruta para vincular dispositivo
        GoRoute(
          path: '/pair',
          builder: (c, s) => const PairingScreen(),
        ),
        // Ruta para ver el historial
        GoRoute(
          path: '/history',
          builder: (c, s) => const HistoryScreen(),
        ),
        // Ruta para la pantalla de suscripción (Paywall)
        GoRoute(
          path: '/paywall',
          builder: (c, s) => const PaywallScreen(),
        ),
        // Ruta para la configuración
        GoRoute(
          path: '/settings',
          builder: (c, s) => const SettingsScreen(),
        ),
        // Ruta para el panel del cuidador
        GoRoute(
          path: '/caregiver_panel',
          builder: (c, s) => const CaregiverPanelScreen(),
        ),
      ],
    );

    // Configuración de MaterialApp.router con el tema y el router
    return MaterialApp.router(
      title: 'Pildhora App',
      theme: ThemeData(
        // 🎨 Colores del tema
        primaryColor: const Color(0xFF7D2AE8), // Púrpura de Canva
        primarySwatch: const MaterialColor(0xFF7D2AE8, <int, Color>{
          50: Color(0xFFEFE8FD), 100: Color(0xFFD6C8F8), 200: Color(0xFFBCAAF3),
          300: Color(0xFFA28CEC), 400: Color(0xFF8E77E7), 500: Color(0xFF7D2AE8),
          600: Color(0xFF7226D1), 700: Color(0xFF6522B9), 800: Color(0xFF591F9D),
          900: Color(0xFF4C1C82),
        }),
        scaffoldBackgroundColor: const Color(0xFFF9F9F9), // Fondo claro

        // ✍️ Tipografía
        fontFamily: 'Montserrat',
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1D1D1F)),
          bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF1D1D1F)),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF6E6E73)),
        ),

        // 🚀 Estilo de botones elevados
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7D2AE8), // Púrpura
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          ),
        ),

        // 📜 Estilo de AppBars
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF7D2AE8), // Púrpura
          foregroundColor: Colors.white,
          elevation: 0, // Sin sombra
          titleTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // 📦 Estilo de Cards
        cardTheme: CardThemeData(
          elevation: null, // Sin sombra
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            // Borde sutil
            side: const BorderSide(color: Color(0xFFE5E5E5), width: 1),
          ),
          color: Colors.white, // Fondo blanco para cards
        ),

        // 📝 Estilo de campos de texto (InputDecorationTheme)
        inputDecorationTheme: InputDecorationTheme(
          filled: true, // Relleno
          fillColor: const Color(0xFFF1F1F1), // Color de relleno suave
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Bordes redondeados
            borderSide: BorderSide.none, // Sin borde visible por defecto
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            // Borde púrpura al enfocar
            borderSide: const BorderSide(color: Color(0xFF7D2AE8), width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF6E6E73)), // Color del label
        ),
      ),
      // Configuración del router
      routerConfig: router,
    );
  }
}