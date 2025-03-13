import 'package:avance1/controlador/FireBase_Controller.dart';
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
  FirebaseController baseDatos = FirebaseController();
  List<Grado> _grados = [];

  @override
  void initState() {
    super.initState();
    obtenerGrados();
  }

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

  Future<void> obtenerGrados() async {
    _grados = await baseDatos.obtenerGrados();
    setState(() {});
  }

  void _asignarMaterias(Grado grado) {
    // Copiar las materias actuales del grado
    List<Materia> materiasSeleccionadas = List.from(grado.materias);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          // Usar StatefulBuilder para mantener el estado en el diálogo
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Asignar materias"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    _materias.map((materia) {
                      return CheckboxListTile(
                        title: Text(materia.nombre),
                        value: materiasSeleccionadas.any(
                          (m) => m.id == materia.id,
                        ), // Verifica si la materia está asignada
                        onChanged: (value) {
                          setDialogState(() {
                            if (value!) {
                              // Agregar la materia seleccionada
                              if (!materiasSeleccionadas.any(
                                (m) => m.id == materia.id,
                              )) {
                                materiasSeleccionadas.add(materia);
                              }
                            } else {
                              // Eliminar la materia seleccionada
                              materiasSeleccionadas.removeWhere(
                                (m) => m.id == materia.id,
                              );
                            }
                          });
                        },
                      );
                    }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    // Actualizar las materias del grado con el nuevo estado
                    grado.materias = materiasSeleccionadas;
                    // Guardamos el grado actualizado en la base de datos
                    await baseDatos.agregarGrado(grado);
                    setState(
                      () {},
                    ); // Refrescar la lista de grados en la pantalla principal
                    Navigator.pop(context);
                  },
                  child: const Text("Guardar"),
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
