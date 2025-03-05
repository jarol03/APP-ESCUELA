import 'package:flutter/material.dart';
import 'package:avance1/maestro/notas_maestro.dart';

class ClasesScreen extends StatefulWidget {
  const ClasesScreen({super.key});

  @override
  _ClasesScreenState createState() => _ClasesScreenState();
}

class _ClasesScreenState extends State<ClasesScreen> {
  final List<String> _grados = ["Grado 1", "Grado 2", "Grado 3"];
  String _searchQuery = "";

  List<String> get _filteredGrados {
    return _grados
        .where(
          (grado) => grado.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  void _mostrarAlumnos(String grado) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Alumnos de $grado"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Lista de alumnos matriculados en $grado"),
              // Aquí puedes agregar la lista de alumnos
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cerrar"),
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
        title: const Text("Clases"),
        backgroundColor: const Color.fromARGB(255, 100, 200, 236),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
            Expanded(
              child: ListView.builder(
                itemCount: _filteredGrados.length,
                itemBuilder: (context, index) {
                  final grado = _filteredGrados[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(grado),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.person),
                            onPressed: () => _mostrarAlumnos(grado),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotasMaestroScreen(),
                                ),
                              );
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
