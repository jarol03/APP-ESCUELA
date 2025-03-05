import 'package:flutter/material.dart';
import 'package:avance1/vista/pantalla_login.dart';

class PantallaCarga extends StatefulWidget {
  const PantallaCarga({super.key});

  @override
  _PantallaCargaState createState() => _PantallaCargaState();
}

class _PantallaCargaState extends State<PantallaCarga> {
  @override
  void initState() {
    super.initState();
    // Simulamos un tiempo de carga de 2 segundos antes de redirigir al login
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PantallaLogin()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset('assets/images/logoescuela.jpg')),
    );
  }
}
