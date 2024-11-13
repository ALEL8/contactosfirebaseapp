import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/personas.dart';

class DetallesDeContacto extends StatelessWidget {
  final Personas persona;

  const DetallesDeContacto({super.key, required this.persona});

  @override
  Widget build(BuildContext context) {
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
            centerTitle: true,
              title: Text('${persona.nombres} ${persona.apellidos}',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
      ),
          ),),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Muestra un ícono de usuario en lugar de una imagen de red
            Container(
              width: double.infinity,
              height: 210,
              child: persona.imagePath != null && persona.imagePath!.isNotEmpty
                  ? Image.file(
                File(persona.imagePath!),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('images/person.png', width: double.infinity, height: 200,);
                },
              )
                  : Icon(
                Icons.person, // Ícono predeterminado
                size: 50,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.credit_card),
                    SizedBox(width: 6,),
                    Text('DNI: ',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    SizedBox(width: 6,),
                    Text(persona.dni,style: TextStyle(fontSize: 16),),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Icon(Icons.phone),
                    SizedBox(width: 6,),
                    Text('Telefono: ',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    SizedBox(width: 6,),
                    Text(persona.telefono,style: TextStyle(fontSize: 16),),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Icon(Icons.alternate_email),
                    SizedBox(width: 6,),
                    Text('Email: ',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    SizedBox(width: 6,),
                    Text(persona.email,style: TextStyle(fontSize: 16),),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(width: 6,),
                    Text('Dirección: ',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    SizedBox(width: 6,),
                    Text(persona.direccion,style: TextStyle(fontSize: 16),),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Icon(Icons.cake),
                    SizedBox(width: 6,),
                    Text('Fecha de Cumpleaños: ',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    SizedBox(width: 6,),
                    if (persona.fechaCumpleanos != null)
                      Text(
                        '${persona.fechaCumpleanos?.toLocal().toIso8601String().split('T').first}',style: TextStyle(fontSize: 16),
                      ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
