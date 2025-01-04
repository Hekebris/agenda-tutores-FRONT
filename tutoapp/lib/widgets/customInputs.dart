import 'package:flutter/material.dart';

class FormInput1 extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? emptyMessage;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? Function(String)? onChanged;
  final bool isPassword;

  FormInput1(
      {required this.icon,
      required this.label,
      this.emptyMessage,
      required this.controller,
      this.validator,
      this.onChanged,
      this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return emptyMessage ?? 'Este campo es obligatorio';
              }
              return null;
            },
        onChanged: (value) {
          if (onChanged != null) {
            onChanged!(value);
          }
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.black),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  bool esCorreoValido(String correo) {
    // Verifica si el correo tiene el dominio correcto
    return correo.endsWith('@alumnos.udg.mx') ||
        correo.endsWith('@academicos.udg.mx');
  }
}

class BaseContainer2 extends StatelessWidget {
  final Widget Contenido;
  final String Titulo;

  const BaseContainer2(
      {Key? key, required this.Contenido, required this.Titulo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            Titulo,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
              height:
                  20), // Espacio adicional para separar el título del contenido
          Contenido,
        ],
      ),
    );
  }
}

class BaseContainer1 extends StatelessWidget {
  final Widget Contenido;
  final String Titulo;

  BaseContainer1({required this.Contenido, required this.Titulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60, left: 22),
                  child: Text(
                    Titulo,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Contenido,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SendBtn extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  SendBtn({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.orange,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          elevation: 0,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class InternalLinkWidget extends StatelessWidget {
  String destinationPage;

  InternalLinkWidget({required this.destinationPage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Agrega aquí la lógica para navegar a la página de destino cuando se hace clic en el enlace.
        Navigator.pushNamed(context, destinationPage);
      },
      child: Text(
        'Ir a $destinationPage', // Puedes personalizar el texto del enlace
        style: TextStyle(
          color: Colors.grey[400],
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class CtmText1 extends StatelessWidget {
  final String texto;
  final String label;
  final IconData icono;

  const CtmText1({
    required this.icono,
    required this.label,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black, // Puedes ajustar el color del subrayado
              width: 1.0, // Puedes ajustar el ancho del subrayado
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icono,
              color: Colors.black,
              size: 30,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 5),
            Text(
              texto,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
