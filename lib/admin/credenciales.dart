import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avance1/vista/pantalla_login.dart';
import 'package:avance1/admin/crear_estudiante.dart';
import 'package:avance1/admin/crear_maestro.dart';
import 'package:avance1/admin/verificacion.dart';
import 'package:avance1/anuncios.dart';
import 'package:avance1/perfil.dart';
import 'package:avance1/admin/crear_grados.dart';

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
              await prefs.clear();
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
              const CrearMaestroScreen(),
            ),
            const SizedBox(height: 16),
            // Tarjeta para Estudiante
            _buildCard(
              context,
              Icons.school,
              "ESTUDIANTE",
              "Crear usuario para estudiante",
              const CrearEstudianteScreen(),
            ),
            const SizedBox(height: 16),
            // Tarjeta para Grado
            _buildCard(
              context,
              Icons.class_,
              "GRADO",
              "Crear y asignar materias a grados",
              const CrearGradoScreen(),
            ),
            const SizedBox(height: 16),
            // Tarjeta para Verificación
            _buildCard(
              context,
              Icons.verified_user,
              "Verificación",
              "Verificar credenciales de maeastros, estudiantes o grados",
              const VerificacionScreen(),
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
        currentIndex: 0,
        selectedItemColor: const Color.fromARGB(255, 100, 200, 236),
        onTap: (index) {
          // Navegar a la pantalla correspondiente
          switch (index) {
            case 0:
              // Navegar a Home
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AnunciosScreen()),
              );

              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PerfilScreen()),
              );
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
        elevation: 4,
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
