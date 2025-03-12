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
  List<Alumno> _estudiantes = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _obtenerAlumnos(); // Llamamos a la función asincrónica para obtener los alumnos
  }

  // Función asincrónica para obtener los alumnos
  Future<void> _obtenerAlumnos() async {
    List<Alumno> alumnos = await baseDatos.obtenerAlumnos();
    setState(() {
      _estudiantes = alumnos; // Actualizamos el estado con los alumnos obtenidos
    });
  }

  List<Alumno> get _filteredEstudiantes {
    return _estudiantes
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
              child: _estudiantes.isEmpty // Verificamos si la lista está vacía
                  ? Center(child: CircularProgressIndicator()) // Mostramos un indicador de carga
                  : ListView.builder(
                      itemCount: _filteredEstudiantes.length,
                      itemBuilder: (context, index) {
                        final estudiante = _filteredEstudiantes[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            title: Text(
                              "${estudiante.nombre} ${estudiante.apellido}",
                            ),
                            subtitle: Text("Grado: ${estudiante.grado}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    // Lógica para editar estudiante
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    // Lógica para eliminar estudiante
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
