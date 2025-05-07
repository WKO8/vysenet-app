import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vysenet/services/auth_service.dart';
import 'package:vysenet/services/auth_shared_preference_service.dart';
import 'package:vysenet/widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final AuthService authService = AuthService();

    void login() async {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha o email e a senha.')),
        );
        return;
      }
      print('Email: $email, Senha: $password');
      final isValidUser = await authService.signIn(email: email, password: password);

      if (isValidUser) {
        // Login bem-sucedido, altere o estado de isLoggedIn para true
        await AuthSharedPreferences.saveLoggedInState(true);
        // Navegue para a próxima tela, por exemplo, a tela inicial
        Navigator.pushNamed(context, '/scan');
      } else {
        // Exibir mensagem de erro ou toast informando que o login falhou
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email ou senha incorretos.'),
          ),
        );
      }
    }



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
        child: Stack(
          children: [
            Column(
              children: [
                // Primeiro container: Header com ícone
                Container(
                  height: 230,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(200),
                  ),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 50),
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
                              fontWeight: FontWeight.w600
                            ),
                          )
                        ],
                      ),
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
                        const SizedBox(height: 5),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/recovery');
                          },
                          child: const Text(
                            'Esqueci minha senha',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Builder(builder: (BuildContext context) {
                          return CustomButton(
                            scaffoldContext: context,
                            content: const Text(
                              'Entrar',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue, 
                                fontSize: 18
                              ),
                            ),
                            borderRadius: BorderRadius.circular(50),
                            width: 400,
                            height: 50,
                            color: Colors.white,
                            onPressed: () => {
                              login()
                            });
                        }),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Não tem conta? ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white
                                  )
                                ),
                                TextSpan(
                                  text: 'Cadastre-se',
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
            Positioned(
              top: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 15.0),
                child: CustomButton(
                  scaffoldContext: context,
                  content: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  width: 60,
                  height: 40,
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFF448AB5),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        )
      ),
    ),
  );

  }
}