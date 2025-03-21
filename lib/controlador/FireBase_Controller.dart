import 'package:avance1/modelo/Anuncio.dart';
import 'package:avance1/modelo/Grado.dart';
import 'package:avance1/modelo/Materia.dart'; // Descomenta esta línea
import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelo/Alumno.dart';
import '../modelo/Maestro.dart';

class FirebaseController {
  final FirebaseFirestore base = FirebaseFirestore.instance;

  Future<void> limpiarCache() async {
    await base.clearPersistence();
    print("Caché de Firestore limpiada.");
  }

  Future<void> verificarConexion() async {
    try {
      // Intentar obtener un documento cualquiera de la colección "alumnos"
      QuerySnapshot querySnapshot =
          await base.collection('alumnos').limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        print(
          "✅ Conexión a Firestore exitosa. Documento encontrado: ${querySnapshot.docs.first.data()}",
        );
      } else {
        print(
          "⚠️ Conexión establecida, pero no hay alumnos en la base de datos.",
        );
      }
    } catch (e) {
      print("❌ No se pudo conectar a Firestore: $e");
    }
  }

  Future<void> agregarAlumno(Alumno alumno) async {
    await base.collection('alumnos').doc(alumno.id).set(alumno.toMap());
  }

  Future<void> agregarMaestro(Maestro maestro) async {
    await base.collection('maestros').doc(maestro.id).set(maestro.toMap());
  }

  // Método para buscar un Alumno por id
  Future<Alumno?> buscarAlumnoPorId(String id) async {
    try {
      DocumentSnapshot docSnapshot =
          await base.collection('alumnos').doc(id).get();

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
      DocumentSnapshot docSnapshot =
          await base.collection('maestros').doc(id).get();

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
    QuerySnapshot querySnapshot =
        await base
            .collection('alumnos')
            .where('usuario', isEqualTo: usuario)
            .where('contrasena', isEqualTo: contrasena)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      var alumnoDoc = querySnapshot.docs.first;
      Alumno alumno = Alumno.fromMap(alumnoDoc.data() as Map<String, dynamic>);
      return alumno;
    }

    return null;
  }

  Future<Maestro?> buscarMaestro(String usuario, String contrasena) async {
    QuerySnapshot querySnapshot =
        await base
            .collection('maestros')
            .where('usuario', isEqualTo: usuario)
            .where('contrasena', isEqualTo: contrasena)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      var maestroDoc = querySnapshot.docs.first;
      Maestro maestro = Maestro.fromMap(
        maestroDoc.data() as Map<String, dynamic>,
      );
      return maestro;
    }

    return null;
  }

  Future<List<Alumno>> obtenerAlumnos() async {
    try {
      QuerySnapshot querySnapshot = await base.collection('alumnos').get();
      List<Alumno> alumnos =
          querySnapshot.docs.map((doc) {
            return Alumno.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
      return alumnos;
    } catch (e) {
      print("Error al obtener alumnos: $e");
      return [];
    }
  }

  Stream<List<Alumno>> obtenerAlumnosStream() {
    try {
      return base.collection('alumnos').snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return Alumno.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      print("Error al obtener alumnos: $e");
      return Stream.value([]);
    }
  }

  Future<List<Maestro>> obtenerMaestros() async {
    try {
      QuerySnapshot querySnapshot = await base.collection('maestros').get();
      List<Maestro> maestros =
          querySnapshot.docs.map((doc) {
            return Maestro.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
      return maestros;
    } catch (e) {
      print("Error al obtener maestros: $e");
      return [];
    }
  }

  Stream<List<Maestro>> obtenerMaestrosStream() {
    try {
      return base.collection('maestros').snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return Maestro.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      print("Error al obtener maestros: $e");
      return Stream.value([]);
    }
  }

  // Método en FirebaseController para actualizar maestro
  Future<void> actualizarMaestro(Maestro maestro) async {
    await base.collection('maestros').doc(maestro.id).update({
      'materias': maestro.materias.map((materia) => materia.toMap()).toList(),
    });
  }

  Future<void> eliminarAlumno(String id) async {
    await base.collection("alumnos").doc(id).delete();
  }

  Future<void> eliminarMaestro(String id) async {
    await base.collection("maestros").doc(id).delete();
  }

  /// ===================================
  /// LOGICA PARA LOS GRADOS
  /// ===================================
  Future<void> agregarGrado(Grado grado) async {
    await base.collection('grados').doc(grado.id).set(grado.toMap());
  }

  Future<void> eliminarGrado(String id) async {
    await base.collection("grados").doc(id).delete();
  }

  Future<List<Grado>> obtenerGrados() async {
    try {
      QuerySnapshot querySnapshot = await base.collection('grados').get();
      List<Grado> grados =
          querySnapshot.docs.map((doc) {
            return Grado.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
      return grados;
    } catch (e) {
      print("Error al obtener grados: $e");
      return [];
    }
  }

  Future<void> actualizarGrado(Grado grado) async {
    await base.collection('grados').doc(grado.id).update({
      'materias': grado.materias.map((materia) => materia.toMap()).toList(),
      'maestros': grado.maestros.map((maestro) => maestro.toMap()).toList(),
      'jornada': grado.jornada,
    });

    // Actualizar el grado en los alumnos asociados
    QuerySnapshot querySnapshot =
        await base
            .collection('alumnos')
            .where('grado.id', isEqualTo: grado.id)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        Alumno alumno = Alumno.fromMap(doc.data() as Map<String, dynamic>);
        print('Alumno: ${alumno.nombre}');

        await base.collection('alumnos').doc(doc.id).update({
          'grado': grado.toMap(),
        });

        print('Grado del alumno ${alumno.nombre} actualizado');
      }
    } else {
      print('No se encontraron alumnos para el grado con ID: ${grado.id}');
    }
  }

  /// ===================================
  /// LOGICA PARA LOS ANUNCIOS
  /// ===================================
  Future<void> agregarAnuncio(Anuncio anuncio) async {
    await base.collection('anuncios').doc(anuncio.id).set(anuncio.toMap());
  }

  Future<void> eliminarAnuncio(String id) async {
    await base.collection("anuncios").doc(id).delete();
  }

  Future<List<Anuncio>> obtenerAnuncios() async {
  try {
    QuerySnapshot querySnapshot = await base
        .collection('anuncios')
        .orderBy('fecha', descending: true)
        .get();

    List<Anuncio> anuncios = querySnapshot.docs.map((doc) {
      return Anuncio.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();

    return anuncios;
  } catch (e) {
    print("Error al obtener anuncios: $e");
    return [];
  }
}


  /// ===================================
  /// LOGICA PARA LAS MATERIAS
  /// ===================================
  Future<void> agregarMateria(Materia materia) async {
    await base.collection('materias').doc(materia.id).set(materia.toMap());
  }

  Future<List<Materia>> obtenerMaterias() async {
    try {
      QuerySnapshot querySnapshot = await base.collection('materias').get();
      List<Materia> materias =
          querySnapshot.docs.map((doc) {
            return Materia.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
      return materias;
    } catch (e) {
      print("Error al obtener materias: $e");
      return [];
    }
  }
}
