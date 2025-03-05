import 'package:flutter/material.dart';
import 'package:avance1/modelo/Materia.dart';
import 'package:avance1/modelo/Maestro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avance1/vista/pantalla_login.dart';

class ClasesEstudianteScreen extends StatefulWidget {
  const ClasesEstudianteScreen({super.key});

  @override
  _ClasesEstudianteScreenState createState() => _ClasesEstudianteScreenState();
}

class _ClasesEstudianteScreenState extends State<ClasesEstudianteScreen> {
  final List<Materia> _clases = [
    Materia(
      id: "1",
      nombre: "Matemáticas",
      descripcion: "Clase de matemáticas",
    ),
    Materia(id: "2", nombre: "Ciencias", descripcion: "Clase de ciencias"),
    // Agregar más clases aquí
  ];

  final List<Maestro> _maestros = [
    Maestro(
      id: "1",
      nombre: "Carlos Sánchez",
      apellido: "Gómez",
      gradoAsignado: "Grado 1",
      tipoMaestro: "Maestro guía",
      email: "carlos@example.com",
      telefono: "123456789",
      usuario: "carlos123",
      contrasena: "password",
      rol: "maestro",
      materias: ["1"],
    ),
    // Agregar más maestros aquí
  ];

  String _searchQuery = "";

  List<Materia> get _filteredClases {
    return _clases
        .where(
          (clase) =>
              clase.nombre.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clases"),
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
          children: [
            // Buscador
            TextField(
              decoration: InputDecoration(
                labelText: "Buscar clase",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Lista de clases
            Expanded(
              child: ListView.builder(
                itemCount: _filteredClases.length,
                itemBuilder: (context, index) {
                  final clase = _filteredClases[index];
                  final maestro = _maestros.firstWhere(
                    (m) => m.materias.contains(clase.id),
                    orElse:
                        () => Maestro(
                          id: "",
                          nombre: "Sin asignar",
                          apellido: "",
                          gradoAsignado: "",
                          tipoMaestro: "",
                          email: "",
                          telefono: "",
                          usuario: "",
                          contrasena: "",
                          rol: "",
                          materias: [],
                        ),
                  );
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(
                          "assets/images/clase_${clase.id}.jpg",
                        ), // Foto de la clase
                      ),
                      title: Text(clase.nombre),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Horario: Lunes y Miércoles 10:00 AM"),
                          Text(
                            "Maestro: ${maestro.nombre} ${maestro.apellido}",
                          ),
                          Text("Nota: 8.5"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
