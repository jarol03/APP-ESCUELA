import 'package:avance1/controlador/FireBase_Controller.dart';
import 'package:avance1/modelo/Alumno.dart';
import 'package:avance1/modelo/Maestro.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avance1/vista/pantalla_login.dart';
import 'package:avance1/anuncios.dart';
import 'package:avance1/perfil.dart';
import 'package:avance1/admin/credenciales.dart';
import 'package:avance1/admin/reportes.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  FirebaseController baseDatos = FirebaseController();
  List<Alumno> alumnos = [];
  List<Maestro> maestros = [];
  final List<Widget> _pages = [];
  int _selectedIndex = 0;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    obtenerListas();
  }

  void obtenerListas() async {
    alumnos = await baseDatos.obtenerAlumnos();
    maestros = await baseDatos.obtenerMaestros();
    setState(() {
      _pages.addAll([
        HomeAdminContent(alumnos: alumnos, maestros: maestros),
        const AnunciosScreen(),
        const PerfilScreen(),
      ]);
      cargando = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          cargando
              ? const Center(child: CircularProgressIndicator())
              : _pages[_selectedIndex],
      appBar: AppBar(
        title: const Text("Panel Admin"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, size: 30),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Anuncios',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 100, 200, 236),
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeAdminContent extends StatefulWidget {
  final List<Alumno> alumnos;
  final List<Maestro> maestros;
  

  const HomeAdminContent({
    super.key,
    required this.alumnos,
    required this.maestros,
  });

  @override
  State<HomeAdminContent> createState() => _HomeAdminContentState();
}

class _HomeAdminContentState extends State<HomeAdminContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bienvenido, Admin",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    DateFormat('dd/MM/yyyy').format(DateTime.now()),
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage("assets/profile.jpg"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 5),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem("Estudiantes", widget.alumnos.length.toString()),
                _buildInfoItem("Maestros", widget.maestros.length.toString()),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Tareas",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 5),
                ],
              ),
              child: Column(
                children: [
                  _buildTaskRow(
                    context,
                    Icons.person,
                    "Credenciales",
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CredencialesScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTaskRow(
                    context,
                    Icons.bar_chart,
                    "Reportes",
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReportesScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 100, 200, 236),
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTaskRow(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 100, 200, 236),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
