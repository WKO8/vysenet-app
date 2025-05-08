import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vysenet/models/authorized_device.dart';
import 'package:vysenet/models/device.dart';
import 'package:vysenet/services/api_service.dart';
import 'package:vysenet/widgets/custom_bottom_navigation_bar.dart';
import 'package:vysenet/widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Device> scannedDevices = [];
  List<AuthorizedDevice> authorizedDevices = [];

  @override
  void initState() {
    super.initState();
    _loadDeviceData();
  }

  Future<void> _loadDeviceData() async {
    try {
      final scanned = await ApiService.getScannedDevices();
      final authorized = await ApiService.getAuthorizedDevices();

      setState(() {
        scannedDevices = scanned;
        authorizedDevices = authorized;
      });
    } catch (e) {
      print("Erro ao carregar dados dos dispositivos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalScanned = scannedDevices.length;
    final int totalAuthorized = scannedDevices.where((d) => d.authorized).length;
    final int totalUnauthorized = totalScanned - totalAuthorized;

    final user = FirebaseAuth.instance.currentUser;
    final String email = user?.email ?? "usuário";
    final String username = email.split('@')[0];

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB3E5FC), Color(0xFF81D4FA)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned.fill(
                top: 120,
                bottom: 85,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Foto e nome do usuário
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            const CircleAvatar(
                              radius: 35,
                              backgroundImage: AssetImage('assets/profile.png'),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  username,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  "Administrador",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Divider(thickness: 1, color: Colors.grey),

                      const SizedBox(height: 20),

                      // Tabela de dispositivos
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$totalAuthorized",
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const Text(
                              "Dispositivos autorizados",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$totalUnauthorized",
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            const Text(
                              "Dispositivos não autorizados",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$totalScanned",
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF448AB5),
                              ),
                            ),
                            const Text(
                              "Dispositivos escaneados",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF448AB5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(thickness: 1, color: Colors.grey),

                    ],
                  ),
                ),
              ),

              // Header
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.globe, size: 40, color: Color(0xFF448AB5)),
                      SizedBox(width: 10),
                      Text(
                        "VyseNet",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF448AB5),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // Botão inferior
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: CustomButton(
                    scaffoldContext: context,
                    content: const Text(
                      "Compartilhar",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    width: 200,
                    height: 50,
                    color: const Color(0xFF448AB5),
                    borderRadius: BorderRadius.circular(50),
                    onPressed: () {
                      // Lógica de compartilhamento
                    },
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            firstIcon: const Icon(CupertinoIcons.add_circled, size: 30, color: Color(0xFF20A4F3)),
            firstText: const Text("Adicionar", style: TextStyle(fontSize: 12, color: Color(0xFF20A4F3))),
            secondIcon: const Icon(Icons.blur_circular_rounded, size: 33, color: Color(0xFFF8F8FF)),
            secondText: const Text("Scan", style: TextStyle(fontSize: 12, color: Color(0xFFF8F8FF))),
            thirdIcon: const Icon(Icons.person, size: 30, color: Color(0xFFF8F8FF)),
            thirdText: const Text("Perfil", style: TextStyle(fontSize: 12, color: Color(0xFFF8F8FF))),
            linearGradient: const LinearGradient(
              colors: [Color(0xFF448AB5), Color(0xFF1E3C4F)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            onPressed: (index) {
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, "/add");
                  break;
                case 1:
                  Navigator.pushNamed(context, "/scan");
                  break;
                case 2:
                  Navigator.pushNamed(context, "/profile");
                  break;
              }
            },
          ),
        ),
      ],
    );
  }
}
