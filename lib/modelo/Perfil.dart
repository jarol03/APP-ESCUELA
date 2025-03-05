class Perfil {
  final String nombre;
  final String apellido;
  final String email;
  final String telefono;
  final String rol; // "maestro" o "alumno"

  Perfil({
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.telefono,
    required this.rol,
  });
}
