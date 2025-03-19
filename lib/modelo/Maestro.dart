import 'package:avance1/modelo/Grado.dart';
import 'package:avance1/modelo/Materia.dart';

class Maestro {
  final String id;
  final String nombre;
  List<Grado> gradosAsignados; // Lista de objetos Grado
  final String tipoMaestro;
  final String email;
  final String telefono;
  final String usuario;
  final String contrasena;
  List<Materia> materias; // Lista de objetos Materia
  final String rol = "maestro";

  Maestro({
    required this.id,
    required this.nombre,
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
      "gradosAsignados": gradosAsignados.map((g) => g.toMap()).toList(),
      "tipoMaestro": tipoMaestro,
      "email": email,
      "telefono": telefono,
      "usuario": usuario,
      "contrasena": contrasena,
      "rol": rol,
      "materias": materias.map((m) => m.toMap()).toList(),
    };
  }

  // Convertir desde Map
  factory Maestro.fromMap(Map<String, dynamic> data) {
    return Maestro(
      id: data["id"],
      nombre: data["nombre"],
      gradosAsignados:
          (data["gradosAsignados"] as List)
              .map((g) => Grado.fromMap(g))
              .toList(),
      tipoMaestro: data["tipoMaestro"],
      email: data["email"],
      telefono: data["telefono"],
      usuario: data["usuario"],
      contrasena: data["contrasena"],
      materias:
          (data["materias"] as List).map((m) => Materia.fromMap(m)).toList(),
    );
  }
}
