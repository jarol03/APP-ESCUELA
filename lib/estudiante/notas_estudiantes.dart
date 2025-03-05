import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avance1/vista/pantalla_login.dart';

class NotasEstudianteScreen extends StatelessWidget {
  const NotasEstudianteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notas"),
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
            const Text(
              "Tus notas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Tabla de notas
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Clase")),
                    DataColumn(label: Text("Nota")),
                    DataColumn(label: Text("Maestro")),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text("Matemáticas")),
                        DataCell(Text("8.5")),
                        DataCell(Text("Carlos Sánchez")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("Ciencias")),
                        DataCell(Text("9.0")),
                        DataCell(Text("Ana Torres")),
                      ],
                    ),
                    // Agregar más filas aquí
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
