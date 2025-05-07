class Device {
  final String ip;
  final String mac;
  final bool authorized;
  final String lastSeen;

  Device({
    required this.ip,
    required this.mac,
    required this.authorized,
    required this.lastSeen,
  });
}
