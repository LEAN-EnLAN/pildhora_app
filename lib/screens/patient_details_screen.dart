import 'package:flutter/material.dart';

class PatientDetailsScreen extends StatelessWidget {
  const PatientDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Paciente'),
      ),
      body: const Center(
        child: Text('Pantalla para mostrar los detalles del paciente.'),
      ),
    );
  }
}
