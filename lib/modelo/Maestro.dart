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
}
