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
}
