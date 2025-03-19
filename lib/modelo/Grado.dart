import 'package:avance1/modelo/Alumno.dart';
import 'package:avance1/modelo/Materia.dart';
import 'package:avance1/modelo/Maestro.dart';

class Grado {
  final String id;
  final String nombre;
  List<Alumno> alumnos; // Lista de objetos Alumno
  List<Materia> materias; // Lista de objetos Materia
  List<Maestro> maestros; // Lista de objetos Maestro
  String? jornada; // Jornada: Matutina o Vespertina

  Grado({
    required this.id,
    required this.nombre,
    this.alumnos = const [],
    this.materias = const [],
    this.maestros = const [],
    this.jornada,
  });

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nombre": nombre,
      "alumnos": alumnos.map((a) => a.toMap()).toList(),
      "materias": materias.map((m) => m.toMap()).toList(),
      "maestros": maestros.map((m) => m.toMap()).toList(),
      "jornada": jornada,
    };
  }

  // Convertir desde Map
  factory Grado.fromMap(Map<String, dynamic> data) {
    return Grado(
      id: data["id"] ?? '',
      nombre: data["nombre"] ?? '',
      alumnos:
          (data["alumnos"] != null)
              ? (data["alumnos"] as List).map((a) => Alumno.fromMap(a)).toList()
              : [],
      materias:
          (data["materias"] != null)
              ? (data["materias"] as List)
                  .map((m) => Materia.fromMap(m))
                  .toList()
              : [],
      maestros:
          (data["maestros"] != null)
              ? (data["maestros"] as List)
                  .map((m) => Maestro.fromMap(m))
                  .toList()
              : [],
      jornada: data["jornada"],
    );
  }
}
