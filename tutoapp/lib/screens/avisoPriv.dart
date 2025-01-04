import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PoliticasScreen extends StatelessWidget {
  const PoliticasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, // Cambia esto al icono deseado
            color: Colors.white, // Cambia el color del icono si es necesario
          ),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/login');
          },
        ),
        backgroundColor: const Color.fromARGB(255, 82, 113, 255),
        title: const Text(
          'Términos y Condiciones de Uso',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(
                255, 255, 255, 255), // Cambia "Colors.blue" al color deseado
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Términos y Condiciones de Uso de "TutoApp"',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 82, 113, 255),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                '1. Aceptación de los Términos y Condiciones',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Al acceder y utilizar la aplicación "TutoApp", usted acepta cumplir y estar sujeto a los siguientes términos y condiciones de uso. Si no está de acuerdo con estos términos, por favor, absténgase de utilizar la aplicación.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              Text(
                '2. Uso Autorizado',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                'La aplicación "TutoApp" está diseñada exclusivamente para su uso por estudiantes, profesores y personal afiliado a la Universidad de Guadalajara. El acceso no autorizado o el uso de la aplicación por parte de personas ajenas a la comunidad educativa está estrictamente prohibido.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              Text(
                '3. Registro y Privacidad',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Para utilizar ciertas funciones de la aplicación, los usuarios deben proporcionar información personal, como nombre, dirección de correo electrónico y número de identificación estudiantil. Esta información se recopila y utiliza de acuerdo con nuestra política de privacidad y uso de información.',
                style: TextStyle(fontSize: 16.0),
              ),
              // ... Continuar con el formato para los demás términos

              const SizedBox(height: 20.0),

              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    _launchURL(
                        'https://drive.google.com/file/d/1qp0He33QjNyBmioqHrzlSdYSPzMkSb-A/view?usp=sharing');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // background color
                    onPrimary: Colors.white, // text color
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Ver PDF',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              Align(
                alignment: Alignment.center,
                child: Text(
                  'Consulta el PDF para obtener información detallada.',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey[200],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir el enlace: $url';
    }
  }
}

void main() {
  runApp(
    MaterialApp(
      home: PoliticasScreen(),
    ),
  );
}
