import 'package:avance1/modelo/Grado.dart';
import 'package:avance1/modelo/Maestro.dart';
import 'package:flutter/material.dart';
import 'package:avance1/maestro/notas_maestro.dart';

class ClasesScreen extends StatefulWidget {
  final Maestro maestro;
  const ClasesScreen({super.key, required this.maestro});

  @override
  _ClasesScreenState createState() => _ClasesScreenState();
}

class _ClasesScreenState extends State<ClasesScreen> {
  List<Grado> _grados = [];
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _grados = widget.maestro.gradosAsignados;
  }

  List<Grado> get _filteredGrados {
    return _grados
        .where(
          (grado) => grado.nombre.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  void _mostrarAlumnos(Grado grado) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Alumnos de ${grado.nombre}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: grado.alumnos.isNotEmpty
              ? grado.alumnos.map((alumno) => Text(alumno.nombre)).toList()
              : [const Text("No hay alumnos matriculados.")], // Mensaje si no hay alumnos
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cerrar"),
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
                      title: Text(grado.nombre),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // IconButton(
                          //   icon: const Icon(Icons.person),
                          //   onPressed: () => _mostrarAlumnos(grado),
                          // ),
                          // IconButton(
                          //   icon: const Icon(Icons.add),
                          //   onPressed: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => ChatBotScreen(),
                          //       ),
                          //     );
                          //   },
                          // ),
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
