import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final history = [
      {'medication': 'Ibuprofeno', 'time': 'Ayer, 8:00 AM', 'status': 'Tomada'},
      {'medication': 'Paracetamol', 'time': 'Ayer, 8:00 PM', 'status': 'Omitida'},
      {'medication': 'Amoxicilina', 'time': 'Hoy, 8:00 AM', 'status': 'Tomada'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de tomas'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          return ListTile(
            leading: Icon(
              item['status'] == 'Tomada' ? LucideIcons.checkCircle2 : LucideIcons.xCircle,
              color: item['status'] == 'Tomada' ? Colors.green : Colors.red,
            ),
            title: Text(item['medication']!),
            subtitle: Text(item['time']!),
            trailing: Text(item['status']!),
          );
        },
      ),
    );
  }
}
