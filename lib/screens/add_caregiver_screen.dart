// Archivo: lib/screens/add_caregiver_screen.dart

import 'package:flutter/material.dart';

class AddCaregiverScreen extends StatelessWidget {
  const AddCaregiverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Cuidador'),
      ),
      body: const Center(
        child: Text('Pantalla para añadir un nuevo cuidador.'),
      ),
    );
  }
}
