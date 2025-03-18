import 'package:avance1/controlador/FireBase_Controller.dart';
import 'package:avance1/modelo/Grado.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avance1/vista/pantalla_login.dart';
import 'package:avance1/modelo/Maestro.dart';

class CrearMaestroScreen extends StatefulWidget {
  final Maestro? maestro; // Parámetro opcional para edición

  const CrearMaestroScreen({super.key, this.maestro});

  @override
  _CrearMaestroScreenState createState() => _CrearMaestroScreenState();
}

class _CrearMaestroScreenState extends State<CrearMaestroScreen> {
  FirebaseController baseDatos = FirebaseController();
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _contrasenaController = TextEditingController();
  List<Grado> _gradosSeleccionados = []; // Lista de grados seleccionados
  bool _isMaestroGuia = false;
  List<Grado> _grados = [];

  @override
  void initState() {
    super.initState();
    obtenerGrados();
    if (widget.maestro != null) {
      _idController.text = widget.maestro!.id;
      _nombreController.text = widget.maestro!.nombre;
      _gradosSeleccionados = widget.maestro!.gradosAsignados;
      _isMaestroGuia = widget.maestro!.tipoMaestro == "Maestro guía";
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
              _buildMultipleSelectionDropdown(
                "Grados",
                _grados,
                _gradosSeleccionados,
              ),
              const SizedBox(height: 16),
              _buildCheckbox("¿Es maestro guía?", _isMaestroGuia, (value) {
                setState(() {
                  _isMaestroGuia = value!;
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
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.maestro == null ? "Crear" : "Actualizar"),
              ),
            ],
          ),
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

  Widget _buildMultipleSelectionDropdown(
    String label,
    List<Grado> items,
    List<Grado> selectedItems,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Wrap(
          children:
              items.map((Grado grado) {
                return FilterChip(
                  label: Text(grado.nombre),
                  selected: selectedItems.contains(grado),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedItems.add(grado);
                      } else {
                        selectedItems.remove(grado);
                      }
                    });
                  },
                );
              }).toList(),
        ),
      ],
    );
  }

  // Método para agregar el checkbox
  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return Row(
      children: [Checkbox(value: value, onChanged: onChanged), Text(label)],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Crear o actualizar el maestro
      final maestro = Maestro(
        id: _idController.text,
        nombre: _nombreController.text,
        gradosAsignados: _gradosSeleccionados,
        tipoMaestro: _isMaestroGuia ? "Maestro guía" : "Maestro general",
        email: _emailController.text,
        telefono: _telefonoController.text,
        usuario: _usuarioController.text,
        contrasena: _contrasenaController.text,
        materias: [],
      );

      baseDatos.agregarMaestro(maestro);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.maestro == null
                ? "Estudiante creado exitosamente"
                : "Estudiante actualizado exitosamente",
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
      }

      print(
        "Maestro ${widget.maestro == null ? 'creado' : 'actualizado'}: ${maestro.nombre}",
      );
    }
  }
}
