import 'package:avance1/modelo/Anuncio.dart';
import 'package:avance1/modelo/Grado.dart';
import 'package:avance1/modelo/Materia.dart';
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
    //BUSCAMOS EN LA "TABLA" alumnos Y POR UNA "CONSULTA" COMO EN SQL BUSCANDO EN LOS VALORES USUARIO Y CONTRASEÑA
    //SI LO ENCUENTRA LO OBTIENE Y SE ASIGNA A querySnapshot
    QuerySnapshot querySnapshot =
        await base
            .collection('alumnos')
            .where('usuario', isEqualTo: usuario) // Filtramos por el usuario
            .where(
              'contrasena',
              isEqualTo: contrasena,
            ) // Filtramos por la contraseña
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

  // Método en FirebaseController para actualizar maestro
  Future<void> actualizarMaestro(Maestro maestro) async {
    // Actualizar solo el campo de las materias
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

  /**
   * ===================================
   * LOGICA PARA LOS GRADOS
   * ===================================
   */
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
    // 1. Actualizar solo el campo de las materias en el grado
    await base.collection('grados').doc(grado.id).update({
      'materias': grado.materias.map((materia) => materia.toMap()).toList(),
    });

    // 2. Buscar a los alumnos cuyo campo "grado" tenga el mismo ID que el parámetro
    QuerySnapshot querySnapshot =
        await base
            .collection('alumnos')
            .where(
              'grado.id',
              isEqualTo: grado.id,
            ) // Aquí, se busca por el ID del grado dentro del objeto "grado"
            .get();

    // 3. Imprimir los nombres de los alumnos encontrados y actualizar su grado
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        // Obtener el alumno
        Alumno alumno = Alumno.fromMap(doc.data() as Map<String, dynamic>);

        // Imprimir el nombre del alumno
        print('Alumno: ${alumno.nombre}');

        // Actualizar el campo "grado" en el alumno con el nuevo grado y las materias actualizadas
        await base.collection('alumnos').doc(doc.id).update({
          'grado':
              grado
                  .toMap(), // Actualizamos el grado con el nuevo objeto (incluyendo las materias)
        });

        print('Grado del alumno ${alumno.nombre} actualizado');
      }
    } else {
      print('No se encontraron alumnos para el grado con ID: ${grado.id}');
    }
  }

  /**
   * ===================================
   * LOGICA PARA LOS ANUNCIOS
   * ===================================
   */
  Future<void> agregarAnuncio(Anuncio anuncio) async {
    await base.collection('anuncios').doc(anuncio.id).set(anuncio.toMap());
  }

  Future<List<Anuncio>> obtenerAnuncios() async {
    try {
      QuerySnapshot querySnapshot = await base.collection('anuncios').get();
      List<Anuncio> anuncios =
          querySnapshot.docs.map((doc) {
            return Anuncio.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
      return anuncios;
    } catch (e) {
      print("Error al obtener anuncios: $e");
      return [];
    }
  }
}
