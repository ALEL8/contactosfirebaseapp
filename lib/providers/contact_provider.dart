// providers/contact_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/personas.dart';

class ContactProvider with ChangeNotifier {
  List<Personas> _contactos = [];

  List<Personas> get contactos => _contactos;

  ContactProvider() {
    cargarContactos();
  }

  Future<void> cargarContactos() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('Personas').get();
      _contactos =
          snapshot.docs.map((doc) => Personas.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(msg: "Error al cargar contactos: $e");
    }
  }

  Future<void> agregarContacto(Personas persona) async {
    try {
      // Convierto `persona` a un mapa antes de subirlo a Firestore
      final docRef = await FirebaseFirestore.instance
          .collection('Personas')
          .add(persona.toJson());
      persona.key =
          docRef.id; // Asigna la clave del documento al objeto persona
      _contactos.add(persona); // Añade el nuevo contacto a la lista
      notifyListeners();
      Fluttertoast.showToast(msg: "Contacto añadido exitosamente");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error al añadir contacto: $e");
    }
  }

  Future<void> actualizarContacto(Personas persona) async {
    try {
      await FirebaseFirestore.instance
          .collection('Personas')
          .doc(persona.key)
          .update(persona.toJson());
      int index = _contactos.indexWhere((c) => c.key == persona.key);
      if (index >= 0) _contactos[index] = persona;
      notifyListeners();
      Fluttertoast.showToast(msg: "Contacto actualizado exitosamente");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error al actualizar contacto: $e");
    }
  }

  Future<void> eliminarContacto(String id) async {
    try {
      await FirebaseFirestore.instance.collection('Personas').doc(id).delete();
      _contactos.removeWhere((c) => c.key == id);
      notifyListeners();
      Fluttertoast.showToast(msg: "Contacto eliminado exitosamente");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error al eliminar contacto: $e");
    }
  }
}
