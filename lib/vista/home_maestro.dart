import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avance1/vista/pantalla_login.dart';
import 'package:avance1/modelo/Maestro.dart';
import 'package:avance1/maestro/clases.dart';
import 'package:avance1/maestro/notas_maestro.dart';
import 'package:avance1/anuncios.dart';
import 'package:avance1/perfil.dart';

class HomeMaestro extends StatefulWidget {
  final Maestro maestro;

  const HomeMaestro({super.key, required this.maestro});

  @override
  _HomeMaestroState createState() => _HomeMaestroState();
}

class _HomeMaestroState extends State<HomeMaestro> {
  int _selectedIndex = 0;

  // Lista de pantallas del maestro
  List<Widget> get _pages => [
    HomeMaestroContent(maestro: widget.maestro), // Pantalla principal (Inicio)
    const AnunciosScreen(), // Pantalla global de anuncios
    PerfilScreen(maestro: widget.maestro), // Pantalla global de perfil
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
        title: const Text("Panel Maestro"),
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

class HomeMaestroContent extends StatelessWidget {
  final Maestro maestro;

  const HomeMaestroContent({super.key, required this.maestro});

  @override
  Widget build(BuildContext context) {
    // Obtener las partes del nombre
    final nombreParts = maestro.nombre.split(" ");
    final primerNombre = nombreParts.isNotEmpty ? nombreParts[0] : "";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          // Encabezado con nombre de usuario y avatar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mostrar solo el primer nombre
                  Text(
                    "Bienvenido, $primerNombre",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
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
          // Contenedor de información
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
                _buildInfoItem(
                  "Clases",
                  maestro.gradosAsignados.length.toString(),
                ),
                _buildInfoItem("Estudiantes", "25"),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Título de la sección de tareas
          const Text(
            "Acciones",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Contenedor de tareas
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
                  _buildTaskRow(context, Icons.class_, "Clases", () {
                    // Navegar a la pantalla de clases
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClasesScreen(maestro: maestro),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  _buildTaskRow(context, Icons.assignment, "Notas", () {
                    // Navegar a la pantalla de notas
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotasMaestroScreen(),
                      ),
                    );
                  }),
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
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 100, 200, 236),
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
