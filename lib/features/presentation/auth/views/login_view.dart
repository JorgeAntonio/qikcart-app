import 'package:flutter/material.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: edgeInsetsH24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/icons/logo.png',
                      height: 80,
                    ),
                    gap16,
                    const Text(
                      '''¡Estamos emocionados de tenerte aquí! Empieza a gestionar tus ventas de forma sencilla y efectiva.''',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                gap32,
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    hintText: 'Usuario',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                gap16,
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    hintText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                gap24,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.snackbar(
                        'Inicio de sesión',
                        'Iniciar sesión con ${usernameController.text}',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: edgeInsetsV16,
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Iniciar sesión',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
