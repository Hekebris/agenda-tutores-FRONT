import 'package:flutter/material.dart';
import '../SolicitudesBack.dart';

class QAScreen extends StatefulWidget {
  const QAScreen({super.key, required this.qas, required this.uploadingQas});
  final List<Map<String, dynamic>> qas;
  final Function(List<Map<String, dynamic>>) uploadingQas;
  @override
  State<QAScreen> createState() => _QAScreenState();
}

class _QAScreenState extends State<QAScreen> {
  List<Map<String, dynamic>> preguntas = [];
  late bool dataArrived;
  @override
  void initState() {
    // TODO: implement initState
    if (widget.qas.isEmpty) {
      dataArrived = false;
      getCosas('faqs').then((values) {
        if (values[0].containsKey('Error')) {
          print(values[0]["Error"]);
        } else {
          preguntas = values;
          widget.uploadingQas(values);
        }
        setState(() {
          dataArrived = true;
        });
      });
    } else {
      setState(() {
        preguntas = widget.qas;
        dataArrived = true;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!dataArrived) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (preguntas.isNotEmpty) {
      // muestra las preguntas
      return Padding(
        padding: const EdgeInsets.all(0),
        child: QAPost(qaList: preguntas),
      );
    } else {
      return Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: const Text('{No hay preguntas}',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54)));
    }
  }
}

class QAPost extends StatelessWidget {
  const QAPost({super.key, required this.qaList});
  final List<Map<String, dynamic>> qaList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preguntas Frecuentes'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      body: ListView.builder(
        itemCount: qaList.length * 2 - 1,
        itemBuilder: (context, index) {
          if (index.isOdd) {
            return const Divider(
              color: Colors.black54,
              thickness: 3,
              endIndent: 15,
              indent: 15,
            );
          }

          final QAIndex = index ~/ 2;

          return Padding(
            padding: const EdgeInsets.all(0),
            child: ListTile(
              title: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: (Colors.blueGrey[50]),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    qaList[QAIndex]["Question"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  qaList[QAIndex]["Answer"],
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
