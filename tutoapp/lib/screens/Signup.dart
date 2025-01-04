import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Tutoapp/providers/userProvider.dart';
import 'package:Tutoapp/widgets/customOutputs.dart';
import '../widgets/customInputs.dart';
import '../SolicitudesBack.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nombreController;
  late TextEditingController codigoController;
  late TextEditingController correoController;
  late TextEditingController apellidoController;
  late TextEditingController contrasenaController;
  late TextEditingController confirmarContrasenaController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nombreController = TextEditingController();
    codigoController = TextEditingController();
    correoController = TextEditingController();
    apellidoController = TextEditingController();
    contrasenaController = TextEditingController();
    confirmarContrasenaController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nombreController.dispose();
    codigoController.dispose();
    correoController.dispose();
    apellidoController.dispose();
    contrasenaController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: BaseContainer2(
            Contenido: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormInput1(
                    icon: Icons.account_circle,
                    label: 'Nombre',
                    emptyMessage: 'Por favor, ingresa tu nombre',
                    controller: nombreController,
                  ),
                  FormInput1(
                    icon: Icons.account_balance_rounded,
                    label: 'Apellidos',
                    emptyMessage: 'Por favor, ingresa tus apellidos',
                    controller: apellidoController,
                  ),
                  FormInput1(
                    icon: Icons.contact_emergency_rounded,
                    label: 'Código de alumno',
                    emptyMessage: 'Por favor, ingresa tu código',
                    controller: codigoController,
                  ),
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
                    isPassword: true,
                  ),
                  FormInput1(
                    icon: Icons.lock,
                    label: 'Confirmar Contraseña',
                    emptyMessage: 'Confirma tu contraseña',
                    controller: confirmarContrasenaController,
                    onChanged: (value) {
                      final String contra = contrasenaController.text;
                      if (contra != value) {
                        value = '';
                        return 'La contraseña no coincide';
                      }
                      return '';
                    },
                    isPassword: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 82, 113, 255),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              showMsg(context, 'Procesando',
                                  const Color.fromARGB(255, 82, 113, 255));
                              if (contrasenaController.text ==
                                  confirmarContrasenaController.text) {
                                var apellidos =
                                    apellidoController.text.split(" ");

                                // Datos del estudiante
                                Map<String, dynamic> datosEstudiante = {
                                  "Name": nombreController.text,
                                  "FirstSurname": apellidos[0],
                                  "SecondSurname": apellidos[1],
                                  "Mail": correoController.text,
                                  "PasswordHash": contrasenaController.text,
                                  "Code": codigoController.text
                                };
                                //Crear usuario
                                registrarEstudiante(datosEstudiante)
                                    .then((result) => {
                                          if (result.contains('Error'))
                                            {print(result)}
                                          else if (result.contains('409'))
                                            {
                                              result.replaceFirst('409: ', ''),
                                              showMsg(
                                                  context, result, Colors.red)
                                            }
                                          else
                                            {
                                              showMsg(context, 'Usuario creado',
                                                  Colors.green),
                                              context
                                                  .read<UserProvider>()
                                                  .insertMail(
                                                      datosEstudiante["Mail"]),
                                              Navigator.pushReplacementNamed(
                                                  context, '/verify')
                                            }
                                        });
                              } else {
                                showMsg(context, 'Contraseña no coincide',
                                    Colors.red);
                                setState(() {
                                  contrasenaController.text = '';
                                  confirmarContrasenaController.text = '';
                                });
                              }
                            }
                          },
                          child: const Text('Registrar'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InternalLinkWidget(
                    labelText: 'Al continuar aceptas términos y condiciones',
                    destinationPage: '/privacidad',
                    isGray: true,
                  ),
                  InternalLinkWidget(
                    labelText: 'Consulta nuestras políticas de privacidad',
                    destinationPage: '/privacidad',
                    isGray: true,
                  ),
                  const SizedBox(height: 8), // Espacio adicional
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '¿Ya tienes cuenta? Inicia sesión',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color.fromARGB(255, 82, 113, 255),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
            Titulo: 'Registro',
          ),
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
            color: isGray ? Colors.grey : Color.fromARGB(255, 82, 113, 255),
          ),
        ),
      ),
    );
  }
}
