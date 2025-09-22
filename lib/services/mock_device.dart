import 'dart:convert';
import 'dart:io';

/// Servidor HTTP local que simula el comportamiento del pastillero.
/// Se levanta en localhost:8080 y responde a los mismos endpoints
/// que tendrá el firmware real.

class MockDeviceServer {
  HttpServer? _server;
  int battery = 85;
  final List<Map<String, dynamic>> events = [];

  Future<void> start({int port = 8080}) async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);

    await for (HttpRequest request in _server!) {
      final path = request.uri.path;
      if (path == '/status') {
        _handleStatus(request);
      } else if (path == '/rotate') {
        await _handleRotate(request);
      } else if (path == '/events') {
        _handleEvents(request);
      } else if (path == '/link') {
        _handleLink(request);
      } else {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
      }
    }
  }

  void _handleStatus(HttpRequest request) {
    final resp = {'id': 'mock-001', 'ip': '127.0.0.1', 'battery': battery};
    request.response
      ..headers.contentType = ContentType.json
      ..write(jsonEncode(resp))
      ..close();
  }

  Future<void> _handleRotate(HttpRequest request) async {
    final body = await utf8.decoder.bind(request).join();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final compartment = data['compartment'] ?? -1;

    final event = {
      'ts': DateTime.now().toIso8601String(),
      'compartment': compartment,
      'type': 'rotated'
    };
    events.add(event);

    request.response
      ..statusCode = HttpStatus.ok
      ..write(jsonEncode({'ok': true}))
      ..close();
  }

  void _handleEvents(HttpRequest request) {
    request.response
      ..headers.contentType = ContentType.json
      ..write(jsonEncode(events))
      ..close();
  }

  void _handleLink(HttpRequest request) {
    final resp = {'challenge': 'mock-link-success'};
    request.response
      ..headers.contentType = ContentType.json
      ..write(jsonEncode(resp))
      ..close();
  }

  Future<void> stop() async {
    await _server?.close();
    _server = null;
  }
}

Future<void> main() async {
  final server = MockDeviceServer();
  await server.start(port: 8080);
}
