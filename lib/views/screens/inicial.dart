import 'dart:async'; // Importa el paquete para trabajar con timers y asincronía.
import 'package:flutter/material.dart';
import 'package:myapp/navigation/elementos_nav.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicia un temporizador que espera 3 segundos.
    Timer(const Duration(seconds: 3), () {
      // Cambia a la ruta especificada en ElementosNav.principal al terminar el temporizador.
      Navigator.of(context).pushReplacementNamed(ElementosNav.principal);
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              // Aplica un efecto de shader (degradado) a un widget.
              shaderCallback: (bounds) => const LinearGradient(
                // Define un degradado lineal.
                colors: [
                  Color(0xFFfc3903),
                  Color(0xFFfcba03)
                ], // Colores del degradado.
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(
                  bounds), // Crea el shader basado en los límites del widget.
              child: const Text(
                "Contactos",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'images/firebase.png',
              width: 300,
            ),
          ],
        ),
      ),
    );
  }
}
