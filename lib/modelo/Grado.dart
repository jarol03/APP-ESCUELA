import 'package:avance1/modelo/Alumno.dart';
import 'package:avance1/modelo/Materia.dart';

class Grado {
  final String id;
  final String nombre;
  List<Alumno> alumnos; // Lista de objetos Alumno
  List<Materia> materias; // Lista de objetos Materia
/**
 * A cada clase de cada grado hay que agregarle un ID
 * 
 */
  Grado({
    required this.id,
    required this.nombre,
    this.alumnos = const [],
    this.materias = const [],
  });

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nombre": nombre,
      "alumnos": alumnos.map((a) => a.toMap()).toList(), // Convertir lista de Alumno a lista de Map
      "materias": materias.map((m) => m.toMap()).toList(), // Convertir lista de Materia a lista de Map
    };
  }

  // Convertir desde Map
  factory Grado.fromMap(Map<String, dynamic> data) {
    return Grado(
      id: data["id"],
      nombre: data["nombre"],
      alumnos: (data["alumnos"] as List).map((a) => Alumno.fromMap(a)).toList(), // Convertir lista de Map a lista de objetos Alumno
      materias: (data["materias"] as List).map((m) => Materia.fromMap(m)).toList(), // Convertir lista de Map a lista de objetos Materia
    );
  }
}
