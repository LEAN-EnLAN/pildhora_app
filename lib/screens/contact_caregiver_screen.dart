// Archivo: lib/screens/contact_caregiver_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ContactCaregiverScreen extends StatelessWidget {
  const ContactCaregiverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactar Cuidador'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () =>
              Navigator.of(context).pop(), // O usa GoRouter si prefieres
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(LucideIcons.phoneCall, size: 80, color: Theme
                  .of(context)
                  .primaryColor),
              const SizedBox(height: 20),
              const Text(
                'Información de contacto de tu cuidador:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Ejemplo de información de contacto (puedes cargarla dinámicamente)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nombre: [Nombre del Cuidador]',
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Teléfono: [Número del Cuidador]',
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Email: [Email del Cuidador]',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(LucideIcons.messageSquare),
                label: const Text('Enviar Mensaje Rápido'),
                onPressed: () {
                  // TODO: Implementar la lógica para enviar un mensaje
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(
                        'Funcionalidad "Enviar Mensaje" pendiente.')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
