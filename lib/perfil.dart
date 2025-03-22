import 'package:avance1/controlador/FireBase_Controller.dart';
import 'package:flutter/material.dart';
import 'package:avance1/modelo/Maestro.dart';
import 'package:avance1/modelo/Alumno.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io'; // Importar para manejar archivos locales

class PerfilScreen extends StatefulWidget {
  final String? alumnoId;
  final String? maestroId;

  const PerfilScreen({super.key, this.maestroId, this.alumnoId});

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imagenSeleccionada;
  FirebaseController baseDatos = FirebaseController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Maestro? maestro;
  Alumno? alumno;

  @override
  void initState() {
    super.initState();
    obtenerAlumnoOMaestro();
  }

  Future<void> obtenerAlumnoOMaestro() async {
    if (widget.alumnoId != null) {
      alumno = await baseDatos.buscarAlumnoPorId(widget.alumnoId!);
    } else if (widget.maestroId != null) {
      maestro = await baseDatos.buscarMaestroPorId(widget.maestroId!);
    }

    setState(() {}); // Actualizar la UI después de obtener los datos
  }

  Future<void> _seleccionarFoto() async {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() {
        _imagenSeleccionada = File(imagen.path);
      });

      // Guardar la ruta de la imagen en Firestore
      await _guardarFotoEnFirestore(_imagenSeleccionada!.path);
      print("IMAGEN ACTUALIZADA: " + _imagenSeleccionada!.path);
    }
  }

  String _formatearNombre(String nombreCompleto) {
    List<String> partes = nombreCompleto.split(
      " ",
    ); // Divide el nombre en partes
    if (partes.length >= 2) {
      return "${partes[0]} ${partes.last}"; // Primer nombre + último apellido
    }
    return nombreCompleto;
  }

  Future<void> _guardarFotoEnFirestore(String fotoPath) async {
    if (maestro != null) {
      // Actualizar la foto del maestro en Firestore
      await _firestore.collection('maestros').doc(maestro!.id).update({
        'fotoPath': fotoPath,
      });
    } else if (alumno != null) {
      // Actualizar la foto del alumno en Firestore
      await _firestore.collection('alumnos').doc(alumno!.id).update({
        'fotoPath': fotoPath,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtener la foto del usuario según su rol
    String fotoPath;
    if (maestro != null) {
      fotoPath = maestro!.fotoPath; // Usar la ruta de la foto del maestro
    } else if (alumno != null) {
      fotoPath = alumno!.fotoPath; // Usar la ruta de la foto del alumno
    } else {
      fotoPath = "assets/images/profile.jpg"; // Foto por defecto
    }

    print("********************** FOTO **********************");
    print(fotoPath);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
        backgroundColor: const Color.fromARGB(255, 100, 200, 236),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Contenedor para la foto y el ícono de edición
                GestureDetector(
                  onTap: _seleccionarFoto,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            _imagenSeleccionada != null
                                ? FileImage(
                                  _imagenSeleccionada!,
                                ) // Mostrar la imagen seleccionada
                                : fotoPath.isNotEmpty
                                ? FileImage(
                                  File(fotoPath),
                                ) // Mostrar la imagen desde Firestore
                                : AssetImage("assets/profile.jpg")
                                    as ImageProvider, // Foto por defecto
                      ),
                      // Ícono de edición
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (maestro != null) _buildMaestroInfo(maestro!),
                if (alumno != null) _buildAlumnoInfo(alumno!),
                if(alumno == null && maestro == null) _buildInfoRow("Nombre:", "Admin")
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMaestroInfo(Maestro maestro) {
    return Column(
      children: [
        _buildInfoRow("Nombre", _formatearNombre(maestro.nombre)),
        _buildInfoRow("Email", maestro.email),
        _buildInfoRow("Teléfono", maestro.telefono),
        _buildInfoRow(
          "Grados Asignados",
          maestro.gradosAsignados.map((m) => m.id).join(", "),
        ),
        _buildInfoRow(
          "Materias",
          maestro.materias.map((m) => m.nombre).join(", "),
        ),
      ],
    );
  }

  Widget _buildAlumnoInfo(Alumno alumno) {
    return Column(
      children: [
        _buildInfoRow("Nombre", _formatearNombre(alumno.nombre)),
        _buildInfoRow("Email", alumno.email),
        _buildInfoRow("Teléfono", alumno.telefono),
        _buildInfoRow("Grado", alumno.grado.nombre),
        _buildInfoRow(
          "Materias",
          alumno.grado.materias.map((m) => m.nombre).join(", "),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
