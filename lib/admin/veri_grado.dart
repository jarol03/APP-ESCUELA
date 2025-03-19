import 'package:avance1/admin/crear_grados.dart';
import 'package:avance1/controlador/FireBase_Controller.dart';
import 'package:flutter/material.dart';
import 'package:avance1/modelo/Grado.dart';

class VeriGradoScreen extends StatefulWidget {
  const VeriGradoScreen({super.key});

  @override
  _VeriGradoScreenState createState() => _VeriGradoScreenState();
}

class _VeriGradoScreenState extends State<VeriGradoScreen> {
  final FirebaseController baseDatos = FirebaseController();
  List<Grado> grados = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _obtenerGrados(); // Llamamos a la función asincrónica para obtener los grados
  }

  // Función asincrónica para obtener los grados
  Future<void> _obtenerGrados() async {
    grados = await baseDatos.obtenerGrados();
    setState(() {});
  }

  Future<void> eliminarGrado(String id) async {
    baseDatos.eliminarGrado(id);
    grados.removeWhere((grado) => grado.id == id);
    setState(() {});
  }

  List<Grado> get _filteredGrados {
    return grados
        .where(
          (grado) =>
              grado.nombre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              grado.jornada!.toLowerCase().contains(_searchQuery.toLowerCase()),
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
              child:
                  grados.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: _filteredGrados.length,
                        itemBuilder: (context, index) {
                          final grado = _filteredGrados[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              title: Text(grado.nombre),
                              subtitle: Text("Jornada: ${grado.jornada}"),
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
                                              (context) => CrearGradoScreen(
                                                grado: grado,
                                              ),
                                        ),
                                      );
                                      _obtenerGrados(); // Se ejecuta cuando se vuelve a esta pantalla
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      eliminarGrado(grado.id);
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
