import 'package:flutter/material.dart';

class Notificacion {
  final String texto;
  final String tiempo;

  Notificacion(this.texto, this.tiempo);
}

class NotiScreen extends StatefulWidget {
  NotiScreen({Key? key}) : super(key: key);

  @override
  _NotiScreenState createState() => _NotiScreenState();
}

class _NotiScreenState extends State<NotiScreen> {
  final List<Notificacion> noti = [
    Notificacion('Tu tutor denego la cita', '10:35'),
    Notificacion('Nuevo anuncio de Rectoria', '12:00'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notificaciones'),
          titleTextStyle:
              const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          backgroundColor: Color.fromARGB(255, 82, 113, 255),
        ),
        body: Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          padding: const EdgeInsets.all(5),
          child: ListView.builder(
            itemCount: noti.length,
            itemBuilder: (context, index) {
              return _buildNotificacionTile(noti[index]);
            },
          ),
        ));
  }

  Widget _buildNotificacionTile(Notificacion notificacion) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: const Color.fromARGB(255, 233, 233, 233),
      child: ListTile(
        title: Text(notificacion.texto),
        subtitle: Text(notificacion.tiempo),
        trailing: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            // Eliminar notificaciones logica
            setState(() {
              noti.remove(notificacion);
            });
          },
        ),
      ),
    );
  }
}
