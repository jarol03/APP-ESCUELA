class Grado {
  final String id; // Identificador único
  final String nombre;
  final List<String> alumnos; // Lista de IDs de alumnos
  final List<String> materias; // Lista de IDs de materias

  Grado({
    required this.id,
    required this.nombre,
    this.alumnos = const [],
    this.materias = const [],
  });
}
