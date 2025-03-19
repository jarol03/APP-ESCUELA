import 'package:flutter/material.dart';

class Horario {
  final String id;
  final TimeOfDay horaInicio;
  final TimeOfDay horaFin;
  final String dia; // Lunes, Martes, etc.

  Horario({
    required this.id,
    required this.horaInicio,
    required this.horaFin,
    required this.dia,
  });

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "horaInicio": horaInicio.toString(),
      "horaFin": horaFin.toString(),
      "dia": dia,
    };
  }

  // Convertir desde Map
  factory Horario.fromMap(Map<String, dynamic> data) {
    return Horario(
      id: data["id"],
      horaInicio: TimeOfDay(
        hour: int.parse(data["horaInicio"].split(':')[0]),
        minute: int.parse(data["horaInicio"].split(':')[1]),
      ),
      horaFin: TimeOfDay(
        hour: int.parse(data["horaFin"].split(':')[0]),
        minute: int.parse(data["horaFin"].split(':')[1]),
      ),
      dia: data["dia"],
    );
  }
}
