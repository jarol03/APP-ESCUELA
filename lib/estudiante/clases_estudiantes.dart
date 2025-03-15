import 'package:avance1/controlador/FireBase_Controller.dart';
import 'package:avance1/modelo/Alumno.dart';
import 'package:flutter/material.dart';
import 'package:avance1/modelo/Materia.dart';
import 'package:avance1/modelo/Maestro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avance1/vista/pantalla_login.dart';

class ClasesEstudianteScreen extends StatefulWidget {
  final Alumno alumno;
  const ClasesEstudianteScreen({super.key, required this.alumno});

  @override
  _ClasesEstudianteScreenState createState() => _ClasesEstudianteScreenState();
}

class _ClasesEstudianteScreenState extends State<ClasesEstudianteScreen> {
  FirebaseController baseDatos = FirebaseController();
  List<Maestro> maestros = [];
  List<Materia> _clases = [];

  Future<void> obtenerMaestros() async {
    maestros = await baseDatos.obtenerMaestros();
  }

  @override
  void initState() {
    super.initState();
    obtenerMaestros();
    _clases = widget.alumno.grado.materias;
  }
  

  String _searchQuery = "";

  List<Materia> get _filteredClases {
    return _clases
        .where(
          (clase) =>
              clase.nombre.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clases"),
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
                labelText: "Buscar clase",
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
            // Lista de clases
            Expanded(
              child: ListView.builder(
                itemCount: _filteredClases.length,
                itemBuilder: (context, index) {
                  final clase = _filteredClases[index];
                  final maestro = maestros.firstWhere(
                    (m) => m.materias.contains(clase.id),
                    orElse:
                        () => Maestro(
                          id: "",
                          nombre: "Sin asignar",
                          apellido: "",
                          gradosAsignados: [],
                          tipoMaestro: "",
                          email: "",
                          telefono: "",
                          usuario: "",
                          contrasena: "",
                          materias: [],
                        ),
                  );
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(
                          "assets/images/clase_${clase.id}.jpg",
                        ), // Foto de la clase
                      ),
                      title: Text(clase.nombre),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Horario: Lunes y Miércoles 10:00 AM"),
                          Text(
                            "Maestro: ${maestro.nombre} ${maestro.apellido}",
                          ),
                          Text("Nota: ${widget.alumno.nota}"),
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
