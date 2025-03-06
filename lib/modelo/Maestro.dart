class Maestro {
  final String id; // Identificador único
  final String nombre;
  final String apellido;
  final String gradoAsignado; // Grado asignado
  final String tipoMaestro;
  final String email;
  final String telefono;
  final String usuario;
  final String contrasena;
  final String rol;
  final List<String> materias; // Lista de IDs de materias

  Maestro({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.gradoAsignado,
    required this.tipoMaestro,
    required this.email,
    required this.telefono,
    required this.usuario,
    required this.contrasena,
    required this.rol, // Rol es requerido
    required this.materias,
  });

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nombre": nombre,
      "apellido": apellido,
      "gradoAsignado": gradoAsignado,
      "tipoMaestro": tipoMaestro,
      "email": email,
      "telefono": telefono,
      "usuario": usuario,
      "contrasena": contrasena,
      "rol": rol,
      "materias": materias,
    };
  }

  // Convertir desde Map
  factory Maestro.fromMap(Map<String, dynamic> data) {
    return Maestro(
      id: data["id"],
      nombre: data["nombre"],
      apellido: data["apellido"],
      gradoAsignado: data["gradoAsignado"],
      tipoMaestro: data["tipoMaestro"],
      email: data["email"],
      telefono: data["telefono"],
      usuario: data["usuario"],
      contrasena: data["contrasena"],
      rol: data["rol"],
      materias: List<String>.from(data["materias"]),
    );
  }
}
