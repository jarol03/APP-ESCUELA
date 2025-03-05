import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Modelo
import 'package:avance1/modelo/Maestro.dart';

// Vista
import 'package:avance1/vista/home_admin.dart';
import 'package:avance1/vista/home_maestro.dart';
import 'package:avance1/vista/home_estudiante.dart';
import 'package:avance1/vista/pantalla_login.dart';

void main() {
  runApp(AppPrincipal());
}

class AppPrincipal extends StatelessWidget {
  const AppPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Virtual',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PantallaCarga(), // Iniciamos con la pantalla de carga
    );
  }
}

class PantallaCarga extends StatefulWidget {
  const PantallaCarga({super.key});

  @override
  _PantallaCargaState createState() => _PantallaCargaState();
}

class _PantallaCargaState extends State<PantallaCarga> {
  @override
  void initState() {
    super.initState();
    print("Pantalla de carga iniciada");
    _verificarSesion();
  }

  void _verificarSesion() async {
    print("Verificando sesión...");

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // DESCOMENTA ESTO PARA LIMPIAR DATOS Y PROBAR LOGIN DESDE CERO
    // await prefs.clear();

    bool sesionIniciada = prefs.getBool('sesionIniciada') ?? false;
    String rolUsuario = prefs.getString('rolUsuario') ?? 'oficial';

    print("Sesión iniciada: $sesionIniciada");
    print("Rol del usuario: $rolUsuario");

    // Simula la carga durante 3 segundos
    await Future.delayed(const Duration(seconds: 3));

    // Redirigir según el rol del usuario
    Widget pantalla;

    if (!sesionIniciada) {
      print("Redirigiendo a PantallaLogin");
      pantalla = const PantallaLogin();
    } else {
      switch (rolUsuario) {
        case "admin":
          print("Redirigiendo a HomeAdmin");
          pantalla = const HomeAdmin();
          break;
        case "maestro":
          print("Redirigiendo a HomeMaestro");
          pantalla = HomeMaestro(
            maestro: Maestro(
              id: "1",
              nombre: "Nombre del Maestro",
              apellido: "Apellido del Maestro",
              gradoAsignado: "Grado 1",
              tipoMaestro: "Maestro guía",
              email: "maestro@example.com",
              telefono: "123456789",
              usuario: "maestro123",
              contrasena: "password",
              rol: "maestro",
              materias: [],
            ),
          );
          break;
        case "estudiante":
          print("Redirigiendo a HomeEstudiante");
          pantalla = const HomeEstudiante();
          break;
        default:
          print("Rol no reconocido. Redirigiendo a PantallaLogin");
          pantalla = const PantallaLogin();
          break;
      }
    }

    // Asegurar que el widget sigue montado antes de hacer la navegación
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => pantalla),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logoescuela.jpg',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Color.fromARGB(255, 100, 200, 236),
            ),
          ],
        ),
      ),
    );
  }
}
