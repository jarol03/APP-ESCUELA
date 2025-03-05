import 'package:flutter/material.dart';
import 'package:avance1/modelo/Alumno.dart';

class VeriEstudianteScreen extends StatefulWidget {
  const VeriEstudianteScreen({super.key});

  @override
  _VeriEstudianteScreenState createState() => _VeriEstudianteScreenState();
}

class _VeriEstudianteScreenState extends State<VeriEstudianteScreen> {
  final List<Alumno> _estudiantes = [
    Alumno(
      id: "12345678",
      nombre: "Juan Pérez",
      apellido: "González",
      grado: "Grado 1",
      email: "juan@example.com",
      telefono: "123456789",
      usuario: "juan123",
      contrasena: "password",
      nota: "A",
      active: true,
      materias:
          [], // Agrega una lista vacía o una lista con las materias correspondientes
    ),
    Alumno(
      id: "87654321",
      nombre: "María López",
      apellido: "Martínez",
      grado: "Grado 2",
      email: "maria@example.com",
      telefono: "987654321",
      usuario: "maria123",
      contrasena: "password",
      nota: "B",
      active: true,
      materias:
          [], // Agrega una lista vacía o una lista con las materias correspondientes
    ),
    // Agregar más estudiantes aquí
  ];

  String _searchQuery = "";

  List<Alumno> get _filteredEstudiantes {
    return _estudiantes
        .where(
          (estudiante) =>
              estudiante.nombre.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              estudiante.grado.toLowerCase().contains(
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
              child: ListView.builder(
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
