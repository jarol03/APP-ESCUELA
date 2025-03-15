import 'package:flutter/material.dart';
import 'package:avance1/modelo/Perfil.dart';
import 'package:avance1/modelo/Maestro.dart';
import 'package:avance1/modelo/Alumno.dart';

class PerfilScreen extends StatelessWidget {
  final Maestro? maestro;
  final Alumno? alumno;
  final Perfil? perfil;

  const PerfilScreen({super.key, this.maestro, this.alumno, this.perfil});

  @override
  Widget build(BuildContext context) {
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
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/usuario.jpg"),
                ),
                const SizedBox(height: 20),
                if (maestro != null) _buildMaestroInfo(maestro!),
                if (alumno != null) _buildAlumnoInfo(alumno!),
                if (perfil != null) _buildAdminInfo(perfil!),
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
        _buildInfoRow("Nombre", "${maestro.nombre}"),
        _buildInfoRow("Email", maestro.email),
        _buildInfoRow("Teléfono", maestro.telefono),
        _buildInfoRow("Grados Asignados", maestro.gradosAsignados.map((m) => m.nombre).join(", ")),
        _buildInfoRow("Materias", maestro.materias.map((m) => m.nombre).join(", ")),
      ],
    );
  }

  Widget _buildAlumnoInfo(Alumno alumno) {
    return Column(
      children: [
        _buildInfoRow("Nombre", "${alumno.nombre}"),
        _buildInfoRow("Email", alumno.email),
        _buildInfoRow("Teléfono", alumno.telefono),
        _buildInfoRow("Grado", alumno.grado.nombre),
        _buildInfoRow("Materias", alumno.grado.materias.map((m) => m.nombre).join(", ")),

      ],
    );
  }

  Widget _buildAdminInfo(Perfil perfil) {
    return Column(
      children: [
        _buildInfoRow("Nombre", "${perfil.nombre}"),
        _buildInfoRow("Email", perfil.email),
        _buildInfoRow("Teléfono", perfil.telefono),
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
