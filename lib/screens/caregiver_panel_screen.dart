// Archivo: lib/screens/caregiver_panel_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pastillero_inteligente/providers/auth_provider.dart'; // Necesitas userProfileProvider
import 'package:pastillero_inteligente/models/user_profile.dart'; // Necesitas el modelo UserProfile con isPrincipalCuidador

// Ejemplo de Provider para obtener la lista de cuidadores (necesitarás implementarlo y ajustarlo)
// Este provider podría devolver una lista de objetos Caregiver o simplemente sus IDs/emails.
// final associatedCaregiversProvider = Provider<List<String>>((ref) {
//   // Lógica para obtener los cuidadores asociados al paciente del usuario actual.
//   // Esto podría venir del perfil del usuario, del perfil del paciente, o de una colección separada.
//   // Ejemplo muy básico:
//   // final user = ref.watch(userProfileProvider);
//   // if (user != null && user.isPrincipalCuidador) {
//   //   // Simula la carga de cuidadores asociados (excluyendo al principal)
//   //   return ["cuidador_secundario1@example.com", "cuidador_secundario2@example.com"];
//   // }
//   return []; // Devuelve una lista vacía si no es principal o no hay asociados
// });

class CaregiverPanelScreen extends ConsumerWidget {
  const CaregiverPanelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    // Determina si el usuario actual es el cuidador principal.
    // Asegúrate de que tu modelo UserProfile tenga esta propiedad.
    final isPrincipal = userProfile?.isPrincipalCuidador ?? false;

    // --- Datos de Ejemplo (Reemplazar con lógica real/providers) ---
    // Datos del paciente (deberían obtenerse a través de un provider basado en el usuario/cuidador)
    const String patientId = "patientXYZ789"; // ID único del paciente
    const String patientName = "Elena Morales";
    const int patientAge = 82;

    // Número de cuidadores asociados (excluyendo al principal si isPrincipal es true)
    // Esto debería venir de un provider que liste los cuidadores secundarios/invitados.
    // final List<String> secondaryCaregivers = ref.watch(associatedCaregiversProvider);
    // final int numberOfSecondaryCaregivers = secondaryCaregivers.length;

    // Para este ejemplo, simularemos:
    final int numberOfSecondaryCaregivers = 1; // Simula 1 cuidador secundario

    // El número total de cuidadores es el principal (si aplica) + los secundarios.
    final int totalCaregiversCount = (isPrincipal ? 1 : 0) + numberOfSecondaryCaregivers;

    // Límite de cuidadores para el plan actual (esto podría venir de configuración o del perfil)
    const int maxCaregiversAllowedOnCurrentPlan = 3;
    // --- Fin Datos de Ejemplo ---

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Cuidadores'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rol: ${isPrincipal ? 'Cuidador Principal' : 'Cuidador Normal'}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(LucideIcons.userCircle2, color: Color(0xFF7D2AE8), size: 36),
                title: const Text('Mi Paciente', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('$patientName - $patientAge años'),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  // NAVEGAR A LA PANTALLA DEL PACIENTE
                  // Asegúrate de que la ruta '/patient_details/:patientId' exista en tu GoRouter
                  // y que la pantalla PatientDetailsScreen pueda recibir un patientId.
                  context.go('/patient_details/$patientId');
                },
              ),
            ),
            if (isPrincipal) ...[
              const SizedBox(height: 24),
              Text(
                'Gestión de Cuidadores',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Aquí podrías listar los cuidadores secundarios existentes
              // Ejemplo de cómo podrías listar:
              // if (secondaryCaregivers.isNotEmpty)
              //   ...secondaryCaregivers.map((email) => Card(
              //     child: ListTile(
              //       leading: Icon(LucideIcons.userCheck, color: Colors.green),
              //       title: Text(email),
              //       // Podrías añadir opción para remover cuidador
              //     ),
              //   )),
              // const SizedBox(height: 10),
              Card(
                elevation: 2,
                child: ListTile(
                  leading: const Icon(LucideIcons.userPlus, color: Color(0xFF7D2AE8), size: 36),
                  title: const Text('Agregar Nuevo Cuidador', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    // LÓGICA PARA AGREGAR UN CUIDADOR
                    if (totalCaregiversCount >= maxCaregiversAllowedOnCurrentPlan) {
                      // Si el límite se ha alcanzado (contando al principal y a los secundarios), dirigir a paywall
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Límite de $maxCaregiversAllowedOnCurrentPlan cuidadores alcanzado. Actualiza tu plan.'),
                          backgroundColor: Colors.orangeAccent,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      context.go('/paywall');
                    } else {
                      // Navegar a la pantalla para agregar un cuidador.
                      // Asegúrate de que la ruta '/caregiver_panel/add_caregiver' existe.
                      context.go('/caregiver_panel/add_caregiver_screen');
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              // LÓGICA PARA MOSTRAR MENSAJE DE PAYWALL O ESTADO DEL LÍMITE
              if (totalCaregiversCount >= maxCaregiversAllowedOnCurrentPlan)
                Card(
                  color: Colors.amber[50], // Un color sutil de advertencia
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(LucideIcons.lock, color: Colors.orange[700], size: 30),
                      title: Text(
                        'Límite de Cuidadores Alcanzado',
                        style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Has alcanzado el límite de $maxCaregiversAllowedOnCurrentPlan cuidadores para tu plan actual. Para agregar más, por favor actualiza tu suscripción.',
                        style: TextStyle(color: Colors.orange[700]),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.orange[700]),
                      isThreeLine: true, // Permite que el subtítulo ocupe más espacio si es necesario
                      onTap: () {
                        // Navegar a la pantalla de Paywall
                        context.go('/paywall');
                      },
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: Text(
                    'Puedes agregar ${maxCaregiversAllowedOnCurrentPlan - totalCaregiversCount} cuidador(es) más con tu plan actual. (Total actual: $totalCaregiversCount de $maxCaregiversAllowedOnCurrentPlan)',
                    style: TextStyle(color: Colors.grey[700], fontStyle: FontStyle.italic),
                  ),
                ),
            ],
            // Si no es principal, podría mostrar quién es el cuidador principal u otra info relevante
            if (!isPrincipal && userProfile != null) ...[
              const SizedBox(height: 24),
              Text(
                'Información Adicional',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                child: ListTile(
                  leading: Icon(LucideIcons.shieldCheck, color: Colors.blue[600], size: 36),
                  title: Text('Cuidador Principal Asignado', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(userProfile.principalCaregiverEmail ?? 'No especificado'), // Asume que tienes esta info en UserProfile
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
