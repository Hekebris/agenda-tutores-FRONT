import 'package:flutter/material.dart';
import '../SolicitudesBack.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.avi, required this.uploadingAvisos});
  final List<Map<String, dynamic>> avi;
  final Function(List<Map<String, dynamic>>) uploadingAvisos;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> avisos = [];
  late bool dataArrive;
  Future<void> _refreshData() async {
    getCosas('announcements').then((values) => {
          if (values[0].containsKey('Error'))
            {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(values[0]['Error']),
                  backgroundColor: Colors.red,
                  duration: const Duration(microseconds: 50)))
            }
          else
            {avisos = values}
        });

    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  void initState() {
    if (widget.avi.isEmpty) {
      dataArrive = false;
      getCosas('announcements').then((values) {
        if (values[0].containsKey('Error')) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(values[0]['Error']),
              backgroundColor: Colors.red,
              duration: const Duration(microseconds: 20)));
        } else {
          avisos = values;
          widget.uploadingAvisos(values);
        }
        setState(() {
          dataArrive = true;
        });
      });
    } else {
      setState(() {
        avisos = widget.avi;
        dataArrive = true;
      });
    }

    super.initState();
  }

  /*@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (dataArrive)
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: Column(
                children: [
                  if (avisos.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: avisos.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Post(aviso: avisos[index]);
                        },
                      ),
                    )
                  else
                    const Expanded(
                      child: Center(
                        child: Text('No hay anuncios para mostrar'),
                      ),
                    )
                ],
              ),
            ),
          )
        else
          const Expanded(child: Center(child: CircularProgressIndicator()))
      ],
    );
  }
}

class Post extends StatelessWidget {
  final Map<String, dynamic> aviso;

  const Post({Key? key, required this.aviso}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            aviso['Title'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 82, 113, 255),
            ),
          ),
          const Divider(thickness: 2),
          Image.network(
            'https://tutoapp.onrender.com/announcements/image/${aviso["ID"]}',
            width: 200,
            height: 200,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return Container();
              }
            },
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Container();
            },
          ),
          const SizedBox(height: 12.0),
          Text(
            aviso['Content'],
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Image.asset(
            'assets/images/footer_image.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 50,
          ),
        ],
      ),
    );
  }
}

void showCustomSnackbar(
  BuildContext context, {
  required String message,
  Color? backgroundColor,
  TextStyle? textStyle,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: textStyle,
      ),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 2),
    ),
  );
}
