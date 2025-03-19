import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avance1/admin/veri_estudiante.dart';
import 'package:avance1/admin/veri_maestro.dart';
import 'package:avance1/admin/veri_grado.dart'; // Importamos la nueva pantalla
import 'package:avance1/vista/pantalla_login.dart';

class VerificacionScreen extends StatefulWidget {
  const VerificacionScreen({super.key});

  @override
  _VerificacionScreenState createState() => _VerificacionScreenState();
}

class _VerificacionScreenState extends State<VerificacionScreen> {
  int _selectedIndex = 0;

  // Lista de pantallas de verificación
  final List<Widget> _pages = [
    const VeriEstudianteScreen(), // Pantalla de verificación de estudiantes
    const VeriMaestroScreen(), // Pantalla de verificación de maestros
    const VeriGradoScreen(), // Pantalla de verificación de grados
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verificación"),
        backgroundColor: const Color.fromARGB(255, 100, 200, 236),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PantallaLogin()),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex], // Muestra la pantalla seleccionada
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Estudiantes',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Maestros'),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_), // Ícono para grados
            label: 'Grados',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 100, 200, 236),
        onTap: _onItemTapped,
      ),
    );
  }
}
