import 'package:flutter/material.dart';


class AddCaregiverScreen extends StatelessWidget {
  const AddCaregiverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Cuidador'),
      ),
      body: const Center(
        child: Text('Pantalla para agregar un nuevo cuidador.'),
      ),
    );
  }
}
