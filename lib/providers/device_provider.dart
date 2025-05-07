import 'package:flutter/material.dart';
import '../models/device.dart';
import '../services/api_service.dart';

class DeviceProvider with ChangeNotifier {
  List<Device> scanned = [];

  Future<void> loadScanned() async {
    scanned = await ApiService.getScannedDevices();
    notifyListeners();
  }

  Future<void> authorize(Device d, String name) async {
    await ApiService.authorize(d.mac, name);
    await loadScanned();
  }
}