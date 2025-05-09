import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vysenet/widgets/custom_button.dart';
import 'package:vysenet/widgets/custom_text_field.dart';

class RecoveryPasswordScreen extends StatelessWidget {
 const RecoveryPasswordScreen({super.key});

 @override
 Widget build(BuildContext context) {
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
                      CupertinoIcons.cube_fill,
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
            // Segundo container: Campos de entrada e textos clicáveis
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 55),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 300,
                        height: 50,             
                        child: Text(
                          'Digite seu e-mail para recuperar sua senha:',
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const CustomTextField(
                        text: 'Email', 
                        textStyle: TextStyle(
                          color: Color(0xFF448AB5),
                          fontSize: 18
                        ), 
                        backgroundColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide: BorderSide.none
                        ), 
                        icon: Icon(
                          CupertinoIcons.mail_solid,
                          color: Color(0xFF448AB5),
                        )
                      ), 
                      const SizedBox(height: 50),
                      Column(
                        children: [
                          Builder(builder: (BuildContext context) {
                            return CustomButton(
                              scaffoldContext: context,
                              content: const Text(
                                'Recuperar senha',
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
                                Navigator.pushNamed(context, '/home')
                              },
                            );
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
                                    text: 'Cadastre-se!',
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
                      const SizedBox(height: 30),
                      Builder(builder: (BuildContext context) {
                        return CustomButton(
                          scaffoldContext: context,
                          content: const Text(
                            'Voltar para login',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue, 
                              fontSize: 18
                            ),
                          ),
                          borderRadius: BorderRadius.circular(50),
                          width: 300,
                          height: 50,
                          color: Colors.white,
                          onPressed: () => {
                            Navigator.pushNamed(context, '/login')
                          },
                        );
                      }),
                      const SizedBox(height: 30),
                    ],
                  ),
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
