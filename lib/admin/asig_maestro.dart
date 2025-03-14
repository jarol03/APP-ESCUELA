import 'package:avance1/controlador/FireBase_Controller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avance1/vista/pantalla_login.dart';

import 'package:avance1/modelo/Maestro.dart';
import 'package:avance1/modelo/Materia.dart';

class AsigMaestroScreen extends StatefulWidget {
  const AsigMaestroScreen({super.key});

  @override
  _AsigMaestroScreenState createState() => _AsigMaestroScreenState();
}

class _AsigMaestroScreenState extends State<AsigMaestroScreen> {
  final FirebaseController baseDatos = FirebaseController();
  List<Maestro> _maestros = [];

  @override
  void initState() {
    super.initState();
    obtenerMaestros();
  }

  Future<void> obtenerMaestros() async {
    _maestros = await baseDatos.obtenerMaestros();
    setState(() {});
  }

  // Declaración de la lista de materias
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

  // Método para filtrar maestros según la búsqueda
  List<Maestro> get _filteredMaestros {
    return _maestros
        .where(
          (maestro) =>
              maestro.nombre.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              maestro.gradosAsignados[0].nombre.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
        )
        .toList();
  }

  // Método para asignar materias a un maestro
  void _asignarMaterias(Maestro maestro) {
    List<String> materiasSeleccionadas =
        maestro.materias.map((materia) => materia.id).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text("Asignar materias a ${maestro.nombre.split(" ")[0]}"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    _materias.map((materia) {
                      return CheckboxListTile(
                        title: Text(materia.nombre),
                        subtitle: Text(materia.descripcion),
                        value: materiasSeleccionadas.contains(materia.id),
                        onChanged: (bool? value) {
                          setStateDialog(() {
                            if (value == true) {
                              materiasSeleccionadas.add(materia.id);
                            } else {
                              materiasSeleccionadas.remove(materia.id);
                            }
                          });
                        },
                      );
                    }).toList(),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    // Actualizar la lista de materias asignadas al maestro
                    maestro.materias =
                        _materias
                            .where(
                              (materia) =>
                                  materiasSeleccionadas.contains(materia.id),
                            )
                            .toList();

                    // Actualizar el maestro en Firebase
                    await baseDatos.actualizarMaestro(maestro);

                    Navigator.of(context).pop();
                    setState(() {}); // Actualizar la UI
                  },
                  child: const Text("Guardar"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancelar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Asignar clases a maestros"),
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
                labelText: "Buscar maestro",
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
            // Lista de maestros
            Expanded(
              child: ListView.builder(
                itemCount: _filteredMaestros.length,
                itemBuilder: (context, index) {
                  final maestro = _filteredMaestros[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text("${maestro.nombre} ${maestro.apellido}"),
                      subtitle: Text(
                        "Grados: ${maestro.gradosAsignados.map((g) => g.id).join(', ')}",
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add, color: Colors.blue),
                        onPressed: () {
                          _asignarMaterias(maestro);
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
