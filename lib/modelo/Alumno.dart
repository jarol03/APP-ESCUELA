import 'package:avance1/modelo/Grado.dart';

class Alumno {
  final String id;
  final String nombre;
  final Grado grado; // Objeto Grado
  final String email;
  final String telefono;
  final String usuario;
  final String contrasena;
  final String nota;
  final bool active;
  final String rol = "alumno";
  final String fotoPath;

  Alumno({
    required this.id,
    required this.nombre,
    required this.grado,
    required this.email,
    required this.telefono,
    required this.usuario,
    required this.contrasena,
    required this.nota,
    required this.active,
    required this.fotoPath,
  });

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nombre": nombre,
      "grado": grado.toMap(), // Convertir Grado a Map
      "email": email,
      "telefono": telefono,
      "usuario": usuario,
      "contrasena": contrasena,
      "nota": nota,
      "active": active,
      "fotoPath": fotoPath,
    };
  }

  // Convertir desde Map
  factory Alumno.fromMap(Map<String, dynamic> data) {
    return Alumno(
      id: data["id"],
      nombre: data["nombre"],
      grado: Grado.fromMap(data["grado"]), // Convertir Map a objeto Grado
      email: data["email"],
      telefono: data["telefono"],
      usuario: data["usuario"],
      contrasena: data["contrasena"],
      nota: data["nota"],
      active: data["active"],
      fotoPath: data["fotoPath"],
    );
  }
}
