
import 'package:flutter/material.dart';
import 'package:myapp/views/screens/detail_contacto.dart';
import 'package:myapp/views/screens/registros.dart';
import 'package:myapp/views/widgets/contact_card.dart';
import 'package:provider/provider.dart';
import '../../models/personas.dart';
import '../../providers/contact_provider.dart';
import '../../providers/theme_provider.dart';

class PrincipalUI extends StatelessWidget {
  const PrincipalUI({super.key});

  void _confirmarEliminacion(BuildContext context, String key) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmar',
            style: TextStyle(
                color: Colors.deepOrange, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            '¿Estás seguro de que deseas eliminar esta persona?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar',
                  style: TextStyle(color: Colors.blueGrey)),
            ),
            TextButton(
              onPressed: () {
                Provider.of<ContactProvider>(context, listen: false)
                    .eliminarContacto(key);
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar',
                  style: TextStyle(color: Colors.deepOrange)),
            ),
          ],
        );
      },
    );
  }

  void _verDetalles(BuildContext context, Personas persona) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetallesDeContacto(persona: persona),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
          decoration: const BoxDecoration(
          gradient: LinearGradient(
          colors: [
            Color(0xFFfc3903),
            Color(0xFFfcba03) // Color final del gradiente
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent, // Fondo transparente para mostrar el gradiente
            elevation: 0,
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Contactos", style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 28),),
                  SizedBox(width: 6,),
                  Image.asset(
                    'images/firebase.png',
                    width: 140,
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    themeProvider.isDarkMode
                        ? Icons.brightness_7
                        : Icons.brightness_2,
                  ),
                  onPressed: () {
                    themeProvider.toggleTheme();
                  },
                ),
              ],
            ),
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Abrir RegistrosUI sin argumentos para crear un nuevo contacto
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegistrosUI(),
            ),
          );
        },
        child:
            const Icon(Icons.person_add_alt_1, color: Colors.white, size: 40),
      ),
      body: contactProvider.contactos.isEmpty
          ? const Center(child: Text("No hay contactos"))
          : ListView.builder(
              itemCount: contactProvider.contactos.length,
              itemBuilder: (context, index) {
                final persona = contactProvider.contactos[index];
                return ContactCard(
                  personas: persona,
                  onEdit: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrosUI(persona: persona),
                    ),
                  ),
                  onDelete: () => _confirmarEliminacion(context, persona.key!),
                  onTap: () => _verDetalles(context, persona),
                );
              },
            ),
    );
  }
}
