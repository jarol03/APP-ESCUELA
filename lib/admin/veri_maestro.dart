import 'package:flutter/material.dart';
import 'package:avance1/modelo/Maestro.dart';

class VeriMaestroScreen extends StatefulWidget {
  const VeriMaestroScreen({super.key});

  @override
  _VeriMaestroScreenState createState() => _VeriMaestroScreenState();
}

class _VeriMaestroScreenState extends State<VeriMaestroScreen> {
  final List<Maestro> _maestros = [
    Maestro(
      id: "12345678",
      nombre: "Carlos Sánchez",
      apellido: "Gómez",
      gradoAsignado: "Grado 1",
      tipoMaestro: "Maestro guía",
      email: "carlos@example.com",
      telefono: "123456789",
      usuario: "carlos123",
      contrasena: "password",
      rol: "Maestro", // Rol agregado
      materias: [],
    ),
    Maestro(
      id: "87654321",
      nombre: "Ana Torres",
      apellido: "López",
      gradoAsignado: "Grado 2",
      tipoMaestro: "Maestro general",
      email: "ana@example.com",
      telefono: "987654321",
      usuario: "ana123",
      contrasena: "password",
      rol: "Maestro", // Rol agregado
      materias: [],
    ),
    // Agregar más maestros aquí
  ];

  String _searchQuery = "";

  List<Maestro> get _filteredMaestros {
    return _maestros
        .where(
          (maestro) =>
              maestro.nombre.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              maestro.gradoAsignado.toLowerCase().contains(
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
                      subtitle: Text("Grado: ${maestro.gradoAsignado}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // Lógica para editar maestro
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Lógica para eliminar maestro
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
