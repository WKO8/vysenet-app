import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vysenet/models/authorized_device.dart';
import 'package:vysenet/services/api_service.dart';
import 'package:vysenet/widgets/custom_bottom_navigation_bar.dart';
import 'package:vysenet/widgets/custom_button.dart';
import 'package:vysenet/widgets/custom_text_field.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar: $e')),
        );
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
                top: 120,
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
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.globe,
                        size: 40,
                        color: Color(0xFF448AB5),
                      ),
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

              // Formulário de Adição de Dispositivo
              Positioned(
                top: 140,
                left: 15,
                right: 15,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Minimiza a altura da coluna
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
                        editingController: _nameController,  // Usando o controlador aqui
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
                        editingController: _macController,  // Usando o controlador aqui
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
                        borderRadius: BorderRadius.circular(50),
                        onPressed: () => {
                          _addDevice(),
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Dispositivo adicionado com sucesso!'),
                            ),
                          ),
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Lista de Dispositivos Permitidos
                    Container(
                      height: MediaQuery.of(context).size.height - 295, // Ajuste a altura para caber antes da borda inferior
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _deleteDevice(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          bottomNavigationBar: CustomBottomNavigationBar(
            firstIcon: Icon(
              CupertinoIcons.add_circled,
              size: 30,
              color: const Color(0xFF20A4F3),
            ),
            firstText: Text(
              "Adicionar",
              style: TextStyle(fontSize: 12, color: const Color(0xFF20A4F3)),
            ),
            secondIcon: Icon(
              Icons.blur_circular_rounded,
              size: 33,
              color: const Color(0xFFF8F8FF),
            ),
            secondText: Text(
              "Scan",
              style: TextStyle(fontSize: 12, color: const Color(0xFFF8F8FF)),
            ),
            thirdIcon: Icon(
              Icons.person,
              size: 30,
              color: const Color(0xFFF8F8FF),
            ),
            thirdText: Text(
              "Perfil",
              style: TextStyle(fontSize: 12, color: const Color(0xFFF8F8FF)),
            ),
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
      ],
    );
  }
}
