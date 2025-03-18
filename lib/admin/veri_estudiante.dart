import 'package:avance1/admin/crear_estudiante.dart';
import 'package:avance1/controlador/FireBase_Controller.dart';
import 'package:flutter/material.dart';
import 'package:avance1/modelo/Alumno.dart';

class VeriEstudianteScreen extends StatefulWidget {
  const VeriEstudianteScreen({super.key});

  @override
  _VeriEstudianteScreenState createState() => _VeriEstudianteScreenState();
}

class _VeriEstudianteScreenState extends State<VeriEstudianteScreen> {
  final FirebaseController baseDatos = FirebaseController();
  List<Alumno> alumnos = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _obtenerAlumnos(); // Llamamos a la función asincrónica para obtener los alumnos
  }

  // Función asincrónica para obtener los alumnos
  Future<void> _obtenerAlumnos() async {
    alumnos = await baseDatos.obtenerAlumnos();
    setState(() {});
  }

  Future<void> eliminarAlumno(String id) async {
    baseDatos.eliminarAlumno(id);
    alumnos.removeWhere((alumno) => alumno.id == id);
    setState(() {});
  }

  List<Alumno> get _filteredEstudiantes {
    return alumnos
        .where(
          (estudiante) =>
              estudiante.nombre.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              estudiante.grado.nombre.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Buscador
            TextField(
              decoration: InputDecoration(
                labelText: "Buscar estudiante",
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
            // Lista de estudiantes
            Expanded(
              child:
                  alumnos
                          .isEmpty // Verificamos si la lista está vacía
                      ? Center(
                        child: CircularProgressIndicator(),
                      ) // Mostramos un indicador de carga
                      : ListView.builder(
                        itemCount: _filteredEstudiantes.length,
                        itemBuilder: (context, index) {
                          final alumno = _filteredEstudiantes[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              title: Text("${alumno.nombre}"),
                              subtitle: Text("Grado: ${alumno.grado.nombre}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  CrearEstudianteScreen(
                                                    estudiante: alumno,
                                                  ),
                                        ),
                                      );
                                      _obtenerAlumnos(); // Se ejecuta cuando se vuelve a esta pantalla
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      eliminarAlumno(alumno.id);
                                    },
                                  ),
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
