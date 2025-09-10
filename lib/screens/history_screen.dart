// Archivo: lib/screens/history_screen.dart

import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de tomas'),
      ),
      body: Center(
        child: Text('Historial de tomas...'),
      ),
    );
  }
}