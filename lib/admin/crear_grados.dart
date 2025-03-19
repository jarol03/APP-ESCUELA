import 'package:flutter/material.dart';
import 'package:avance1/controlador/FireBase_Controller.dart';
import 'package:avance1/modelo/Grado.dart';
import 'package:avance1/modelo/Materia.dart';
import 'package:avance1/modelo/Maestro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avance1/vista/pantalla_login.dart';

class CrearGradoScreen extends StatefulWidget {
  final Grado? grado;

  const CrearGradoScreen({super.key, this.grado});

  @override
  _CrearGradoScreenState createState() => _CrearGradoScreenState();
}

class _CrearGradoScreenState extends State<CrearGradoScreen> {
  final FirebaseController baseDatos = FirebaseController();
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nombreController = TextEditingController();
  List<Materia> _materiasSeleccionadas = [];
  List<Maestro> _maestrosSeleccionados = [];
  List<Materia> _materias = [];
  List<Maestro> _maestros = [];
  String _jornada = 'Matutina';

  @override
  void initState() {
    super.initState();
    obtenerMaterias();
    obtenerMaestros();
    if (widget.grado != null) {
      _idController.text = widget.grado!.id;
      _nombreController.text = widget.grado!.nombre;
      _materiasSeleccionadas = widget.grado!.materias;
      _maestrosSeleccionados = widget.grado!.maestros;
      _jornada = widget.grado!.jornada ?? 'Matutina';
    }
  }

  Future<void> obtenerMaterias() async {
    _materias = await baseDatos.obtenerMaterias();
    setState(() {});
  }

  Future<void> obtenerMaestros() async {
    _maestros = await baseDatos.obtenerMaestros();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.grado == null ? "Crear Grado" : "Editar Grado"),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("ID", _idController),
              const SizedBox(height: 16),
              _buildTextField("Nombre del grado", _nombreController),
              const SizedBox(height: 16),
              _buildDropdownJornada(),
              const SizedBox(height: 16),
              _buildMultiSelectMaterias(),
              const SizedBox(height: 16),
              _buildMultiSelectMaestros(),
              const SizedBox(height: 32), // Espacio adicional antes del botón
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.grado == null ? "Crear" : "Actualizar"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
    );
  }

  Widget _buildDropdownJornada() {
    return DropdownButtonFormField<String>(
      value: _jornada,
      decoration: InputDecoration(
        labelText: "Jornada",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items:
          ['Matutina', 'Vespertina'].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
      onChanged: (value) {
        setState(() {
          _jornada = value!;
        });
      },
    );
  }

  Widget _buildMultiSelectMaterias() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Materias", style: TextStyle(fontSize: 16)),
        DropdownButtonFormField<Materia>(
          value: null,
          decoration: InputDecoration(
            labelText: "Seleccione una materia",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items:
              _materias.map((materia) {
                return DropdownMenuItem<Materia>(
                  value: materia,
                  child: Row(
                    children: [
                      Text(materia.nombre),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            if (!_materiasSeleccionadas.contains(materia)) {
                              _materiasSeleccionadas.add(materia);
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
              _materiasSeleccionadas.map((materia) {
                return Chip(
                  label: Text(materia.nombre),
                  onDeleted: () {
                    setState(() {
                      _materiasSeleccionadas.remove(materia);
                    });
                  },
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildMultiSelectMaestros() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Maestros", style: TextStyle(fontSize: 16)),
        DropdownButtonFormField<Maestro>(
          value: null,
          decoration: InputDecoration(
            labelText: "Seleccione un maestro",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items:
              _maestros.map((maestro) {
                return DropdownMenuItem<Maestro>(
                  value: maestro,
                  child: Row(
                    children: [
                      Text(maestro.nombre),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            if (!_maestrosSeleccionados.contains(maestro)) {
                              _maestrosSeleccionados.add(maestro);
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
              _maestrosSeleccionados.map((maestro) {
                return Chip(
                  label: Text(maestro.nombre),
                  onDeleted: () {
                    setState(() {
                      _maestrosSeleccionados.remove(maestro);
                    });
                  },
                );
              }).toList(),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final grado = Grado(
        id: _idController.text,
        nombre: _nombreController.text,
        materias: _materiasSeleccionadas,
        maestros: _maestrosSeleccionados,
        jornada: _jornada,
      );

      if (widget.grado == null) {
        baseDatos.agregarGrado(grado);
      } else {
        baseDatos.actualizarGrado(grado);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.grado == null
                ? "Grado creado exitosamente"
                : "Grado actualizado exitosamente",
          ),
          backgroundColor: Colors.green,
        ),
      );

      if (widget.grado != null) {
        Navigator.pop(context);
      } else {
        _idController.clear();
        _nombreController.clear();
        setState(() {
          _materiasSeleccionadas.clear();
          _maestrosSeleccionados.clear();
          _jornada = 'Matutina';
        });
      }
    }
  }
}
