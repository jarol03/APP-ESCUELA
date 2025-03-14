import 'package:avance1/modelo/Alumno.dart';
import 'package:avance1/perfil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avance1/vista/pantalla_login.dart';
import 'package:avance1/estudiante/clases_estudiantes.dart';
import 'package:avance1/estudiante/notas_estudiantes.dart';
import 'package:avance1/anuncios.dart'; // Pantalla global de anuncios

class HomeEstudiante extends StatefulWidget {
  final Alumno alumno;
  const HomeEstudiante({super.key, required this.alumno});

  @override
  _HomeEstudianteState createState() => _HomeEstudianteState();
}

class _HomeEstudianteState extends State<HomeEstudiante> {
  int _selectedIndex = 0;

  // Lista de pantallas del estudiante
  late final List<Widget>
  _pages; // Usa late para inicializar después del constructor

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeEstudianteContent(alumno: widget.alumno,), // Pantalla principal (Inicio)
      const AnunciosScreen(), // Pantalla global de anuncios
      PerfilScreen(alumno: widget.alumno), // Pantalla global de perfil
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido ${widget.alumno.nombre.split(" ")[0]}'),
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

class HomeEstudianteContent extends StatelessWidget {
  final Alumno alumno;
  const HomeEstudianteContent({super.key, required this.alumno});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tareas",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Card para Clases
          _buildTaskRow(
            context,
            Icons.class_,
            "Clases",
            "Ver tus clases asignadas",
            ClasesEstudianteScreen(alumno: alumno,),
          ),
          const SizedBox(height: 16),
          // Card para Notas
          _buildTaskRow(
            context,
            Icons.assignment,
            "Notas",
            "Ver tus notas",
            const NotasEstudianteScreen(),
          ),
        ],
      ),
    );
  }

  // Método para construir una fila de tarea
  Widget _buildTaskRow(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        // Navegar a la pantalla correspondiente
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Card(
        elevation: 4, // Sombra de la tarjeta
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icono
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    100,
                    200,
                    236,
                  ).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: const Color.fromARGB(255, 100, 200, 236),
                ),
              ),
              const SizedBox(width: 16),
              // Título y descripción
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // Icono de flecha
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
