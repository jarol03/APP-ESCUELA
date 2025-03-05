class Anuncio {
  final String id; // Identificador único
  final String titulo;
  final String contenido;
  final String autor; // Nombre del maestro o admin
  final DateTime fecha;

  Anuncio({
    required this.id,
    required this.titulo,
    required this.contenido,
    required this.autor,
    required this.fecha,
  });
}
