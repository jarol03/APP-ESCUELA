import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avance1/modelo/Perfil.dart';
import 'package:avance1/modelo/Maestro.dart';
import 'package:avance1/modelo/Alumno.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Perfil? _perfil;
  Maestro? _maestro;
  Alumno? _alumno;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  void _cargarPerfil() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String rol = prefs.getString('rolUsuario') ?? '';

    if (rol == "maestro") {
      // Cargar datos del maestro
      setState(() {
        _maestro = Maestro(
          id: "12345678",
          nombre: "Carlos Sánchez",
          apellido: "Gómez",
          gradoAsignado: "Grado 1",
          tipoMaestro: "Maestro guía",
          email: "carlos@example.com",
          telefono: "123456789",
          usuario: "carlos123",
          contrasena: "password",
          materias: ["Matemáticas", "Ciencias"],
          rol: "maestro",
        );
      });
    } else if (rol == "alumno") {
      // Cargar datos del alumno
      setState(() {
        _alumno = Alumno(
          id: "87654321",
          nombre: "Juan Pérez",
          apellido: "González",
          grado: "Grado 1",
          email: "juan@example.com",
          telefono: "987654321",
          usuario: "juan123",
          contrasena: "password",
          nota: "A",
          active: true,
          materias: ["Matemáticas", "Ciencias"],
        );
      });
    } else {
      // Cargar datos del admin
      setState(() {
        _perfil = Perfil(
          nombre: "Admin",
          apellido: "Admin",
          email: "admin@example.com",
          telefono: "123456789",
          rol: "admin",
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
        backgroundColor: const Color.fromARGB(255, 100, 200, 236),
        actions: [],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width:
                MediaQuery.of(context).size.width *
                0.9, // 90% del ancho de la pantalla
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
                // Foto circular del admin
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                    "assets/usuario.jpg",
                  ), // Ruta de la imagen
                ),
                const SizedBox(height: 20),
                // Información del perfil
                if (_maestro != null) _buildMaestroInfo(_maestro!),
                if (_alumno != null) _buildAlumnoInfo(_alumno!),
                if (_perfil != null) _buildAdminInfo(_perfil!),
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
        _buildInfoRow("Nombre", "${maestro.nombre} ${maestro.apellido}"),
        const SizedBox(height: 10),
        _buildInfoRow("Email", maestro.email),
        const SizedBox(height: 10),
        _buildInfoRow("Teléfono", maestro.telefono),
        const SizedBox(height: 10),
        _buildInfoRow("Grado Asignado", maestro.gradoAsignado),
        const SizedBox(height: 10),
        _buildInfoRow("Materias", maestro.materias.join(", ")),
      ],
    );
  }

  Widget _buildAlumnoInfo(Alumno alumno) {
    return Column(
      children: [
        _buildInfoRow("Nombre", "${alumno.nombre} ${alumno.apellido}"),
        const SizedBox(height: 10),
        _buildInfoRow("Email", alumno.email),
        const SizedBox(height: 10),
        _buildInfoRow("Teléfono", alumno.telefono),
        const SizedBox(height: 10),
        _buildInfoRow("Grado", alumno.grado),
        const SizedBox(height: 10),
        _buildInfoRow("Materias", alumno.materias.join(", ")),
      ],
    );
  }

  Widget _buildAdminInfo(Perfil perfil) {
    return Column(
      children: [
        _buildInfoRow("Nombre", "${perfil.nombre} ${perfil.apellido}"),
        const SizedBox(height: 10),
        _buildInfoRow("Email", perfil.email),
        const SizedBox(height: 10),
        _buildInfoRow("Teléfono", perfil.telefono),
        const SizedBox(height: 10),
        _buildInfoRow("Rol", perfil.rol),
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
