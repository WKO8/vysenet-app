// import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vysenet/models/authorized_device.dart';

// import 'package:http/http.dart' as http;
import 'package:vysenet/models/device.dart';
import 'package:vysenet/services/api_service.dart';
import 'package:vysenet/widgets/custom_bottom_navigation_bar.dart';
import 'package:vysenet/widgets/custom_button.dart';

import '../components/custom_app_bar.dart';
// import 'package:intl/intl.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  void initState() {
    super.initState();
    fetchDevices();
  }

  List<Device> _devices = [];
  List<AuthorizedDevice> _allowedDevices =
      []; // Lista de dispositivos autorizados
  int _unauthorizedCount = 0; // Contagem de dispositivos não autorizados
  bool isLoading = false;

  // Função para buscar dispositivos escaneados
  Future<void> fetchDevices() async {
    setState(() {
      isLoading = true;
    });
    final scannedDevices = await ApiService.getScannedDevices();
    final allowedDevices =
        await ApiService.getAuthorizedDevices(); // Obtenha os dispositivos permitidos
    setState(() {
      _devices = scannedDevices;
      _allowedDevices = allowedDevices;
      _unauthorizedCount =
          _devices
              .where((device) {
                // Verifica se o dispositivo escaneado não está na lista de dispositivos permitidos
                return !_allowedDevices.any(
                  (allowedDevice) => allowedDevice.mac == device.mac,
                );
              })
              .toList()
              .length;
      isLoading = false;
    });
  }

  // Verificar se o dispositivo é autorizado
  bool isAuthorized(Device device) {
    return _allowedDevices.any(
      (allowedDevice) => allowedDevice.mac == device.mac,
    );
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
        appBar: CustomAppBar(title: 'VyseNet', index: 1,),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 20,
                  ),
                  padding: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(156, 205, 234, 1),
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Column(
                    children: [
                      // Header da lista (fixo e centralizado)
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icon/warning.svg",
                                    width: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Dispositivos Encontrados",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(68, 138, 181, 1),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                isLoading
                                    ? "Carregando..."
                                    : _unauthorizedCount == 0
                                    ? "Todos autorizados"
                                    : "$_unauthorizedCount dispositivo(s) não autorizado(s)",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      _unauthorizedCount == 0
                                          ? const Color.fromRGBO(
                                            92,
                                            207,
                                            136,
                                            1,
                                          )
                                          : const Color.fromRGBO(
                                            232,
                                            118,
                                            118,
                                            1,
                                          ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Lista scrollável de dispositivos
                      SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 10, top: 0),
                            itemCount: _devices.length,
                            itemBuilder: (context, index) {
                              final device = _devices[index];
                              return Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.70,
                                  margin: const EdgeInsets.only(bottom: 15),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color:
                                        isAuthorized(device)
                                            ? const Color(0xFF5CCF88)
                                            : const Color(0xFFE87676),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
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
                    borderRadius: BorderRadius.circular(16),
                    onPressed: () {
                      fetchDevices();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          index: 1,
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
    );
  }
}
