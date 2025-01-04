import 'package:flutter/material.dart';
import 'loginForm.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _animation = StepTween(begin: 0, end: 3).animate(_controller);

    Future.delayed(const Duration(seconds: 30)).then((_) {
      // Aquí puedes revisar las credenciales y navegar a la página correspondiente
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()), // Reemplaza esto con la página a la que quieres navegar
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            AnimatedBuilder(
              animation: _animation,
              builder: (_, __) {
                String text = '.';
                for (int i = 0; i < _animation.value; i++) {
                  text += ' .';
                }
                return Text(text, style: const TextStyle(fontSize: 24));
              },
            ),
          ],
        ),
      ),
    );
  }
}


