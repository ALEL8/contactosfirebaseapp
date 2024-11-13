
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/navigation/elementos_nav.dart';
import 'package:myapp/providers/contact_provider.dart';
import 'package:myapp/views/screens/inicial.dart';
import 'package:myapp/views/screens/principal.dart';
import 'package:myapp/views/screens/registros.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
      ],
      child: const ManejadorNavegacion(),
    ),
  );
}

class ManejadorNavegacion extends StatelessWidget {
  const ManejadorNavegacion({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Firebase App',
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          titleTextStyle: TextStyle(color: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        scaffoldBackgroundColor: Colors.white,
          floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.orange)
        // Agrega aquí otros colores o estilos para el tema claro
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.teal,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          titleTextStyle: TextStyle(color: Colors.black),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        scaffoldBackgroundColor: Colors.black,
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.red)
        // Agrega aquí otros colores o estilos para el tema oscuro
      ),
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
