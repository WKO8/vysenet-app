import 'package:flutter/material.dart';
import '../models/authorized_device.dart';

class AuthorizedDeviceTile extends StatelessWidget {
  final AuthorizedDevice device;

  const AuthorizedDeviceTile({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.check, color: Colors.green),
      title: Text(device.name),
      subtitle: Text('MAC: ${device.mac}'),
      trailing: Text(device.firstSeen),
    );
  }
}
