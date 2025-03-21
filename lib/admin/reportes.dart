import 'package:avance1/controlador/FireBase_Controller.dart';
import 'package:avance1/modelo/Grado.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avance1/modelo/Alumno.dart';
import 'package:avance1/modelo/Materia.dart';
import 'package:avance1/modelo/Maestro.dart';
import 'package:avance1/vista/pantalla_login.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportesScreen extends StatefulWidget {
  const ReportesScreen({super.key});

  @override
  _ReportesScreenState createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {
  final FirebaseController baseDatos = FirebaseController();
  List<Alumno> alumnos = [];
  List<Maestro> maestros = [];
  final TextEditingController _searchController = TextEditingController();

  Future<void> obtenerAlumnos() async {
    alumnos = await baseDatos.obtenerAlumnos();
  }

  Future<void> obtenerMaestros() async {
    maestros = await baseDatos.obtenerMaestros();
  }

  @override
  void initState() {
    super.initState();
    obtenerAlumnos();
    obtenerMaestros();
  }

  final List<Materia> _materias = [
    Materia(
      id: "1",
      nombre: "Matemáticas",
      descripcion: "Clase de matemáticas",
    ),
    Materia(id: "2", nombre: "Ciencias", descripcion: "Clase de ciencias"),
    // Agregar más materias aquí
  ];

  Alumno? _estudianteSeleccionado;
  Maestro? _maestroSeleccionado;

  void _buscarEstudiante() {
    final String id = _searchController.text.trim();
    setState(() {
      _estudianteSeleccionado = alumnos.firstWhere(
        (estudiante) => estudiante.id == id,
        orElse:
            () => Alumno(
              id: "",
              nombre: "",
              grado: Grado(id: "", nombre: ""),
              email: "",
              telefono: "",
              usuario: "",
              contrasena: "",
              nota: "",
              active: false,
              fotoPath: '',
            ),
      );
    });
  }

  Future<void> _generarReporteEstudiantePDF() async {
    if (_estudianteSeleccionado != null) {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Text(
                    "Reporte de Estudiante",
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  "Nombre: ${_estudianteSeleccionado!.nombre}",
                  style: pw.TextStyle(fontSize: 16),
                ),
                pw.Text(
                  "Grado: ${_estudianteSeleccionado!.grado}",
                  style: pw.TextStyle(fontSize: 16),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  "Materias inscritas:",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Column(
                  children:
                      _estudianteSeleccionado!.grado.materias.map((materiaId) {
                        final materia = _materias.firstWhere(
                          (m) => m.id == materiaId,
                          orElse:
                              () =>
                                  Materia(id: "", nombre: "", descripcion: ""),
                        );
                        return pw.Text(
                          "- ${materia.nombre}",
                          style: pw.TextStyle(fontSize: 14),
                        );
                      }).toList(),
                ),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } else {
      print("No se ha seleccionado un estudiante");
    }
  }

  Future<void> _generarReporteMaestroPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text(
                  "Reporte de Maestros",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                "Lista de Maestros:",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Column(
                children:
                    maestros.map((maestro) {
                      return pw.Text(
                        "- ${maestro.nombre} (${maestro.gradosAsignados})",
                        style: pw.TextStyle(fontSize: 14),
                      );
                    }).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reportes"),
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
            // Buscador de estudiantes
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Buscar estudiante por ID",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                _buscarEstudiante();
              },
            ),
            const SizedBox(height: 16),
            // Información del estudiante seleccionado
            if (_estudianteSeleccionado != null)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nombre: ${_estudianteSeleccionado!.nombre}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("Grado: ${_estudianteSeleccionado!.grado}"),
                      const SizedBox(height: 8),
                      Text("Materias inscritas:"),
                      Column(
                        children:
                            _estudianteSeleccionado!.grado.materias.map((
                              materiaId,
                            ) {
                              final materia = _materias.firstWhere(
                                (m) => m.id == materiaId,
                                orElse:
                                    () => Materia(
                                      id: "",
                                      nombre: "",
                                      descripcion: "",
                                    ),
                              );
                              return Text("- ${materia.nombre}");
                            }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Botón para generar reporte de estudiante
            ElevatedButton(
              onPressed: _generarReporteEstudiantePDF,
              child: const Text("Generar Reporte de Estudiante en PDF"),
            ),
            const SizedBox(height: 16),
            // Botón para generar reporte de maestros
            ElevatedButton(
              onPressed: _generarReporteMaestroPDF,
              child: const Text("Generar Reporte de Maestros en PDF"),
            ),
          ],
        ),
      ),
    );
  }
}
