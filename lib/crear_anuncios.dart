import 'package:flutter/material.dart';
import 'package:avance1/modelo/Anuncio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrearAnuncioScreen extends StatefulWidget {
  final Anuncio? anuncio;

  const CrearAnuncioScreen({super.key, this.anuncio});

  @override
  _CrearAnuncioScreenState createState() => _CrearAnuncioScreenState();
}

class _CrearAnuncioScreenState extends State<CrearAnuncioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _contenidoController = TextEditingController();
  bool _enviarNotificacion = false;
  String? _rolUsuario;

  @override
  void initState() {
    super.initState();
    _verificarRol();
    if (widget.anuncio != null) {
      _tituloController.text = widget.anuncio!.titulo;
      _contenidoController.text = widget.anuncio!.contenido;
    }
  }

  void _verificarRol() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _rolUsuario = prefs.getString('rolUsuario') ?? 'estudiante';
    if (_rolUsuario == "estudiante") {
      Navigator.pop(context); // Cierra la pantalla si es estudiante
    }
  }

  void _guardarAnuncio() {
    if (_formKey.currentState!.validate()) {
      final anuncio = Anuncio(
        id: widget.anuncio?.id ?? DateTime.now().toString(),
        titulo: _tituloController.text,
        contenido: _contenidoController.text,
        autor: "Admin", // Aquí puedes obtener el nombre del usuario logueado
        fecha: DateTime.now(),
      );

      Navigator.pop(context, anuncio);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.anuncio == null ? "Crear Anuncio" : "Editar Anuncio",
        ),
        backgroundColor: const Color.fromARGB(255, 100, 200, 236),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: "Título"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El título es obligatorio";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contenidoController,
                decoration: const InputDecoration(labelText: "Contenido"),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "El contenido es obligatorio";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text("Enviar notificación push"),
                value: _enviarNotificacion,
                onChanged: (value) {
                  setState(() {
                    _enviarNotificacion = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _guardarAnuncio,
                child: const Text("Guardar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
