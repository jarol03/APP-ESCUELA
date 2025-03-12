import 'package:avance1/modelo/Grado.dart';
import 'package:avance1/modelo/Materia.dart';

class Maestro {
  final String id;
  final String nombre;
  final String apellido;
  final List<Grado> gradosAsignados; // Lista de objetos Grado
  final String tipoMaestro;
  final String email;
  final String telefono;
  final String usuario;
  final String contrasena;
  final List<Materia> materias; // Lista de objetos Materia
  final String rol = "maestro";

  Maestro({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.gradosAsignados,
    required this.tipoMaestro,
    required this.email,
    required this.telefono,
    required this.usuario,
    required this.contrasena,
    required this.materias,
  });

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nombre": nombre,
      "apellido": apellido,
      "gradosAsignados": gradosAsignados.map((g) => g.toMap()).toList(), // Convertir lista de Grado a lista de Map
      "tipoMaestro": tipoMaestro,
      "email": email,
      "telefono": telefono,
      "usuario": usuario,
      "contrasena": contrasena,
      "rol": rol,
      "materias": materias.map((m) => m.toMap()).toList(), // Convertir lista de Materia a lista de Map
    };
  }

  // Convertir desde Map
  factory Maestro.fromMap(Map<String, dynamic> data) {
    return Maestro(
      id: data["id"],
      nombre: data["nombre"],
      apellido: data["apellido"],
      gradosAsignados: (data["gradosAsignados"] as List).map((g) => Grado.fromMap(g)).toList(), // Convertir lista de Map a lista de objetos Grado
      tipoMaestro: data["tipoMaestro"],
      email: data["email"],
      telefono: data["telefono"],
      usuario: data["usuario"],
      contrasena: data["contrasena"],
      materias: (data["materias"] as List).map((m) => Materia.fromMap(m)).toList(), // Convertir lista de Map a lista de objetos Materia
    );
  }
}
