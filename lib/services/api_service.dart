import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/device.dart';
import '../models/authorized_device.dart';

class ApiService {
  static const baseUrl = 'http://10.0.2.2:5000';

  /// Retorna a lista de dispositivos escaneados (inclui status e lastSeen).
  static Future<List<Device>> getScannedDevices() async {
    final res = await http.get(Uri.parse('$baseUrl/scan'));
    if (res.statusCode != 200) throw Exception('Erro no scan: ${res.body}');
    final Map<String, dynamic> body = json.decode(res.body);
    return body.entries.map((e) {
      final m = e.value as Map<String, dynamic>;
      return Device(
        ip: m['ip'],
        mac: e.key,
        authorized: (m['status'] == 'authorized'),
        lastSeen: m['last_seen'],
      );
    }).toList();
  }

  /// Retorna o mapa de dispositivos autorizados (mac → AuthorizedDevice).
  static Future<List<AuthorizedDevice>> getAuthorizedDevices() async {
    final res = await http.get(Uri.parse('$baseUrl/authorized'));
    if (res.statusCode != 200) throw Exception('Erro ao buscar autorizados: ${res.body}');
    final Map<String, dynamic> body = json.decode(res.body);
    return body.entries.map((e) {
      final m = e.value as Map<String, dynamic>;
      return AuthorizedDevice(
        mac: e.key,
        name: m['name'],
        firstSeen: m['first_seen'],
      );
    }).toList();
  }

  /// Autoriza um dispositivo fornecendo MAC e nome.
  static Future<void> authorize(String mac, String name) async {
    final res = await http.post(
      Uri.parse('$baseUrl/authorize'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'mac': mac, 'name': name}),
    );
    if (res.statusCode != 200) throw Exception('Erro ao autorizar: ${res.body}');
  }

  /// Deleta um dispositivo autorizado fornecendo o MAC.
  static Future<void> deleteAuthorizedDevice(String mac) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/authorized'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'mac': mac}),
    );
    if (res.statusCode != 200) {
      throw Exception('Erro ao deletar dispositivo: ${res.body}');
    }
  }
}
