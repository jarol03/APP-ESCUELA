class Materia {
  final String id;
  final String nombre;
  final String descripcion;

  Materia({required this.id, required this.nombre, required this.descripcion});

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nombre": nombre,
      "descripcion": descripcion,
    };
  }

  // Convertir desde Map
  factory Materia.fromMap(Map<String, dynamic> data) {
    return Materia(
      id: data["id"],
      nombre: data["nombre"],
      descripcion: data["descripcion"],
    );
  }
}
