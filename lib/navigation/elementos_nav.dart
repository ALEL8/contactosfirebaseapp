// navigation/elemento_nav.dart
import 'package:flutter/material.dart';
import 'package:myapp/views/screens/inicial.dart';
import 'package:myapp/views/screens/principal.dart';
import 'package:myapp/views/screens/registros.dart';

class ElementosNav {
  static const String inicio = '/splash';
  static const String principal = '/principal';
  static const String registro = '/registro';
}

class ManejadorNavegacion extends StatelessWidget {
  const ManejadorNavegacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: ElementosNav.inicio,
      routes: {
        ElementosNav.inicio: (context) => const SplashScreen(),
        ElementosNav.principal: (context) => const PrincipalUI(),
        ElementosNav.registro: (context) => const RegistrosUI(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
