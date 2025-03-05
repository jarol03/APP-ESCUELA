import 'package:flutter/material.dart';
import 'package:avance1/crear_anuncios.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:avance1/modelo/Anuncio.dart';

class AnunciosScreen extends StatefulWidget {
  const AnunciosScreen({super.key});

  @override
  _AnunciosScreenState createState() => _AnunciosScreenState();
}

class _AnunciosScreenState extends State<AnunciosScreen> {
  final List<Anuncio> _anuncios = [
    Anuncio(
      id: "1",
      titulo: "Bienvenida al nuevo ciclo escolar",
      contenido: "Les damos la bienvenida al ciclo escolar 2023-2024.",
      autor: "Admin",
      fecha: DateTime.now(),
    ),
    Anuncio(
      id: "2",
      titulo: "Reunión de padres",
      contenido: "La reunión de padres se llevará a cabo el próximo lunes.",
      autor: "Maestro Juan",
      fecha: DateTime.now(),
    ),
  ];

  String? _rolUsuario;

  @override
  void initState() {
    super.initState();
    _obtenerRolUsuario();
  }

  void _obtenerRolUsuario() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rolUsuario = prefs.getString('rolUsuario') ?? 'estudiante';
    });
  }

  void _crearAnuncio() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CrearAnuncioScreen()),
    );

    if (result != null && result is Anuncio) {
      setState(() {
        _anuncios.add(result);
      });
    }
  }

  void _editarAnuncio(Anuncio anuncio) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrearAnuncioScreen(anuncio: anuncio),
      ),
    );

    if (result != null && result is Anuncio) {
      setState(() {
        final index = _anuncios.indexWhere((a) => a.id == result.id);
        if (index != -1) {
          _anuncios[index] = result;
        }
      });
    }
  }

  void _eliminarAnuncio(String id) {
    setState(() {
      _anuncios.removeWhere((a) => a.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anuncios"),
        backgroundColor: const Color.fromARGB(255, 100, 200, 236),
        actions: [
          if (_rolUsuario == "admin" || _rolUsuario == "maestro")
            IconButton(icon: const Icon(Icons.add), onPressed: _crearAnuncio),
        ],
      ),
      body: ListView.builder(
        itemCount: _anuncios.length,
        itemBuilder: (context, index) {
          final anuncio = _anuncios[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(anuncio.titulo),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(anuncio.contenido),
                  const SizedBox(height: 8),
                  Text(
                    "Publicado por: ${anuncio.autor} - ${anuncio.fecha.toString()}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              trailing:
                  (_rolUsuario == "admin" || _rolUsuario == "maestro")
                      ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editarAnuncio(anuncio),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _eliminarAnuncio(anuncio.id),
                          ),
                        ],
                      )
                      : null,
            ),
          );
        },
      ),
    );
  }
}
