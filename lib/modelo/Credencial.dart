class Credencial {
  final String usuario;
  final String contrasena;
  final String rol; // "maestro" o "alumno"
  final String identificador; // DNI o ID único

  Credencial({
    required this.usuario,
    required this.contrasena,
    required this.rol,
    required this.identificador,
  });
}
