// Archivo: lib/screens/pairing_screen.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:async'; // Para Future.delayed y Timer

// Enum para los diferentes estados del proceso de vinculación
enum PairingStatus {
  idle, // Esperando para iniciar
  searching, // Buscando dispositivos
  deviceFound, // Dispositivo encontrado, listo para conectar
  connecting, // Conectando al dispositivo
  verifying, // Verificando conexión/configuración
  paired, // Vinculado exitosamente
  error, // Error en la vinculación
}

// Clase para simular un dispositivo encontrado
class DiscoveredDevice {
  final String id;
  final String name;
  final int
      rssi; // Indicador de fuerza de señal (ej. -30 (fuerte) a -90 (débil))

  DiscoveredDevice({required this.id, required this.name, this.rssi = -50});

  String get proximity {
    if (rssi > -55) return "Muy cerca";
    if (rssi > -70) return "Cerca";
    if (rssi > -85) return "Lejos";
    return "Muy lejos";
  }
}

class PairingScreen extends StatefulWidget {
  const PairingScreen({super.key});

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  PairingStatus _status = PairingStatus.idle;
  DiscoveredDevice? _foundDevice;
  String _errorMessage = "";
  Timer? _searchTimeoutTimer;

  // --- Simulación de Lógica de Vinculación ---
  Future<void> _startPairingProcess() async {
    setState(() {
      _status = PairingStatus.searching;
      _foundDevice = null;
      _errorMessage = "";
    });

    // Simular búsqueda de dispositivos
    _searchTimeoutTimer?.cancel(); // Cancelar timer anterior si existe
    _searchTimeoutTimer = Timer(const Duration(seconds: 10), () {
      if (_status == PairingStatus.searching) {
        setState(() {
          _status = PairingStatus.error;
          _errorMessage =
              "No se encontraron pastilleros cercanos. Asegúrate de que esté encendido y visible.";
        });
      }
    });

    await Future.delayed(
        const Duration(seconds: 3)); // Simular tiempo de búsqueda

    // Simular hallazgo de un dispositivo
    // En una app real, aquí recibirías un callback del sistema BT/Wi-Fi
    if (_status == PairingStatus.searching) {
      // Solo si aún estamos buscando
      _searchTimeoutTimer?.cancel(); // Dispositivo encontrado, cancelar timeout
      setState(() {
        _foundDevice = DiscoveredDevice(
            id: "Pildhora-X123-ABC",
            name: "Pastillero Pildhora X123",
            rssi: -45);
        _status = PairingStatus.deviceFound;
      });
    }
  }

  Future<void> _connectToDevice(DiscoveredDevice device) async {
    setState(() => _status = PairingStatus.connecting);
    await Future.delayed(const Duration(seconds: 2)); // Simular conexión

    // Simular verificación
    setState(() => _status = PairingStatus.verifying);
    await Future.delayed(const Duration(seconds: 2)); // Simular verificación

    // Simular éxito
    // En un caso real, aquí podrías tener un error
    setState(() => _status = PairingStatus.paired);
  }

  void _resetPairing() {
    _searchTimeoutTimer?.cancel();
    setState(() {
      _status = PairingStatus.idle;
      _foundDevice = null;
      _errorMessage = "";
    });
  }
  // --- Fin Simulación ---

  @override
  void dispose() {
    _searchTimeoutTimer?.cancel();
    super.dispose();
  }

  Widget _buildContent() {
    switch (_status) {
      case PairingStatus.idle:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.bluetooth,
                size: 80, color: Color(0xFF7D2AE8)),
            const SizedBox(height: 24),
            const Text(
              'Vincular tu Pastillero Inteligente',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Asegúrate de que tu pastillero esté encendido y cerca.\nLos servicios de ubicación deben estar activados para buscar dispositivos Bluetooth.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _startPairingProcess,
              icon: const Icon(LucideIcons.search),
              label: const Text('Iniciar Búsqueda'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        );

      case PairingStatus.searching:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            const Text('Buscando pastilleros cercanos...',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            const Text(
              'Mantén tu pastillero cerca del teléfono.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: _resetPairing,
              child: const Text('Cancelar Búsqueda',
                  style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );

      case PairingStatus.deviceFound:
        if (_foundDevice == null) {
          // Seguridad, no debería pasar
          _resetPairing();
          return const Text("Error inesperado, por favor reintenta.");
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.pill, size: 80, color: Color(0xFF7D2AE8)),
            const SizedBox(height: 24),
            Text('Pastillero Encontrado:',
                style: TextStyle(fontSize: 18, color: Colors.grey[700])),
            const SizedBox(height: 8),
            Text(_foundDevice!.name,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Proximidad: ${_foundDevice!.proximity}',
                style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(LucideIcons.link),
              label: Text('Conectar con ${_foundDevice!.name}'),
              onPressed: () => _connectToDevice(_foundDevice!),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _startPairingProcess, // Volver a buscar
              child: const Text('Buscar de nuevo'),
            ),
          ],
        );

      case PairingStatus.connecting:
      case PairingStatus.verifying:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              _status == PairingStatus.connecting
                  ? 'Conectando con ${_foundDevice?.name ?? "pastillero"}...'
                  : 'Verificando conexión...',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Esto puede tomar unos segundos...',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        );

      case PairingStatus.paired:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.checkCircle, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            Text(
              '¡Pastillero Vinculado!',
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              '${_foundDevice?.name ?? "Tu pastillero"} está listo para usarse.',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla principal o de configuración del pastillero
                Navigator.of(context).pop(); // O context.go('/');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Continuar'),
            ),
          ],
        );

      case PairingStatus.error:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.alertTriangle,
                size: 80, color: Colors.redAccent),
            const SizedBox(height: 24),
            Text(
              'Error en la Vinculación',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700]),
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage.isNotEmpty
                  ? _errorMessage
                  : 'Ocurrió un error inesperado.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed:
                  _resetPairing, // Permite volver a la pantalla inicial para reintentar
              icon: const Icon(LucideIcons.refreshCw),
              label: const Text('Reintentar Vinculación'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar',
                  style: TextStyle(color: Colors.blueGrey)),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vincular Pastillero'),
        leading: _status != PairingStatus.idle &&
                _status != PairingStatus.paired &&
                _status != PairingStatus.error
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  // Preguntar si desea cancelar el proceso en curso
                  showDialog(
                    context: context,
                    builder: (BuildContext ctx) => AlertDialog(
                      title: const Text('Cancelar Vinculación'),
                      content: const Text(
                          '¿Estás seguro de que deseas detener el proceso de vinculación?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _resetPairing(); // Resetea al estado inicial
                          },
                          child: const Text('Sí, Cancelar'),
                        ),
                      ],
                    ),
                  );
                },
              )
            : null, // No mostrar botón de cerrar en estados finales o inicial
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _buildContent(),
        ),
      ),
    );
  }
}
