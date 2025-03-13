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

  // Convertir el objeto a un mapa (para guardar en Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'contenido': contenido,
      'autor': autor,
      'fecha': fecha.toIso8601String(), // Se almacena como String en formato ISO8601
    };
  }

  // Crear un objeto Anuncio a partir de un mapa (para leer desde Firestore)
  factory Anuncio.fromMap(Map<String, dynamic> map) {
    return Anuncio(
      id: map['id'] ?? '',
      titulo: map['titulo'] ?? '',
      contenido: map['contenido'] ?? '',
      autor: map['autor'] ?? '',
      fecha: DateTime.parse(map['fecha'] ?? DateTime.now().toIso8601String()), // Convertir String a DateTime
    );
  }
}
