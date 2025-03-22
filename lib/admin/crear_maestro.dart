import 'package:flutter/material.dart';
import 'package:avance1/controlador/FireBase_Controller.dart';
import 'package:avance1/modelo/Grado.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avance1/vista/pantalla_login.dart';
import 'package:avance1/modelo/Maestro.dart';

class CrearMaestroScreen extends StatefulWidget {
  final Maestro? maestro;

  const CrearMaestroScreen({super.key, this.maestro});

  @override
  _CrearMaestroScreenState createState() => _CrearMaestroScreenState();
}

class _CrearMaestroScreenState extends State<CrearMaestroScreen> {
  final FirebaseController baseDatos = FirebaseController();
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _contrasenaController = TextEditingController();
  List<Grado> _gradosSeleccionados = [];
  List<Grado> _grados = [];
  bool _mostrarContrasena = false;

  @override
  void initState() {
    super.initState();
    obtenerGrados();
    if (widget.maestro != null) {
      _idController.text = widget.maestro!.id;
      _nombreController.text = widget.maestro!.nombre;
      _gradosSeleccionados = widget.maestro!.gradosAsignados;
      _emailController.text = widget.maestro!.email;
      _telefonoController.text = widget.maestro!.telefono;
      _usuarioController.text = widget.maestro!.usuario;
      _contrasenaController.text = widget.maestro!.contrasena;
    }
  }

  Future<void> obtenerGrados() async {
    _grados = await baseDatos.obtenerGrados();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.maestro == null ? "Crear Maestro" : "Editar Maestro",
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildTextField(
                            "ID (DNI)",
                            _idController,
                            isNumber: true,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField("Nombre completo", _nombreController),
                          const SizedBox(height: 16),
                          _buildMultiSelectGrados(),
                          const SizedBox(height: 16),
                          _buildTextField(
                            "Correo electrónico",
                            _emailController,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            "Teléfono",
                            _telefonoController,
                            isNumber: true,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField("Usuario", _usuarioController),
                          const SizedBox(height: 16),
                          _buildTextFieldContrasena(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), // Espacio para el botón fijo
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(widget.maestro == null ? "Crear" : "Actualizar"),
            ),
          ),
        ],
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
        if (label.contains("Correo electrónico") &&
            !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return "Ingrese un correo electrónico válido";
        }
        return null;
      },
    );
  }

  Widget _buildMultiSelectGrados() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Grados", style: TextStyle(fontSize: 16)),
        DropdownButtonFormField<Grado>(
          value: null,
          decoration: InputDecoration(
            labelText: "Seleccione un grado",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items:
              _grados.map((grado) {
                return DropdownMenuItem<Grado>(
                  value: grado,
                  child: Row(
                    children: [
                      Text(grado.nombre),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            if (!_gradosSeleccionados.contains(grado)) {
                              _gradosSeleccionados.add(grado);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
          onChanged: (value) {
            // No se necesita acción aquí, ya que la selección se maneja con el IconButton
          },
        ),
        Wrap(
          spacing: 8.0,
          children:
              _gradosSeleccionados.map((grado) {
                return Chip(
                  label: Text(grado.nombre),
                  onDeleted: () {
                    setState(() {
                      _gradosSeleccionados.remove(grado);
                    });
                  },
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildTextFieldContrasena() {
    return TextFormField(
      controller: _contrasenaController,
      obscureText: !_mostrarContrasena,
      decoration: InputDecoration(
        labelText: "Contraseña",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(
            _mostrarContrasena ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _mostrarContrasena = !_mostrarContrasena;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final maestro = Maestro(
        id: _idController.text,
        nombre: _nombreController.text,
        gradosAsignados: _gradosSeleccionados,
        tipoMaestro: "Maestro general",
        email: _emailController.text,
        telefono: _telefonoController.text,
        usuario: _usuarioController.text,
        contrasena: _contrasenaController.text,
        materias: [],
        fotoPath: widget.maestro!.fotoPath,
      );

      baseDatos.agregarMaestro(maestro);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.maestro == null
                ? "Maestro creado exitosamente"
                : "Maestro actualizado exitosamente",
          ),
          backgroundColor: Colors.green,
        ),
      );

      if (widget.maestro != null) {
        Navigator.pop(context);
      } else {
        _idController.clear();
        _nombreController.clear();
        _emailController.clear();
        _telefonoController.clear();
        _usuarioController.clear();
        _contrasenaController.clear();
        setState(() {
          _gradosSeleccionados.clear();
        });
      }
    }
  }
}
