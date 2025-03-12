import 'package:avance1/controlador/FireBase_Controller.dart';
import 'package:avance1/modelo/Alumno.dart';
import 'package:avance1/modelo/Maestro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avance1/vista/home_admin.dart';
import 'package:avance1/vista/home_maestro.dart';
import 'package:avance1/vista/home_estudiante.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  _PantallaLoginState createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final FirebaseController _firebaseController = FirebaseController();

  void manejarInicioSesion() async {
    final String usuario = _usuarioController.text.trim();
    final String contrasena = _contrasenaController.text.trim();

    // Buscar primero al alumno
    final Alumno? alumno = await _firebaseController.buscarAlumno(
      usuario,
      contrasena,
    );

    // Si no lo encontramos, buscar al maestro
    final Maestro? maestro =
        alumno == null
            ? await _firebaseController.buscarMaestro(usuario, contrasena)
            : null;

    if (alumno != null) {
      // Si encontramos al alumno, guardar la sesión
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sesionIniciada', true);
      await prefs.setString('rolUsuario', alumno.rol);
      await prefs.setString('idUsuario', alumno.id); // Guardar el ID del alumno

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeEstudiante(alumno: alumno,),
        ), // Redirige al HomeEstudiante
      );
    } else if (maestro != null) {
      // Si encontramos al maestro, guardar la sesión
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sesionIniciada', true);
      await prefs.setString('rolUsuario', maestro.rol);
      await prefs.setString(
        'idUsuario',
        maestro.id,
      ); // Guardar el ID del alumno

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeMaestro(maestro: maestro),
        ), // Redirige al HomeMaestro
      );
    } else if (usuario == "admin" && contrasena == "admin123") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeAdmin()),
      );
    } else {
      // Si no encontramos al usuario ni como alumno ni como maestro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Usuario o contraseña incorrectos"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio de Sesión", style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 100, 200, 236),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usuarioController,
                decoration: InputDecoration(
                  labelText: "Usuario",
                  prefixIcon: Icon(
                    Icons.person,
                    color: Color.fromARGB(255, 100, 200, 236),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _contrasenaController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Color.fromARGB(255, 100, 200, 236),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: manejarInicioSesion,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Color.fromARGB(255, 100, 200, 236),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("Ingresar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
