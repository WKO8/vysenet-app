import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vysenet/services/api_service.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> _getUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<CollectionReference<Map<String, dynamic>>?> _getDeviceCollection() async {
    final userId = await _getUserId();
    if (userId == null) return null;

    // Garante que o documento do usuário exista (mesmo vazio)
    final userDocRef = _firestore.collection('users').doc(userId);
    final userDoc = await userDocRef.get();
    if (!userDoc.exists) {
      await userDocRef.set({});
    }

    return userDocRef.collection('allowed_devices');
  }

  Future<List<Map<String, String>>> getAllowedDevices() async {
    try {
      final deviceCollection = await _getDeviceCollection();
      if (deviceCollection == null) return [];

      final snapshot = await deviceCollection.get();

      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'ip': doc['ip'] as String,
                'mac': doc['mac'] as String,
              })
          .toList();
    } catch (e) {
      print("Erro ao obter dispositivos: $e");
      return [];
    }
  }

  Future<void> addDevice(String ip, String mac) async {
    try {
      ApiService.authorize(mac, ip);
      final deviceCollection = await _getDeviceCollection();

      if (deviceCollection == null) throw Exception("Usuário não logado.");
      await deviceCollection.add({'ip': ip, 'mac': mac});
    } catch (e) {
      print("Erro ao adicionar dispositivo: $e");
    }
  }

  Future<void> deleteDevice(String deviceId) async {
    try {
      final deviceCollection = await _getDeviceCollection();
      if (deviceCollection == null) throw Exception("Usuário não logado.");
      await deviceCollection.doc(deviceId).delete();
    } catch (e) {
      print("Erro ao excluir dispositivo: $e");
    }
  }
}
