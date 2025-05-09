import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vysenet/services/auth_service.dart';
import 'package:vysenet/widgets/custom_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    AuthService authService = AuthService();

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF20A4F3), // Cor inicial do gradiente
                Color(0xFFAFD3E9), // Cor final do gradiente
              ],
            ),
          ),
          child: Column(
            children: [
              // Primeiro container: Header com ícone
              Container(
                height: 190,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.globe,
                        size: 50,
                        color: Color(0xFF448AB5),
                      ),
                      Text(
                        "VyseNet",
                        style: TextStyle(
                          color: Color(0xFF448AB5),
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Segundo container: Campos de entrada e textos clicáveis
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 55),
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Color(0xFF448AB5)), // Define a cor do rótulo para branco
                          hintStyle: const TextStyle(color: Colors.white), // Define a cor do texto de dica para branco
                          fillColor: Colors.white, // Define a cor de fundo do TextField para branco
                          filled: true, // Define para preencher o TextField com a cor de fundo
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white), // Define a cor da borda quando o TextField está habilitado
                            borderRadius: BorderRadius.circular(10), // Define a borda circular
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white), // Define a cor da borda quando o TextField está em foco
                            borderRadius: BorderRadius.circular(10), // Define a borda circular
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          labelStyle: const TextStyle(color: Color(0xFF448AB5)), // Define a cor do rótulo para branco
                          hintStyle: const TextStyle(color: Colors.white), // Define a cor do texto de dica para branco
                          fillColor: Colors.white, // Define a cor de fundo do TextField para branco
                          filled: true, // Define para preencher o TextField com a cor de fundo
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white), // Define a cor da borda quando o TextField está habilitado
                            borderRadius: BorderRadius.circular(10), // Define a borda circular
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white), // Define a cor da borda quando o TextField está em foco
                            borderRadius: BorderRadius.circular(10), // Define a borda circular
                          ),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Confirme sua Senha',
                          labelStyle: const TextStyle(color: Color(0xFF448AB5)), // Define a cor do rótulo para branco
                          hintStyle: const TextStyle(color: Colors.white), // Define a cor do texto de dica para branco
                          fillColor: Colors.white, // Define a cor de fundo do TextField para branco
                          filled: true, // Define para preencher o TextField com a cor de fundo
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white), // Define a cor da borda quando o TextField está habilitado
                            borderRadius: BorderRadius.circular(10), // Define a borda circular
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white), // Define a cor da borda quando o TextField está em foco
                            borderRadius: BorderRadius.circular(10), // Define a borda circular
                          ),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 60),
                      CustomButton(
                            scaffoldContext: context,
                            content: const Text(
                              'Cadastrar',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: 18,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(50),
                            width: 400,
                            height: 50,
                            color: Colors.white,
                            onPressed: () async {

                              String email = emailController.text;
                              String password = passwordController.text;

                              // Verificar se os campos de texto estão preenchidos
                              if (email.isNotEmpty && password.isNotEmpty) {
                                if (password.length < 6) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Sua senha deve conter pelo menos 6 caracteres.'),
                                    ),
                                  );
                                } else {
                                  // Salvar dados do novo usuário no Firebase
                                  authService.registerUser(email: email, password: password);

                                  // Limpar campos de texto
                                  emailController.clear();
                                  passwordController.clear();

                                  // Redireciona para a tela de login
                                  Navigator.pushNamed(context, '/login');
                                }
                              } else {
                                // Exibir mensagem de erro se os campos estiverem vazios
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Por favor, preencha todos os campos.'),
                                  ),
                                );
                              }
                            },
                          ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Já tem uma conta? ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: 'Entrar',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Terceiro container: Botão de login
              Container(
                height: 90,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                    topRight: Radius.circular(80),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}