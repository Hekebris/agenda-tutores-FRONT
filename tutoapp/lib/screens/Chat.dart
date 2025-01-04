import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  List<Mensaje> mensajes = [];
  TextEditingController mensajeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 235, 235, 235),
        title: const Text('Chatbot Tutotopo vs1.0',
            style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500)),
        elevation: 5,
        leading: const Icon(Icons.blur_circular_rounded),
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0))),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: mensajes.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text(
                      mensajes[index].texto,
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    // Alinea el contenido a la izquierda
                    contentPadding: const EdgeInsets.only(left: 20.0),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: mensajeController,
                      maxLines: 4,
                      minLines: 1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Escribe un mensaje...',
                        filled: true,
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 126, 126, 126)),
                      ),
                      style:
                          const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: Colors.black),
                  onPressed: () {
                    if (mensajeController.text.isNotEmpty) {
                      enviarMensaje(mensajeController.text);
                      mensajeController.clear();
                    }
                  },
                  color: Colors.greenAccent.shade700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void enviarMensaje(String texto) {
    setState(() {
      mensajes.add(Mensaje(texto));
    });
  }
}

class Mensaje {
  final String texto;

  Mensaje(this.texto);
}
