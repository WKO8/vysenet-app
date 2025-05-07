import 'package:flutter/material.dart';
import 'package:vysenet/models/device.dart';

class DeviceTile extends StatelessWidget {
  final Device device;

  const DeviceTile({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.devices),
      title: Text(device.mac),
      subtitle: Text('IP: ${device.ip} | MAC: ${device.mac}'),
      trailing: Text(device.lastSeen),
    );
  }
}
