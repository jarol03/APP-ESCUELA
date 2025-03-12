import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelo/Alumno.dart';
import '../modelo/Maestro.dart';

class FirebaseController {
  final FirebaseFirestore base = FirebaseFirestore.instance;

  Future<void> agregarAlumno(Alumno alumno) async {
    await base.collection('alumnos').doc(alumno.id).set(alumno.toMap());
  }

  Future<void> agregarMaestro(Maestro maestro) async {
    await base.collection('maestros').doc(maestro.id).set(maestro.toMap());
  }

  // Método para buscar un Alumno por id
  Future<Alumno?> buscarAlumnoPorId(String id) async {
    try {
      DocumentSnapshot docSnapshot = await base.collection('alumnos').doc(id).get();

      // Si el documento existe
      if (docSnapshot.exists) {
        return Alumno.fromMap(docSnapshot.data() as Map<String, dynamic>);
      } else {
        return null; // Si no existe, retorna null
      }
    } catch (e) {
      print("Error al buscar el alumno por ID: $e");
      return null;
    }
  }

  Future<Maestro?> buscarMaestroPorId(String id) async {
    try {
      DocumentSnapshot docSnapshot = await base.collection('maestros').doc(id).get();

      // Si el documento existe
      if (docSnapshot.exists) {
        return Maestro.fromMap(docSnapshot.data() as Map<String, dynamic>);
      } else {
        return null; // Si no existe, retorna null
      }
    } catch (e) {
      print("Error al buscar el maestro por ID: $e");
      return null;
    }
  }


  Future<Alumno?> buscarAlumno(String usuario, String contrasena) async {
    //BUSCAMOS EN LA "TABLA" alumnos Y POR UNA "CONSULTA" COMO EN SQL BUSCANDO EN LOS VALORES USUARIO Y CONTRASEÑA
    //SI LO ENCUENTRA LO OBTIENE Y SE ASIGNA A querySnapshot
    QuerySnapshot querySnapshot = await base.collection('alumnos')
      .where('usuario', isEqualTo: usuario) // Filtramos por el usuario
      .where('contrasena', isEqualTo: contrasena) // Filtramos por la contraseña
      .get();

      //SI NO ESTÁ VACÍO O SEA QUE SI ENCONTRÓ ALGO, GUARDAMOS LA "TABLA" EN ESTE CASO DOCUMENTO PARA FIRESTORE
      //Y OBTENEMOS EL PRIMER RESULTADO, CREAMOS UN ALUMNO MEDIANTE UN CONSTRUCTOR ESPECIAL
      //QUE RECIBE UN Map<String, dynamic> PORQUE CONVERTIMOS LA DATA DEL DOCUMENTO A UN Map<String, dynamic>
      //Y RETORNAMOS ESE ALUMNO, SI NO RETORNARÁ NULL
      if (querySnapshot.docs.isNotEmpty) {
        var alumnoDoc = querySnapshot.docs.first;
        Alumno alumno = Alumno.fromMap(alumnoDoc.data() as Map<String, dynamic>);
        return alumno;
      }

      return null;
    }

    Future<Maestro?> buscarMaestro(String usuario, String contrasena) async {
    QuerySnapshot querySnapshot = await base.collection('maestros')
      .where('usuario', isEqualTo: usuario)
      .where('contrasena', isEqualTo: contrasena)
      .get();

      if (querySnapshot.docs.isNotEmpty) {
        var maestroDoc = querySnapshot.docs.first;
        Maestro maestro = Maestro.fromMap(maestroDoc.data() as Map<String, dynamic>);
        return maestro;
      }

      return null;
    }

  Future<List<Alumno>> obtenerAlumnos() async {
    try {
      QuerySnapshot querySnapshot = await base.collection('alumnos').get();
      List<Alumno> alumnos = querySnapshot.docs.map((doc) {
        return Alumno.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    return alumnos;
    } catch (e) {
      print("Error al obtener alumnos: $e");
      return [];
    }
  }

  Future<List<Maestro>> obtenerMaestros() async {
    try {
      QuerySnapshot querySnapshot = await base.collection('maestros').get();
      List<Maestro> maestros = querySnapshot.docs.map((doc) {
        return Maestro.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      return maestros;
    } catch (e) {
      print("Error al obtener maestros: $e");
      return [];
    }
  }

  Future<void> eliminarAlumno(String id) async {
    await base.collection("alumnos").doc(id).delete();
  }

  Future<void> eliminarMaestro(String id) async {
    await base.collection("maestros").doc(id).delete();
  }
}
