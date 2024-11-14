import 'dart:io'; // Import para trabajar con archivos en móviles
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // Para `kIsWeb`
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha
import 'package:myapp/models/personas.dart';
import 'package:provider/provider.dart';

import '../../providers/contact_provider.dart';

class RegistrosUI extends StatefulWidget {
  final Personas? persona;
  const RegistrosUI({super.key, this.persona});

  @override
  createState() => _RegistrosUIState();
}

class _RegistrosUIState extends State<RegistrosUI> {
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController dniController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fechaCumpleanosController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Uint8List? _imagenBytes;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _initializeData(); // Llama a la función asíncrona
  }

  Future<void> _initializeData() async {
    if (widget.persona != null) {
      // Cargar los datos de la persona en los controladores y la ruta de imagen
      nombresController.text = widget.persona!.nombres;
      apellidosController.text = widget.persona!.apellidos;
      dniController.text = widget.persona!.dni;
      direccionController.text = widget.persona!.direccion;
      telefonoController.text = widget.persona!.telefono;
      emailController.text = widget.persona!.email;
      if (widget.persona!.fechaCumpleanos != null) {
        fechaCumpleanosController.text =
            DateFormat('yyyy-MM-dd').format(widget.persona!.fechaCumpleanos!);
      }
      _imagePath = widget.persona!.imagePath;

      // Comprobar si el archivo de imagen existe (solo para móvil)
      if (_imagePath != null && !kIsWeb && File(_imagePath!).existsSync()) {
        // Si el archivo existe, intenta cargarlo
        setState(() {});
      } else {
        // Si el archivo no existe o falla, asigna la imagen predeterminada
        _imagePath = 'images/person.png';
        setState(() {});
      }
    }
  }

  void _seleccionarImagen() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null) {
        setState(() {
          if (kIsWeb) {
            _imagenBytes = result.files.single.bytes;
          } else {
            _imagePath = result.files.single.path;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: $e')),
      );
    }
  }

  void _selectFechaCumpleanos(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        fechaCumpleanosController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _guardarPersona(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      // Verificar si no se ha seleccionado una imagen
      String? imagePath = _imagePath;
      if (imagePath == null) {
        // Si no hay imagen seleccionada, asignar la imagen predeterminada
        imagePath = 'images/person.png'; // Ruta de la imagen predeterminada
      }

      final nuevaPersona = Personas(
        nombres: nombresController.text,
        apellidos: apellidosController.text,
        dni: dniController.text,
        direccion: direccionController.text,
        telefono: telefonoController.text,
        email: emailController.text,
        fechaCumpleanos: fechaCumpleanosController.text.isNotEmpty
            ? DateTime.parse(fechaCumpleanosController.text)
            : null,
        imagePath: kIsWeb
            ? null
            : imagePath, // Usar la ruta de la imagen, aunque sea la predeterminada
      );

      final contactProvider =
          Provider.of<ContactProvider>(context, listen: false);

      if (widget.persona != null) {
        nuevaPersona.key = widget.persona!.key;
        contactProvider.actualizarContacto(nuevaPersona);
      } else {
        contactProvider.agregarContacto(nuevaPersona);
      }

      Navigator.pop(context);
    }
  }

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
            title: Text(
                widget.persona == null ? "Registrar Persona" : "Editar Persona",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: nombresController,
                label: 'Nombres',
                icon: Icons.perm_identity,
              ),
              _buildTextField(
                controller: apellidosController,
                label: 'Apellidos',
                icon: Icons.perm_identity,
              ),
              _buildTextField(
                controller: dniController,
                label: 'DNI',
                icon: Icons.credit_card,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                controller: direccionController,
                label: 'Dirección',
                icon: Icons.location_on,
              ),
              _buildTextField(
                controller: telefonoController,
                label: 'Teléfono',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                controller: emailController,
                label: 'Correo Electrónico',
                icon: Icons.alternate_email,
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: fechaCumpleanosController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.cake),
                  labelText: 'Fecha de Cumpleaños',
                ),
                readOnly: true,
                onTap: () => _selectFechaCumpleanos(context),
                validator: (value) => value == null || value.isEmpty
                    ? 'Este campo es obligatorio'
                    : null,
              ),
              const SizedBox(height: 20),
              Container(
                width: 200,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFfc3903), // Color inicial del gradiente
                      Color(0xFFfcba03), // Color final del gradiente
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(20.0)), // Bordes redondeados
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Fondo transparente
                    shadowColor: Colors.transparent, // Sin sombra
                  ),
                  onPressed: _seleccionarImagen,
                  icon: const Icon(Icons.image),
                  label: const Text("Seleccionar Imagen"),
                ),
              ),
              const SizedBox(height: 20),
              if (_imagenBytes != null && kIsWeb)
                Image.memory(
                  _imagenBytes!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                )
              else if (_imagePath != null && !kIsWeb)
                Image.file(
                  File(_imagePath!),
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Muestra la imagen predeterminada si falla al cargar la imagen
                    return Image.asset(
                      'images/person.png',
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    );
                  },
                )
              else
                Image.asset(
                  'assets/images/person.png', // Imagen predeterminada
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 20),
              Container(
                width: 100,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFfc3903), // Color inicial del gradiente
                      Color(0xFFfcba03), // Color final del gradiente
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(20.0)), // Bordes redondeados
                ),
                child: TextButton(
                  onPressed: () {
                    // Primero verifica que los campos no estén vacíos
                    if (_formKey.currentState?.validate() ?? false) {
                      final dni = dniController.text.trim();
                      final telefono = telefonoController.text.trim();

                      // Verificar que el DNI tiene exactamente 8 dígitos y es un número
                      if (dni.length != 8 || int.tryParse(dni) == null) {
                        // Mostrar un mensaje de error si el DNI no es válido
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'El DNI debe ser un número de 8 dígitos.')),
                        );
                        return; // Detener la ejecución si el DNI no es válido
                      }

                      // Verificar que el teléfono es un número válido
                      if (telefono.isEmpty || int.tryParse(telefono) == null) {
                        // Mostrar un mensaje de error si el teléfono no es válido
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'El teléfono debe ser un número válido.')),
                        );
                        return; // Detener la ejecución si el teléfono no es válido
                      }

                      // Si todo está bien, guardar la persona
                      _guardarPersona(context);
                    }
                  },
                  child: const Text(
                    "Aceptar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: (value) =>
          value == null || value.isEmpty ? 'Este campo es obligatorio' : null,
    );
  }
}
