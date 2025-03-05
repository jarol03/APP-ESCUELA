import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avance1/vista/pantalla_login.dart';
import 'package:avance1/admin/crear_estudiante.dart';
import 'package:avance1/admin/crear_maestro.dart';
import 'package:avance1/admin/verificacion.dart';

class CredencialesScreen extends StatelessWidget {
  const CredencialesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Credenciales"),
        backgroundColor: const Color.fromARGB(255, 100, 200, 236),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs
                  .clear(); // Borra todas las claves/valores de SharedPreferences
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PantallaLogin()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta para Maestro
            _buildCard(
              context,
              Icons.person,
              "MAESTRO",
              "Crear usuario para maestros",
              const CrearMaestroScreen(), // Navega a crear_maestro.dart
            ),
            const SizedBox(height: 16),
            // Tarjeta para Estudiante
            _buildCard(
              context,
              Icons.school,
              "ESTUDIANTE",
              "Crear usuario para estudiante",
              const CrearEstudianteScreen(), // Navega a crear_estudiante.dart
            ),
            const SizedBox(height: 16),
            // Tarjeta para Verificación
            _buildCard(
              context,
              Icons.verified_user,
              "Verificación",
              "Elimina, modifica o muestra la lista de los usuarios por grado.",
              const VerificacionScreen(), // Navega a verificacion.dart
            ),
          ],
        ),
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
        currentIndex: 0, // Índice de la pantalla actual
        selectedItemColor: const Color.fromARGB(255, 100, 200, 236),
        onTap: (index) {
          // Navegar a la pantalla correspondiente
          switch (index) {
            case 0:
              // Navegar a Home
              break;
            case 1:
              // Navegar a Anuncios
              break;
            case 2:
              // Navegar a Perfil
              break;
          }
        },
      ),
    );
  }

  // Método para construir una tarjeta
  Widget _buildCard(
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
              // Ícono
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
              // Ícono de flecha
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
