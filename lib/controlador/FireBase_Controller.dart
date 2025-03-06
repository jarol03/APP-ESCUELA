import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelo/Alumno.dart';
import '../modelo/Maestro.dart';

class FirebaseController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 📌 REGISTRAR UN ALUMNO
  Future<void> registrarAlumno(Alumno alumno) async {
    try {
      await _db.collection('alumnos').doc(alumno.id).set(alumno.toMap());
    } catch (e) {
      print("Error al registrar alumno: $e");
    }
  }

  // 📌 REGISTRAR UN MAESTRO
  Future<void> registrarMaestro(Maestro maestro) async {
    try {
      await _db.collection('maestros').doc(maestro.id).set(maestro.toMap());
    } catch (e) {
      print("Error al registrar maestro: $e");
    }
  }

  // 📌 INICIAR SESIÓN (VERIFICA EN FIRESTORE)
  Future<String?> iniciarSesion(String usuario, String contrasena) async {
    try {
      // Buscar en alumnos
      QuerySnapshot alumnos = await _db
          .collection("alumnos")
          .where("usuario", isEqualTo: usuario)
          .where("contrasena", isEqualTo: contrasena)
          .get();

      if (alumnos.docs.isNotEmpty) {
        return "Alumno";
      }

      // Buscar en maestros
      QuerySnapshot maestros = await _db
          .collection("maestros")
          .where("usuario", isEqualTo: usuario)
          .where("contrasena", isEqualTo: contrasena)
          .get();

      if (maestros.docs.isNotEmpty) {
        return "Maestro";
      }

      return null; // Usuario no encontrado
    } catch (e) {
      print("Error al iniciar sesión: $e");
      return null;
    }
  }
}
