import 'package:Tutoapp/providers/CitaProvider.dart';
import 'package:provider/provider.dart';
import 'package:Tutoapp/providers/userProvider.dart';

import '../widgets/customInputs.dart';
import 'package:flutter/material.dart';
import '../SolicitudesBack.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/customOutputs.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

//Posdata: no quise borrar el Login que ya estaba porque pense que quizas tenia algo que cambie, para que no se borre, pero estos ya extraen datos de formulario
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Agregar SingleChildScrollView
        child: Column(
          // Envolver los elementos con una columna
          children: [
            const SizedBox(height: 40), // Espacio superior
            SvgPicture.asset(
              'assets/images/Vector TUTO.svg',
              semanticsLabel: 'My SVG Image',
              height: 135,
              //color: const Color.fromARGB(255, 82, 113, 255),
            ),
            const SizedBox(height: 0), // Espacio entre el SVG y el formulario
            BaseContainer1(
              Contenido: const LoginForm(),
              Titulo: '',
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController correoController;
  late TextEditingController contrasenaController;
  @override
  void initState() {
    // TODO: implement initState
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
    correoController = TextEditingController();
    contrasenaController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    correoController.dispose();
    contrasenaController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormInput1(
              icon: Icons.mail_outline,
              label: 'Correo Institucional',
              emptyMessage: 'Por favor, ingresa tu correo',
              controller: correoController,
              validator: (value) {
                if (value != null &&
                    (value.endsWith('@alumnos.udg.mx') ||
                        value.endsWith('@academicos.udg.mx'))) {
                  return null;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                    'Solo correos institucionales',
                    selectionColor: Colors.redAccent,
                  )),
                );
                return 'Campo invalido';
              },
            ),
            FormInput1(
              icon: Icons.lock_outlined,
              label: 'Contraseña',
              emptyMessage: 'Por favor, ingresa tu contraseña',
              controller: contrasenaController,
              //isPassword: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 82, 113, 255),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      //triggerNotification();
                      if (_formKey.currentState!.validate()) {
                        // Muestra el indicador de carga
                        showMsg(context, 'Cargando...', Colors.grey);

                        logUser(correoController.text,
                                contrasenaController.text)
                            .then((response) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          if (response.contains('Error')) {
                            if (response.contains('Invalid credentials')) {
                              showMsg(context, 'Datos Incorrectos',
                                  Colors.red.shade400);
                            } else if (response.contains('Unverified')) {
                              context
                                  .read<UserProvider>()
                                  .insertMail(correoController.text);
                              Navigator.pushReplacementNamed(
                                  context, '/verify');
                            } else {
                              showMsg(context, response, Colors.red);
                            }
                          } else {
                            getUserInfo().then((response) {
                              if (response.containsKey('Error')) {
                                showMsg(context, response['Error'], Colors.red);
                              } else {
                                showMsg(context, 'Entrando..', Colors.green);
                                context
                                    .read<UserProvider>()
                                    .insertData(response);
                                context
                                    .read<CitaProvider>()
                                    .setCitaData(context);
                                Navigator.pushNamedAndRemoveUntil(context,
                                    '/App', (Route<dynamic> route) => false);
                              }
                            });
                          }
                        });
                      }
                    },
                    child: const Text('Iniciar sesión'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            InternalLinkWidget(
              labelText: '¿No recuerdas tu contraseña?',
              destinationPage: '/verifymail',
            ),
            const SizedBox(height: 20),
            InternalLinkWidget(
              labelText: '¿No tienes cuenta? Regístrate ahora',
              destinationPage: '/registro',
            ),
            const SizedBox(height: 50),
            InternalLinkWidget(
              labelText: 'Al continuar aceptas términos y condiciones',
              destinationPage: '/privacidad',
              isGray: true,
            ),
            InternalLinkWidget(
              labelText: 'Consulta nuestras politicas de privacidad',
              destinationPage: '/privacidad',
              isGray: true,
            ),
          ],
        ),
      ),
    );
  }
}

class InternalLinkWidget extends StatelessWidget {
  final String labelText;
  final String destinationPage;
  final bool isGray;

  InternalLinkWidget({
    required this.labelText,
    required this.destinationPage,
    this.isGray = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, destinationPage);
        },
        child: Text(
          labelText,
          style: TextStyle(
            decoration: TextDecoration.underline,
            color:
                isGray ? Colors.grey : const Color.fromARGB(255, 82, 113, 255),
          ),
        ),
      ),
    );
  }
}

class CustomLoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController correo;
  final TextEditingController contrasena;

  const CustomLoginButton({
    Key? key,
    required this.formKey,
    required this.correo,
    required this.contrasena,
  }) : super(key: key);

  triggerNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        title: 'Simple Notification',
        body: 'Simple  Button',
        channelKey: 'basic_channel',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 82, 113, 255),
        foregroundColor: Colors.white,
      ),
      onPressed: () {
        triggerNotification();
        if (formKey.currentState!.validate()) {
          // Muestra el indicador de carga
          showMsg(context, 'Cargando...', Colors.grey);

          logUser(correo.text, contrasena.text).then((response) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            if (response.contains('Error')) {
              if (response.contains('Invalid credentials')) {
                showMsg(context, 'Datos Incorrectos', Colors.red.shade400);
              } else if (response.contains('Unverified')) {
                context.read<UserProvider>().insertMail(correo.text);
                Navigator.pushReplacementNamed(context, '/verify');
              } else {
                showMsg(context, response, Colors.red);
              }
            } else {
              getUserInfo().then((response) {
                if (response.containsKey('Error')) {
                  showMsg(context, response['Error'], Colors.red);
                } else {
                  showMsg(context, 'Entrando..', Colors.green);
                  context.read<UserProvider>().insertData(response);
                  context.read<CitaProvider>().setCitaData(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/App', (Route<dynamic> route) => false);
                }
              });
            }
          });
        }
      },
      child: const Text('Iniciar sesión'),
    );
  }
}
