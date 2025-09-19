import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Importamos todas las pantallas
import 'package:pastillero_inteligente/screens/add_caregiver_screen.dart';
import 'package:pastillero_inteligente/screens/home_screen.dart';
import 'package:pastillero_inteligente/screens/pairing_screen.dart';
import 'package:pastillero_inteligente/screens/history_screen.dart';
import 'package:pastillero_inteligente/screens/paywall_screen.dart';
import 'package:pastillero_inteligente/screens/settings_screen.dart';
import 'package:pastillero_inteligente/screens/login_screen.dart';
import 'package:pastillero_inteligente/screens/caregiver_panel_screen.dart';
import 'package:pastillero_inteligente/screens/contact_caregiver_screen.dart';
import 'package:pastillero_inteligente/screens/patient_details_screen.dart';
import 'package:pastillero_inteligente/screens/device_settings_screen.dart';
import 'package:pastillero_inteligente/screens/patient_medications_screen.dart';
import 'package:pastillero_inteligente/screens/add_medication_screen.dart';
import 'package:pastillero_inteligente/screens/edit_medication_screen.dart';

// Importamos nuestros providers
import 'package:pastillero_inteligente/providers/auth_provider.dart';
import 'package:pastillero_inteligente/providers/medication_provider.dart';

import 'package:pastillero_inteligente/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await NotificationService().requestPermissions();
  runApp(const ProviderScope(child: PildhoraApp()));
}

class PildhoraApp extends ConsumerWidget {
  const PildhoraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(userProfileProvider);

    final router = GoRouter(
      refreshListenable: ValueNotifier<bool>(authState != null),
      redirect: (BuildContext context, GoRouterState state) {
        final isLoggingIn = state.uri.toString() == '/login';
        final hasUser = authState != null;

        if (!hasUser && !isLoggingIn) {
          return '/login';
        }
        if (hasUser && isLoggingIn) {
          return '/';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (c, s) => const LoginScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (c, s) => const HomeScreen(),
        ),
        GoRoute(
          path: '/pair',
          builder: (c, s) => const PairingScreen(),
        ),
        GoRoute(
          path: '/history',
          builder: (c, s) => const HistoryScreen(),
        ),
        GoRoute(
          path: '/paywall',
          builder: (c, s) => const PaywallScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (c, s) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/caregiver_panel',
          builder: (c, s) => const CaregiverPanelScreen(),
        ),
        GoRoute(
          path: '/add_caregiver',
          builder: (context, state) => const AddCaregiverScreen(),
        ),
        GoRoute(
          path: '/patient_medications/:patientId',
          builder: (context, state) {
            final patientId = state.pathParameters['patientId']!;
            return PatientMedicationsScreen(patientId: patientId);
          },
          routes: [
            GoRoute(
              path: 'add_medication',
              builder: (context, state) {
                final patientId = state.pathParameters['patientId']!;
                return AddMedicationScreen(patientId: patientId);
              },
            ),
            GoRoute(
              path: 'edit/:medicationId',
              builder: (context, state) {
                final medicationId = state.pathParameters['medicationId']!;
                final medication = ref.read(medicationProvider).firstWhere((m) => m.id == medicationId);
                return EditMedicationScreen(medication: medication);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/contact_caregiver',
          builder: (context, state) => const ContactCaregiverScreen(),
        ),
        GoRoute(
          path: '/patient_details/:patientId',
          builder: (context, state) {
            final patientId = state.pathParameters['patientId']!;
            return PatientDetailsScreen(patientId: patientId);
          },
        ),
        GoRoute(
          path: '/device_settings',
          builder: (context, state) => const DeviceSettingsScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Pildhora App',
      theme: ThemeData(
        primaryColor: const Color(0xFF7D2AE8),
        primarySwatch: const MaterialColor(0xFF7D2AE8, <int, Color>{
          50: Color(0xFFEFE8FD), 100: Color(0xFFD6C8F8), 200: Color(0xFFBCAAF3),
          300: Color(0xFFA28CEC), 400: Color(0xFF8E77E7), 500: Color(0xFF7D2AE8),
          600: Color(0xFF7226D1), 700: Color(0xFF6522B9), 800: Color(0xFF591F9D),
          900: Color(0xFF4C1C82),
        }),
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        fontFamily: 'Montserrat',
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1D1D1F)),
          bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF1D1D1F)),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF6E6E73)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7D2AE8),
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
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF7D2AE8),
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFE5E5E5), width: 1),
          ),
          color: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF1F1F1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF7D2AE8), width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF6E6E73)),
        ),
      ),
      routerConfig: router,
    );
  }
}