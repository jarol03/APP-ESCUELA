class Alumno {
  final String id; // Identificador único (DNI)
  final String nombre;
  final String apellido;
  final String grado; // Grado al que pertenece
  final String email;
  final String telefono;
  final String usuario;
  final String contrasena;
  final String nota;
  final bool active;
  final List<String> materias; // Lista de IDs de materias

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
    required this.materias, // Ahora está definido como campo
  });

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nombre": nombre,
      "apellido": apellido,
      "grado": grado,
      "email": email,
      "telefono": telefono,
      "usuario": usuario,
      "contrasena": contrasena,
      "nota": nota,
      "active": active,
      "materias": materias,
    };
  }

  // Convertir desde Map
  factory Alumno.fromMap(Map<String, dynamic> data) {
    return Alumno(
      id: data["id"],
      nombre: data["nombre"],
      apellido: data["apellido"],
      grado: data["grado"],
      email: data["email"],
      telefono: data["telefono"],
      usuario: data["usuario"],
      contrasena: data["contrasena"],
      nota: data["nota"],
      active: data["active"],
      materias: List<String>.from(data["materias"]),
    );
  }
}
