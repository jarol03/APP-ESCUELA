import 'package:avance1/admin/crear_maestro.dart';
import 'package:avance1/controlador/FireBase_Controller.dart';
import 'package:flutter/material.dart';
import 'package:avance1/modelo/Maestro.dart';

class VeriMaestroScreen extends StatefulWidget {
  const VeriMaestroScreen({super.key});

  @override
  _VeriMaestroScreenState createState() => _VeriMaestroScreenState();
}

class _VeriMaestroScreenState extends State<VeriMaestroScreen> {
  FirebaseController baseDatos = FirebaseController();
  List<Maestro> maestros = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    obtenerMaestros();
  }

  Future<void> obtenerMaestros() async {
    maestros = await baseDatos.obtenerMaestros();
    setState(() {});
  }

  Future<void> eliminarMaestro(String id) async {
    baseDatos.eliminarMaestro(id);
    maestros.removeWhere((maestro) => maestro.id == id);
    setState(() {});
  }

  List<Maestro> get _filteredMaestros {
  return maestros.where((maestro) {
    final nombreCoincide = maestro.nombre.toLowerCase().contains(
      _searchQuery.toLowerCase(),
    );

    final gradosCoinciden = maestro.gradosAsignados.any(
      (grado) => grado.nombre.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      ),
    );

    return nombreCoincide || gradosCoinciden;
  }).toList();
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
                      subtitle: Text(
                        "Grados: ${maestro.gradosAsignados.map((g) => g.nombre).join(', ')}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          CrearMaestroScreen(maestro: maestro),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              eliminarMaestro(maestro.id);
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
