import 'package:avance1/controlador/FireBase_Controller.dart';
import 'package:avance1/firebase_options.dart';
import 'package:avance1/modelo/Alumno.dart';
import 'package:avance1/modelo/Materia.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Modelo
import 'package:avance1/modelo/Maestro.dart';

// Vista
import 'package:avance1/vista/home_admin.dart';
import 'package:avance1/vista/home_maestro.dart';
import 'package:avance1/vista/home_estudiante.dart';
import 'package:avance1/vista/pantalla_login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
  FirebaseController baseDatos = FirebaseController();
  @override
  void initState() {
    super.initState();
    Materia matematicas = Materia(id: "01", nombre: "Matemáticas", descripcion: "Clase de matemáticas");
    baseDatos.agregarMateria(matematicas);
    print("Pantalla de carga iniciada");
    _verificarSesion();
  }

  void _verificarSesion() async {
    print("Verificando sesión...");
    //await baseDatos.limpiarCache();//ESTO ES PORQUE ELIMINÉ COLECCIONES DESDE CONSOLEFIRE Y TUVE QUE BORRAR CACHE
    //PARA ACTUALIZAR LOS DATOS DE LA APP

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // DESCOMENTA ESTO PARA LIMPIAR DATOS Y PROBAR LOGIN DESDE CERO
    // await prefs.clear();

    bool sesionIniciada = prefs.getBool('sesionIniciada') ?? false;
    String rolUsuario = prefs.getString('rolUsuario') ?? 'oficial';
    String id = prefs.getString('idUsuario') ?? "0";

    print("Sesión iniciada: $sesionIniciada");
    print("Rol del usuario: $rolUsuario");
    print("Id del usuario: $id");

    // Simula la carga durante 3 segundos
    await Future.delayed(const Duration(seconds: 3));

    // Redirigir según el rol del usuario
    Widget pantalla = PantallaLogin();

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
          Maestro? maestro = await baseDatos.buscarMaestroPorId(id);
          print("Redirigiendo a HomeMaestro");
          if (maestro != null) pantalla = HomeMaestro(maestro: maestro);
          break;
        case "alumno":
          Alumno? alumno = await baseDatos.buscarAlumnoPorId(id);
          print("Redirigiendo a HomeEstudiante");
          if (alumno != null) pantalla = HomeEstudiante(alumno: alumno);
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
