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
  final _idController = TextEditingController(); // Campo para el ID
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _contrasenaController = TextEditingController();
  Grado? _gradoSeleccionado;
  bool _isMaestroGuia = false; // Valor para el checkbox
  final List<Grado> _grados = [
    Grado(id: "01", nombre: "1A"),
    Grado(id: "02", nombre: "2A"),
    Grado(id: "03", nombre: "3A"),
    Grado(id: "04", nombre: "4A"),
    Grado(id: "05", nombre: "5A"),
    Grado(id: "06", nombre: "6A"),
    Grado(id: "07", nombre: "7A"),
    Grado(id: "08", nombre: "8A"),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.maestro != null) {
      _idController.text = widget.maestro!.id; // Asignar el ID si existe
      _nombreController.text = widget.maestro!.nombre;
      _apellidoController.text = widget.maestro!.apellido;
      _gradoSeleccionado =
          widget.maestro!.gradosAsignados.isNotEmpty
              ? widget.maestro!.gradosAsignados[0]
              : null;
      _isMaestroGuia =
          widget.maestro!.tipoMaestro ==
          "Maestro guía"; // Asignar si es maestro guía
      _emailController.text = widget.maestro!.email;
      _telefonoController.text = widget.maestro!.telefono;
      _usuarioController.text = widget.maestro!.usuario;
      _contrasenaController.text = widget.maestro!.contrasena;
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
              _buildTextField("ID (DNI)", _idController, isNumber: true),
              const SizedBox(height: 16),
              _buildTextField("Nombre completo", _nombreController),
              const SizedBox(height: 16),
              _buildTextField("Apellido", _apellidoController),
              const SizedBox(height: 16),
              _buildDropdown("Grado", _grados, _gradoSeleccionado?.nombre, (
                value,
              ) {
                setState(() {
                  _gradoSeleccionado = value;
                });
              }),
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
                obscureText: true,
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
    String? value,
    Function(Grado?) onChanged,
  ) {
    return DropdownButtonFormField<Grado>(
      value: _gradoSeleccionado,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items:
          items.map((Grado grado) {
            return DropdownMenuItem<Grado>(
              value: grado,
              child: Text(grado.nombre),
            );
          }).toList(),
      onChanged: (Grado? newValue) {
        onChanged(newValue);
      },
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
        apellido: _apellidoController.text,
        gradosAsignados:
            _gradoSeleccionado != null ? [_gradoSeleccionado!] : [],
        tipoMaestro: _isMaestroGuia ? "Maestro guía" : "Maestro general",
        email: _emailController.text,
        telefono: _telefonoController.text,
        usuario: _usuarioController.text,
        contrasena: _contrasenaController.text,
        materias: [],
      );
      
      baseDatos.agregarMaestro(maestro);

      _idController.clear();
      _nombreController.clear();
      _apellidoController.clear();
      _emailController.clear();
      _telefonoController.clear();
      _usuarioController.clear();
      _contrasenaController.clear();

      // Lógica para guardar o actualizar el maestro
      print(
        "Maestro ${widget.maestro == null ? 'creado' : 'actualizado'}: ${maestro.nombre}",
      );
    }
  }
}
