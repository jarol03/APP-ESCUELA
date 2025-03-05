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
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController(); // Campo para el ID
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _rolController = TextEditingController(); // Controlador para el rol
  String? _gradoSeleccionado;
  String? _tipoMaestroSeleccionado;
  final List<String> _grados = ["Grado 1", "Grado 2", "Grado 3", "Grado 4"];
  final List<String> _tiposMaestro = ["Maestro guía", "Maestro general"];

  @override
  void initState() {
    super.initState();
    if (widget.maestro != null) {
      _idController.text = widget.maestro!.id; // Asignar el ID si existe
      _nombreController.text = widget.maestro!.nombre;
      _apellidoController.text = widget.maestro!.apellido;
      _gradoSeleccionado = widget.maestro!.gradoAsignado;
      _tipoMaestroSeleccionado = widget.maestro!.tipoMaestro;
      _emailController.text = widget.maestro!.email;
      _telefonoController.text = widget.maestro!.telefono;
      _usuarioController.text = widget.maestro!.usuario;
      _contrasenaController.text = widget.maestro!.contrasena;
      _rolController.text = widget.maestro!.rol; // Asignar el rol si existe
    }
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
              _buildTextField(
                "ID (DNI)",
                _idController,
                isNumber: true,
              ), // Campo numérico
              const SizedBox(height: 16),
              _buildTextField("Nombre completo", _nombreController),
              const SizedBox(height: 16),
              _buildTextField("Apellido", _apellidoController),
              const SizedBox(height: 16),
              _buildDropdown("Grado", _grados, _gradoSeleccionado, (value) {
                setState(() {
                  _gradoSeleccionado = value;
                });
              }),
              const SizedBox(height: 16),
              _buildDropdown(
                "Tipo de maestro",
                _tiposMaestro,
                _tipoMaestroSeleccionado,
                (value) {
                  setState(() {
                    _tipoMaestroSeleccionado = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildTextField("Correo electrónico", _emailController),
              const SizedBox(height: 16),
              _buildTextField(
                "Teléfono",
                _telefonoController,
                isNumber: true,
              ), // Campo numérico
              const SizedBox(height: 16),
              _buildTextField("Usuario", _usuarioController),
              const SizedBox(height: 16),
              _buildTextField(
                "Contraseña",
                _contrasenaController,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              _buildTextField("Rol", _rolController), // Campo para el rol
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.maestro == null ? "Crear" : "Actualizar"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Anuncios',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        currentIndex: 0,
        selectedItemColor: const Color.fromARGB(255, 100, 200, 236),
        onTap: (index) {
          // Navegar a la pantalla correspondiente
        },
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
      keyboardType:
          isNumber
              ? TextInputType.number
              : TextInputType.text, // Teclado numérico o texto
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
    List<String> items,
    String? value,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items:
          items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
      onChanged: onChanged,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Crear o actualizar el maestro
      final maestro = Maestro(
        id: _idController.text, // Asignar el ID
        nombre: _nombreController.text,
        apellido: _apellidoController.text,
        gradoAsignado: _gradoSeleccionado!,
        tipoMaestro: _tipoMaestroSeleccionado!,
        email: _emailController.text,
        telefono: _telefonoController.text,
        usuario: _usuarioController.text,
        contrasena: _contrasenaController.text,
        rol: _rolController.text, // Asignar el rol
        materias: [], // Aquí puedes agregar las materias asignadas
      );

      // Lógica para guardar o actualizar el maestro
      print(
        "Maestro ${widget.maestro == null ? 'creado' : 'actualizado'}: ${maestro.nombre}",
      );
    }
  }
}
