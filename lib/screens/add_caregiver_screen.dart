// Ejemplo de Pantalla para Agregar Cuidador (necesitarías crear este archivo)
// Archivo: lib/screens/add_caregiver_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddCaregiverScreen extends ConsumerWidget {
  const AddCaregiverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Nuevo Cuidador'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email del Cuidador',
                hintText: 'ejemplo@correo.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text;
                if (email.isNotEmpty) {
                  // Aquí llamarías a tu servicio/provider para agregar el cuidador
                  // Ejemplo: ref.read(caregiverManagementProvider).addCaregiver(email);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invitación enviada a $email (Simulado)')),
                  );
                  // Podrías navegar hacia atrás o a la lista de cuidadores
                  // context.pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, ingresa un email.')),
                  );
                }
              },
              child: const Text('Agregar Cuidador'),
            ),
          ],
        ),
      ),
    );
  }
}

// En tu GoRouter (main.dart), dentro de las rutas de '/caregiver_panel' o como ruta de primer nivel:
/*
GoRoute(
  path: '/caregiver_panel/add_caregiver',
  builder: (context, state) => const AddCaregiverScreen(),
),
// O si es de primer nivel:
// GoRoute(
//   path: '/add_caregiver', // O la ruta que prefieras
//   builder: (context, state) => const AddCaregiverScreen(),
// ),
*/
