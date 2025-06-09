import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vysenet/models/authorized_device.dart';
import 'package:vysenet/models/device.dart';
import 'package:vysenet/services/api_service.dart';
import 'package:vysenet/services/auth_shared_preference_service.dart';
import 'package:vysenet/services/pdf_report_service.dart';
import 'package:vysenet/widgets/custom_bottom_navigation_bar.dart';

import '../components/custom_app_bar.dart';

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

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut(); // Firebase sign out
    await AuthSharedPreferences.saveLoggedInState(false); // SharedPreferences

    // Navega para a tela de login e remove as rotas anteriores
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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

  Future<void> _generateAndShareReport() async {
    try {
      // Mostra indicador de loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Gera o PDF
      final pdfBytes = await PdfReportService.generateNetworkReport(
        scannedDevices: scannedDevices,
        authorizedDevices: authorizedDevices,
      );

      // Remove o loading
      Navigator.of(context).pop();

      // Mostra opções para o usuário
      _showShareOptions(pdfBytes);
    } catch (e) {
      // Remove o loading em caso de erro
      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao gerar relatório: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showShareOptions(Uint8List pdfBytes) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Relatório Gerado com Sucesso!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF448AB5),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.share, color: Color(0xFF448AB5)),
                title: const Text('Compartilhar'),
                subtitle: const Text('Enviar por email, WhatsApp, etc.'),
                onTap: () async {
                  Navigator.pop(context);
                  await PdfReportService.shareReport(pdfBytes);
                },
              ),
              ListTile(
                leading: const Icon(Icons.print, color: Color(0xFF448AB5)),
                title: const Text('Imprimir'),
                subtitle: const Text('Visualizar e imprimir o relatório'),
                onTap: () async {
                  Navigator.pop(context);
                  await PdfReportService.printReport(pdfBytes);
                },
              ),
              ListTile(
                leading: const Icon(Icons.save, color: Color(0xFF448AB5)),
                title: const Text('Salvar no Dispositivo'),
                subtitle: const Text('Salvar arquivo PDF localmente'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final path = await PdfReportService.saveReportToFile(pdfBytes);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Relatório salvo em: $path'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao salvar: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int totalScanned = scannedDevices.length;
    final int totalAuthorized = authorizedDevices.length;
    final int totalUnauthorized = totalScanned - totalAuthorized;

    final user = FirebaseAuth.instance.currentUser;
    final String email = user?.email ?? "usuário";
    final String username = email.split('@')[0];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(32, 164, 243, 1),
            Color.fromRGBO(175, 211, 233, 1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(title: 'VyseNet', index: 2),
        floatingActionButton: GestureDetector(
          onTap: _generateAndShareReport,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: SvgPicture.asset("assets/icon/share.svg", width: 30),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(80),
                      bottomRight: Radius.circular(80),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Foto e nome do usuário
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(27),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                color: Color.fromRGBO(193, 226, 246, 1),
                                child: SvgPicture.asset(
                                  'assets/icon/user_active.svg',
                                  width: 50,
                                ),
                              ),
                            ),
                            const SizedBox(width: 50),
                            Expanded(
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        username,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(68, 138, 181, 1),
                                        ),
                                      ),
                                      const Text(
                                        "Administrador",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color.fromRGBO(68, 138, 181, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 30),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.logout, 
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                    onPressed: _logout,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: const Divider(
                          height: 1,
                          color: Color.fromRGBO(68, 138, 181, 1),
                        ),
                      ),
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: const Text(
                                "Dispositivos autorizados",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green,
                                ),
                                textAlign: TextAlign.center,
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: const Text(
                                "Dispositivos não autorizados",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: const Text(
                                "Dispositivos escaneados",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF448AB5),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: const Divider(
                          height: 1,
                          color: Color.fromRGBO(68, 138, 181, 1),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          index: 2,
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
    );
  }
}
