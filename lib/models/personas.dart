// models/personas.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Personas {
  String? key;
  String nombres;
  String apellidos;
  String dni;
  String direccion;
  String telefono;
  String email;
  DateTime? fechaCumpleanos;
  String? imagePath; // Campo para la ruta de la imagen local

  Personas({
    this.key,
    required this.nombres,
    required this.apellidos,
    required this.dni,
    required this.direccion,
    required this.telefono,
    required this.email,
    this.fechaCumpleanos,
    this.imagePath,
  });

  // Constructor para crear una instancia desde un documento Firestore
  factory Personas.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Personas(
      key: doc.id,
      nombres: data['nombres'] ?? '',
      apellidos: data['apellidos'] ?? '',
      dni: data['dni'] ?? '',
      direccion: data['direccion'] ?? '',
      telefono: data['telefono'] ?? '',
      email: data['email'] ?? '',
      fechaCumpleanos: data['fechaCumpleanos'] != null
          ? DateTime.parse(data['fechaCumpleanos'])
          : null,
      imagePath: data['imagePath'], // Recuperar la ruta de la imagen local
    );
  }

  // Método para convertir la instancia en JSON para Firestore
  Map<String, dynamic> toJson() => {
        'nombres': nombres,
        'apellidos': apellidos,
        'dni': dni,
        'direccion': direccion,
        'telefono': telefono,
        'email': email,
        'fechaCumpleanos': fechaCumpleanos?.toIso8601String(),
        'imagePath': imagePath, // Incluir la ruta de la imagen en Firestore
      };
}
