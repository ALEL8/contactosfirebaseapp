// widgets/contact_card.dart
import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/personas.dart';

class ContactCard extends StatelessWidget {
  final Personas personas;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const ContactCard({
    super.key,
    required this.personas,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: personas.imagePath != null && personas.imagePath!.isNotEmpty
                ? Image.file(
                    File(personas.imagePath!),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'images/person.png',
                        width: 50,
                        height: 50,
                      );
                    },
                  )
                : Icon(
                    Icons.person, // Ícono predeterminado
                    size: 50,
                    color: Colors.grey.shade400,
                  ),
          ),
          title: Text(
            '${personas.nombres} ${personas.apellidos}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(personas.telefono),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                onEdit();
              } else if (value == 'delete') {
                onDelete();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Editar'),
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Eliminar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
