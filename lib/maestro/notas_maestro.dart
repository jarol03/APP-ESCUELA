import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:diacritic/diacritic.dart';  // Paquete para eliminar tildes

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  List<types.Message> _messages = [];
  final _user = const types.User(id: 'user');

  // Preguntas y respuestas predefinidas
  final Map<String, String> _faq = {
    'cómo cambio mi contraseña': 'Sólo el administrador puede cambiar las credenciales de los alumnos o maestros.',
    '¿qué formato debe tener el archivo?': 'El archivo debe ser en formato Excel (.xlsx).',
    '¿puedo subir varios archivos a la vez?': 'No, solo puedes subir un archivo a la vez.',
  };

  // Función para normalizar texto (quitar tildes y convertir a minúsculas)
  String normalizeText(String text) {
    String normalized = removeDiacritics(text).toLowerCase();
    return normalized;
  }

  void _handleSendPressed(types.PartialText message) {
    String respuesta = "Lo siento, no tengo esa información.";
    
    // Normalizar la entrada del usuario
    String normalizedMessage = normalizeText(message.text);

    // Buscar la respuesta en las preguntas frecuentes
    for (var question in _faq.keys) {
      if (normalizeText(question) == normalizedMessage) {
        respuesta = _faq[question]!;
        break;
      }
    }

    final botMessage = types.TextMessage(
      author: types.User(id: 'bot'),
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: respuesta,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    setState(() {
      _messages.insert(0, botMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ChatBot - Ayuda"),
        backgroundColor: const Color.fromARGB(255, 100, 200, 236),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Título de la pantalla
            const Text(
              "¿Tienes alguna pregunta sobre el sistema?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Área para el chat
            Expanded(
              child: Chat(
                messages: _messages,
                onSendPressed: _handleSendPressed,
                user: _user,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
