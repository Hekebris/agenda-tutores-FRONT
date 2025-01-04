import 'package:flutter/material.dart';
import '../Entidades.dart';

void showMsg(BuildContext context, String text, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 3),
    ),
  );
}

class VerticalLabel extends StatelessWidget {
  const VerticalLabel({super.key, required this.label, required this.info});
  final String label;
  final String info;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            info,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class HorizontalLabel extends StatelessWidget {
  const HorizontalLabel({super.key, required this.label, required this.info});
  final String label;
  final String info;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 5),
          Text(
            info,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

class StudentDisplay extends StatelessWidget {
  const StudentDisplay({super.key, required this.myStudent});
  final Student myStudent;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 4,
          ),
          const Divider(
            thickness: 1.5,
            color: Colors.black54,
          ),
          const SizedBox(
            height: 4,
          ),
          const Icon(
            Icons.person_outline_rounded,
            size: 30,
          ),
          Text(myStudent.name,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          const SizedBox(height: 2),
          Text(
            myStudent.mail,
            style: const TextStyle(
                color: Colors.blueAccent, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 4,
          ),
          const Divider(
            thickness: 1.5,
            color: Colors.black54,
          ),
          const SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }
}

class StatusIndicator extends StatelessWidget {
  final int status;
  final bool exp;

  const StatusIndicator({Key? key, required this.status, required this.exp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;
    IconData icon;

    switch (status) {
      case 1:
        text = 'Pendiente';
        color = Colors.yellow;
        icon = Icons.hourglass_empty;
        break;
      case 2:
        text = 'Aceptado';
        color = Colors.green;
        icon = Icons.check_circle_outline;
        break;
      case 3:
        text = 'Cancelado';
        color = Colors.red;
        icon = Icons.cancel_outlined;
        break;
      case 4:
        text = 'Denegado';
        color = Colors.redAccent;
        icon = Icons.block_flipped;
        break;
      default:
        text = 'sin estado';
        color = Colors.grey;
        icon = Icons.error;
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: color.withOpacity(0.7)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (exp)
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        Icon(
          icon,
          weight: 10,
          size: 26,
          color: Colors.black,
        ),
      ]),
    );
  }
}
