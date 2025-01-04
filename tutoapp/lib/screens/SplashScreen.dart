import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
//import 'package:Tutoapp/Entidades.dart';
import 'package:Tutoapp/providers/userProvider.dart';
import 'package:Tutoapp/providers/CitaProvider.dart';
//import 'loginForm.dart';
//import 'AppNavegador.dart';
import 'package:Tutoapp/SolicitudesBack.dart';
//import '../widgets/customOutputs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isLoading = true;
  bool isError = false;
  bool _isInitialized = false; // Añadida variable de control

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.repeat(reverse: true);
    _initialize(); // Llamar a la función de inicialización
  }

  void _initialize() {
    if (!_isInitialized) {
      // Verificar si ya ha sido inicializado
      _isInitialized = true;
      getUserInfo().then((snapshot) {
        if (snapshot.containsKey('Error')) {
          String error = snapshot['Error'];
          if (error == 'tokent' || snapshot['statusCode'] == 401) {
            // No hay token o no es válido
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            });
          } else {
            setState(() {
              isError = true;
            });
          }
        } else {
          context.read<UserProvider>().insertData(snapshot);
          context.read<CitaProvider>().setCitaData(context);
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/App',
                (Route<dynamic> route) => false,
              );
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/Vector TUTO.svg',
            semanticsLabel: 'My SVG Image',
            height: 135,
          ),
          const SizedBox(height: 100),
          if (isLoading && !isError)
            const SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: Colors.indigo,
                strokeWidth: 6,
              ),
            )
          else
            const Text(
              "Error...",
              style: TextStyle(color: Colors.red),
            )
        ],
      ),
    );
  }
}

Widget spText(String msg) {
  return Text(
    msg,
    style: const TextStyle(color: Colors.white, fontSize: 18),
  );
}
