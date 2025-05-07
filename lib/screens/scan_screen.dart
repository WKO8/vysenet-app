// import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vysenet/models/authorized_device.dart';
// import 'package:http/http.dart' as http;
import 'package:vysenet/models/device.dart';
import 'package:vysenet/services/api_service.dart';
import 'package:vysenet/widgets/custom_bottom_navigation_bar.dart';
import 'package:vysenet/widgets/custom_button.dart';
// import 'package:intl/intl.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({
    super.key, 
  });

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  List<Device> _devices = [];
  List<AuthorizedDevice> _allowedDevices = []; // Lista de dispositivos autorizados
  int _unauthorizedCount = 0; // Contagem de dispositivos não autorizados
  
  // Função para buscar dispositivos escaneados
  Future<void> fetchDevices() async {
    final scannedDevices = await ApiService.getScannedDevices();
    final allowedDevices = await ApiService.getAuthorizedDevices(); // Obtenha os dispositivos permitidos
    setState(() {
      _devices = scannedDevices;
      _allowedDevices = allowedDevices;
      _unauthorizedCount = _devices.where((device) {
        // Verifica se o dispositivo escaneado não está na lista de dispositivos permitidos
        return !_allowedDevices.any((allowedDevice) => allowedDevice.mac == device.mac);
      }).toList().length; // Conta o número de dispositivos não autorizados
    });
  }
  
  // Verificar se o dispositivo é autorizado
  bool isAuthorized(Device device) {
    return _allowedDevices.any((allowedDevice) => allowedDevice.mac == device.mac);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final colorButton = const Color(0xFF448AB5);
  final colorGradient1 = const Color(0xFF448AB5);
  final colorGradient2 = const Color(0xFF1E3C4F);
  final colorButtonSelected = const Color(0xFF20A4F3);
  final colorWhite = const Color(0xFFF8F8FF);
  final colorTransparent = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradiente de fundo da tela
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
              // Retângulo de fundo da lista
              Positioned.fill(
                top: 120, // Evita sobreposição com header (agora tem altura 100)
                bottom: 85,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(100),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                ),
              ),

              // Header no topo
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _unauthorizedCount == 0 ? Icons.check_circle : Icons.warning,
                        size: 40,
                        color: _unauthorizedCount == 0 ? const Color(0xFF5CCF88) : const Color(0xFF1E3C4F),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "VyseNet",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF448AB5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Lista de dispositivos com header customizado
              Positioned.fill(
                top: 110,
                bottom: 100,
                child: Column(
                  children: [
                    // Header da lista (fixo e centralizado)
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _unauthorizedCount == 0
                                  ? "Todos os dispositivos estão autorizados"
                                  : "$_unauthorizedCount dispositivo(s) não autorizado(s)",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _unauthorizedCount == 0 ? const Color(0xFF5CCF88) : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Lista scrollável de dispositivos
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 0),
                        itemCount: _devices.length,
                        itemBuilder: (context, index) {
                          final device = _devices[index];
                          return Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.70,
                              margin: const EdgeInsets.only(bottom: 15),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: isAuthorized(device) ? const Color(0xFF5CCF88) : const Color(0xFFE87676),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "IP: ${device.ip}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "MAC: ${device.mac}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),

              // Botão "Scan" fixo
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: CustomButton(
                    scaffoldContext: context,
                    content: const Text(
                      "Scan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    width: 150,
                    height: 50,
                    color: colorButton,
                    borderRadius: BorderRadius.circular(50),
                    onPressed: () {
                      fetchDevices();
                    },
                  ),
                ),
              ),
            ],
          ),

          bottomNavigationBar: CustomBottomNavigationBar(
            firstIcon: Icon(
              CupertinoIcons.add_circled,
              size: 30,
              color: colorButtonSelected,
            ),
            firstText: Text(
              "Adicionar",
              style: TextStyle(fontSize: 12, color: colorButtonSelected),
            ),
            secondIcon: Icon(
              Icons.blur_circular_rounded,
              size: 33,
              color: colorWhite,
            ),
            secondText: Text(
              "Scan",
              style: TextStyle(fontSize: 12, color: colorWhite),
            ),
            thirdIcon: Icon(
              Icons.person,
              size: 30,
              color: colorWhite,
            ),
            thirdText: Text(
              "Perfil",
              style: TextStyle(fontSize: 12, color: colorWhite),
            ),
            linearGradient: LinearGradient(
              colors: [colorGradient1, colorGradient2],
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
