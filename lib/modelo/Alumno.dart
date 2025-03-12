import 'package:avance1/modelo/Grado.dart';
import 'package:avance1/modelo/Materia.dart';

class Alumno {
  final String id;
  final String nombre;
  final String apellido;
  final Grado grado; // Objeto Grado
  final String email;
  final String telefono;
  final String usuario;
  final String contrasena;
  final String nota;
  final bool active;
  final List<Materia> materias; // Lista de objetos Materia
  final String rol = "alumno";

  Alumno({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.grado,
    required this.email,
    required this.telefono,
    required this.usuario,
    required this.contrasena,
    required this.nota,
    required this.active,
    required this.materias,
  });

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nombre": nombre,
      "apellido": apellido,
      "grado": grado.toMap(), // Convertir Grado a Map
      "email": email,
      "telefono": telefono,
      "usuario": usuario,
      "contrasena": contrasena,
      "nota": nota,
      "active": active,
      "materias": materias.map((m) => m?.toMap()).toList(), // Convertir lista de Materia a lista de Map
    };
  }

  // Convertir desde Map
  factory Alumno.fromMap(Map<String, dynamic> data) {
    return Alumno(
      id: data["id"],
      nombre: data["nombre"],
      apellido: data["apellido"],
      grado: Grado.fromMap(data["grado"]), // Convertir Map a objeto Grado
      email: data["email"],
      telefono: data["telefono"],
      usuario: data["usuario"],
      contrasena: data["contrasena"],
      nota: data["nota"],
      active: data["active"],
      materias: (data["materias"] as List).map((m) => Materia.fromMap(m)).toList(), // Convertir lista de Map a lista de objetos Materia
    );
  }
}
