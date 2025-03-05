import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avance1/vista/home_admin.dart';
import 'package:avance1/vista/home_maestro.dart';
import 'package:avance1/vista/home_estudiante.dart';
import 'package:avance1/modelo/Maestro.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  _PantallaLoginState createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  final Map<String, Map<String, String>> usuarios = {
    "admin": {"contrasena": "admin123", "rol": "admin"},
    "maestro": {"contrasena": "maestro123", "rol": "maestro"},
    "estudiante": {"contrasena": "estudiante123", "rol": "estudiante"},
  };

  void manejarInicioSesion() async {
    final String usuario = _usuarioController.text.trim();
    final String contrasena = _contrasenaController.text.trim();

    if (usuarios.containsKey(usuario) &&
        usuarios[usuario]!["contrasena"] == contrasena) {
      final String rol = usuarios[usuario]!["rol"]!;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sesionIniciada', true);
      await prefs.setString('rolUsuario', rol);

      Widget pantalla;
      switch (rol) {
        case "admin":
          pantalla = HomeAdmin();
          break;
        case "maestro":
          pantalla = HomeMaestro(
            maestro: Maestro(
              id: "12345678",
              nombre: "Nombre del Maestro",
              apellido: "Apellido del Maestro",
              gradoAsignado: "Grado 1",
              tipoMaestro: "Maestro guía",
              email: "maestro@example.com",
              telefono: "123456789",
              usuario: "maestro123",
              contrasena: "maestro123",
              materias: [],
              rol: "maestro",
            ),
          );
          break;
        case "estudiante":
          pantalla = HomeEstudiante();
          break;
        default:
          pantalla = HomeEstudiante();
          break;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => pantalla),
      );
    } else {
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
