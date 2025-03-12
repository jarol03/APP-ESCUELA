import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avance1/vista/pantalla_login.dart';
import 'package:avance1/modelo/Grado.dart';
import 'package:avance1/modelo/Materia.dart';

class AsigGradoScreen extends StatefulWidget {
  const AsigGradoScreen({super.key});

  @override
  _AsigGradoScreenState createState() => _AsigGradoScreenState();
}

class _AsigGradoScreenState extends State<AsigGradoScreen> {
  final List<Grado> _grados = [
    Grado(id: "1", nombre: "Grado 1", alumnos: [], materias: []),
    Grado(id: "2", nombre: "Grado 2", alumnos: [], materias: []),
    // Agregar más grados aquí
  ];

  final List<Materia> _materias = [
    Materia(
      id: "1",
      nombre: "Matemáticas",
      descripcion: "Clase de matemáticas",
    ),
    Materia(id: "2", nombre: "Ciencias", descripcion: "Clase de ciencias"),
    // Agregar más materias aquí
  ];

  String _searchQuery = "";

  List<Grado> get _filteredGrados {
    return _grados
        .where(
          (grado) =>
              grado.nombre.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  void _asignarMaterias(Grado grado) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Asignar materias"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                _materias.map((materia) {
                  return CheckboxListTile(
                    title: Text(materia.nombre),
                    value: grado.materias.contains(
                      materia.id,
                    ), // Usamos 'materias'
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          grado.materias.add(materia); // Usamos 'materias'
                        } else {
                          grado.materias.remove(
                            materia.id,
                          ); // Usamos 'materias'
                        }
                      });
                    },
                  );
                }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Asignar materias a grados"),
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
                labelText: "Buscar grado",
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
            // Lista de grados
            Expanded(
              child: ListView.builder(
                itemCount: _filteredGrados.length,
                itemBuilder: (context, index) {
                  final grado = _filteredGrados[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(grado.nombre),
                      trailing: IconButton(
                        icon: const Icon(Icons.add, color: Colors.blue),
                        onPressed: () {
                          _asignarMaterias(grado);
                        },
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
