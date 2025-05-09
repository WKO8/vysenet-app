import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vysenet/models/authorized_device.dart';
import 'package:vysenet/services/api_service.dart';
import 'package:vysenet/widgets/custom_bottom_navigation_bar.dart';
import 'package:vysenet/widgets/custom_button.dart';
import 'package:vysenet/widgets/custom_text_field.dart';

import '../components/custom_app_bar.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Controle de inputs de name e MAC
  final _nameController = TextEditingController();
  final _macController = TextEditingController();

  // List<Map<String, String>> _devices = [];
  List<AuthorizedDevice> _devices = [];

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  // Carregar dispositivos de um arquivo JSON (ou de outro meio)
  Future<void> _loadDevices() async {
    try {
      final devices = await ApiService.getAuthorizedDevices();
      // final devices = await _firestoreService.getAllowedDevices();
      setState(() {
        _devices = devices;
      });
    } catch (e) {
      print("Erro ao carregar dispositivos do Firebase: $e");
    }
  }

  // Função para adicionar dispositivo
  void _addDevice() async {
    final name = _nameController.text.trim();
    final mac = _macController.text.trim();
    if (name.isNotEmpty && mac.isNotEmpty) {
      try {
        ApiService.authorize(mac, name);
        _nameController.clear();
        _macController.clear();
        _loadDevices();
      } catch (e) {
        print("Erro ao adicionar dispositivo: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao adicionar: $e')));
      }
    }
  }

  // Função para excluir dispositivo
  void _deleteDevice(int index) async {
    final deviceMAC = _devices[index].mac;
    await ApiService.deleteAuthorizedDevice(deviceMAC);
    _loadDevices();
  }

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
        appBar: CustomAppBar(title: 'VyseNet', index: 0,),
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
                    color: Colors.white.withAlpha(100),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Minimiza a altura da coluna
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: CustomTextField(
                          text: "Nome",
                          textStyle: TextStyle(),
                          backgroundColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide.none,
                          ),
                          editingController:
                              _nameController, // Usando o controlador aqui
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: CustomTextField(
                          text: "MAC",
                          textStyle: TextStyle(),
                          backgroundColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide.none,
                          ),
                          editingController:
                              _macController, // Usando o controlador aqui
                        ),
                      ),

                      // Botão de Adicionar Dispositivo
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: CustomButton(
                          scaffoldContext: context,
                          content: const Text(
                            "Adicionar",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          width: 150,
                          height: 50,
                          color: const Color(0xFF448AB5),
                          borderRadius: BorderRadius.circular(0),
                          onPressed:
                              () => {
                                _addDevice(),
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Dispositivo adicionado com sucesso!',
                                    ),
                                  ),
                                ),
                              },
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Lista de Dispositivos Permitidos
                      SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height - 500,
                          // Ajuste a altura para caber antes da borda inferior
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 0),
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
                                    color: const Color(0xFF5CCF88),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Nome: ${device.name}",
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
                                      GestureDetector(
                                        onTap: () {
                                          _deleteDevice.call(index);
                                        },
                                        child: SvgPicture.asset(
                                          "assets/icon/trash.svg",
                                          width: 40,
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
              ],
            ),
          ),
        ),

        bottomNavigationBar: CustomBottomNavigationBar(
          index: 0,
          linearGradient: LinearGradient(
            colors: [const Color(0xFF448AB5), const Color(0xFF1E3C4F)],
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
