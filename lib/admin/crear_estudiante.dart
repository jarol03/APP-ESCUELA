import 'package:avance1/controlador/FireBase_Controller.dart';
import 'package:avance1/modelo/Grado.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avance1/vista/pantalla_login.dart';
import 'package:avance1/modelo/Alumno.dart';

class CrearEstudianteScreen extends StatefulWidget {
  final Alumno? estudiante; // Parámetro opcional para edición

  const CrearEstudianteScreen({super.key, this.estudiante});

  @override
  _CrearEstudianteScreenState createState() => _CrearEstudianteScreenState();
}

class _CrearEstudianteScreenState extends State<CrearEstudianteScreen> {
  final FirebaseController baseDatos = FirebaseController();
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _notaController = TextEditingController();
  bool _active = true;
  Grado? _gradoSeleccionado;
  List<Grado> _grados = [];

  @override
  void initState() {
    super.initState();
    obtenerGrados();
    if (widget.estudiante != null) {
      _idController.text = widget.estudiante!.id;
      _nombreController.text = widget.estudiante!.nombre;
      _gradoSeleccionado = widget.estudiante!.grado;
      _emailController.text = widget.estudiante!.email;
      _telefonoController.text = widget.estudiante!.telefono;
      _usuarioController.text = widget.estudiante!.usuario;
      _contrasenaController.text = widget.estudiante!.contrasena;
      _notaController.text = widget.estudiante!.nota;
      _active = widget.estudiante!.active;
    }
  }

  Future<void> obtenerGrados() async {
    _grados = await baseDatos.obtenerGrados();

    if (widget.estudiante != null) {
      _gradoSeleccionado = _grados.firstWhere(
        (grado) => grado.id == widget.estudiante!.grado.id,
        orElse:
            () =>
                _grados.isNotEmpty
                    ? _grados.first
                    : Grado(id: '', nombre: 'Sin grado'),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.estudiante == null ? "Crear Estudiante" : "Editar Estudiante",
        ),
        backgroundColor: const Color.fromARGB(255, 100, 200, 236),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PantallaLogin()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("ID (DNI)", _idController, isNumber: true),
              const SizedBox(height: 16),
              _buildTextField("Nombre completo", _nombreController),
              const SizedBox(height: 16),
              _buildDropdown("Grado", _grados, _gradoSeleccionado, (value) {
                setState(() {
                  _gradoSeleccionado = value;
                });
              }),
              const SizedBox(height: 16),
              _buildTextField("Correo electrónico", _emailController),
              const SizedBox(height: 16),
              _buildTextField("Teléfono", _telefonoController, isNumber: true),
              const SizedBox(height: 16),
              _buildTextField("Usuario", _usuarioController),
              const SizedBox(height: 16),
              _buildTextField(
                "Contraseña",
                _contrasenaController,
                obscureText: false,
              ),
              const SizedBox(height: 16),
              _buildTextField("Nota", _notaController),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text("Activo"),
                value: _active,
                onChanged: (value) {
                  setState(() {
                    _active = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _submitForm,
          child: Text(widget.estudiante == null ? "Crear" : "Actualizar"),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Este campo es obligatorio";
        }
        if (isNumber && !RegExp(r'^[0-9]+$').hasMatch(value)) {
          return "Solo se permiten números";
        }
        return null;
      },
    );
  }

  Widget _buildDropdown(
    String label,
    List<Grado> items,
    Grado? value,
    Function(Grado?) onChanged,
  ) {
    return DropdownButtonFormField<Grado>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items:
          items.map((item) {
            return DropdownMenuItem<Grado>(
              value: item,
              child: Text(item.nombre),
            );
          }).toList(),
      onChanged: onChanged,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final estudiante = Alumno(
        id: _idController.text,
        nombre: _nombreController.text,
        grado: _gradoSeleccionado!,
        email: _emailController.text,
        telefono: _telefonoController.text,
        usuario: _usuarioController.text,
        contrasena: _contrasenaController.text,
        nota: _notaController.text,
        active: _active,
      );

      baseDatos.agregarAlumno(estudiante);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.estudiante == null
                ? "Estudiante creado exitosamente"
                : "Estudiante actualizado exitosamente",
          ),
          backgroundColor: Colors.green,
        ),
      );

      if (widget.estudiante != null) {
        Navigator.pop(context);
      } else {
        // Limpiar los campos solo si estamos creando un nuevo estudiante
        _idController.clear();
        _nombreController.clear();
        _emailController.clear();
        _telefonoController.clear();
        _usuarioController.clear();
        _contrasenaController.clear();
        _notaController.clear();
        setState(() {
          _gradoSeleccionado = null;
          _active = true;
        });
      }
    }
  }
}
