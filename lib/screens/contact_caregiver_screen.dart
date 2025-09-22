import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pastillero_inteligente/providers/auth_provider.dart';

class ContactCaregiverScreen extends ConsumerWidget {
  const ContactCaregiverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final caregiver = userProfile?.caregiverInfo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactar Cuidador'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(LucideIcons.phoneCall, size: 80, color: Theme.of(context).primaryColor),
              const SizedBox(height: 20),
              const Text(
                'Información de contacto de tu cuidador:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              caregiver != null
                  ? Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nombre: ${caregiver.name}', style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 8),
                            Text('Teléfono: ${caregiver.phone}', style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 8),
                            Text('Email: ${caregiver.email}', style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    )
                  : const Text('No tienes un cuidador asignado.'),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(LucideIcons.messageSquare),
                label: const Text('Enviar Mensaje Rápido'),
                onPressed: () {
                  // TODO: Implementar la lógica para enviar un mensaje
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Funcionalidad "Enviar Mensaje" pendiente.')),
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