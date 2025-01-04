import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Tutoapp/providers/userProvider.dart';
import '../SolicitudesBack.dart';

String? globalEmail;

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());
  String avisoS = '';
  void _updateAvisoS(av) {
    setState(() {
      avisoS = av; // Cambiamos el valor de avisoS
    });

    // Esperar 5 segundos antes de volver a cambiar avisoS
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        avisoS = ''; // Cambiamos avisoS de nuevo
      });
    });
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 82, 113, 255),
          title: const Text('Verificación de estudiante'),
          titleTextStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Un codigo de verificación fue enviado a tu correo institucional:',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextField(
                            controller: controllers[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            autofocus: index == 0,
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            decoration: const InputDecoration(
                              counter: Offstage(),
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(avisoS,
                          style: TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              color: Colors.red[700]))),
                  ElevatedButton.icon(
                    onPressed: () {
                      String verificationCode = controllers
                          .map((controller) => controller.text)
                          .join();
                      //showCustomSnackBar(context, 'jei beiibi', Colors.red);
                      if (verificationCode.length == 6) {
                        var mail = globalEmail.toString();
                        /////////////////////////////////////////////////////////////tamal
                        print(mail);
                        verifyUser(mail, verificationCode).then((value) => {
                              if (value.contains('Error'))
                                {
                                  if (value.contains('Wrong verification'))
                                    {_updateAvisoS('Codigo invalido.')}
                                  else
                                    {
                                      showCustomSnackBar(
                                          context, value, Colors.red)
                                    }
                                }
                              else
                                {
                                  showCustomSnackBar(context,
                                      'Usuario verificado', Colors.green),
                                  Navigator.pushReplacementNamed(
                                      context, '/login')
                                }
                            });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 82, 113, 255),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.check_box_sharp),
                    label: const Text(
                      'Verificar',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ])));
  }

  void showCustomSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 5), // Duración de 5 segundos
      ),
    );

    // Eliminar el SnackBar después de 5 segundos
    Future.delayed(const Duration(seconds: 5), () {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });
  }
}

class VerifyMail extends StatefulWidget {
  const VerifyMail({Key? key});

  @override
  _VerifyMailState createState() => _VerifyMailState();
}

class _VerifyMailState extends State<VerifyMail> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _email;
  String? _errorMessage;
  bool searching = false;

  void verificarCorreo() {
    if (_formKey.currentState!.validate()) {
      String email = _email.text;
      globalEmail = email;

      enviarToken(email).then((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PasswordChangeToken(),
          ),
        );
      }).catchError((error) {
        setState(() {
          _errorMessage = 'Error al enviar el token. Inténtalo de nuevo.';
          searching = false;
        });
      });
    }
  }

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 82, 113, 255),
        title: const Text('Recuperar contraseña'),
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '¿Cuál es tu correo?',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _email,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  border: const OutlineInputBorder(),
                  errorText: _errorMessage,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo no puede estar vacío';
                  }
                  if (!(value.endsWith('@alumnos.udg.mx') ||
                      value.endsWith('@academicos.udg.mx'))) {
                    return 'Solo se aceptan correos institucionales';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (searching) {
                    return;
                  }
                  setState(() {
                    _errorMessage = null;
                    searching = true;
                  });
                  verificarCorreo();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue.shade800,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  textStyle: const TextStyle(
                    fontSize: 18.0,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                child: const Text('Enviar'),
              ),
              if (searching)
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.blue.shade700,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordChangeToken extends StatefulWidget {
  const PasswordChangeToken({Key? key}) : super(key: key);

  @override
  _PasswordChangeTokenState createState() => _PasswordChangeTokenState();
}

class _PasswordChangeTokenState extends State<PasswordChangeToken> {
  List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());
  String avisoS = '';
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  void _updateAvisoS(av) {
    setState(() {
      avisoS = av; // Cambiamos el valor de avisoS
    });

    // Esperar 5 segundos antes de volver a cambiar avisoS
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        avisoS = ''; // Cambiamos avisoS de nuevo
      });
    });
  }

  void verificarToken() {
    // Aquí puedes agregar la lógica para verificar el token y la contraseña nueva
    String verificationCode =
        controllers.map((controller) => controller.text).join();
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Verificar que todos los campos estén llenos y que el token tenga la longitud correcta
    if (verificationCode.length == 6 &&
        newPassword.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      // Ejemplo básico de verificación de coincidencia de contraseñas
      if (newPassword == confirmPassword) {
        String verificationCode =
            controllers.map((controller) => controller.text).join();
        //showCustomSnackBar(context, 'jei beiibi', Colors.red);
        if (verificationCode.length == 6) {
          var mail = globalEmail.toString();

          ChangePassword(mail, verificationCode, newPassword).then((value) => {
                if (value.contains('Error'))
                  {
                    if (value.contains('Wrong verification'))
                      {_updateAvisoS('Codigo invalido.')}
                    else
                      {showCustomSnackBar(context, value, Colors.red)}
                  }
                else
                  {
                    showCustomSnackBar(
                        context, 'Contraseña cambiada', Colors.green),
                    Navigator.pushReplacementNamed(context, '/login')
                  }
              });
        }
      } else {
        _updateAvisoS('Las contraseñas no coinciden');
      }
    } else {
      _updateAvisoS(
          'Por favor ingresa el código de verificación y la nueva contraseña');
    }
  }

  @override
  void initState() {
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 82, 113, 255),
          title: const Text('Cambio de contraseña'),
          titleTextStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Un token fue enviado a tu correo:',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextField(
                            controller: controllers[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            autofocus: index == 0,
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            decoration: const InputDecoration(
                              counter: Offstage(),
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Ingresa la nueva contraseña',
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirma la contraseña',
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(avisoS,
                          style: TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              color: Colors.red[700]))),
                  ElevatedButton.icon(
                    onPressed: () => verificarToken(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 82, 113, 255),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.check_box_sharp),
                    label: const Text(
                      'Cambiar',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ])));
  }

  void showCustomSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 5), // Duración de 5 segundos
      ),
    );

    // Eliminar el SnackBar después de 5 segundos
    Future.delayed(const Duration(seconds: 5), () {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });
  }
}

class PasswordChange extends StatefulWidget {
  const PasswordChange({Key? key}) : super(key: key);

  @override
  _PasswordChangeState createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  final _formKey = GlobalKey<FormState>();
  final _viejaContraController = TextEditingController();
  final _nuevaContraController = TextEditingController();

  @override
  void dispose() {
    _viejaContraController.dispose();
    _nuevaContraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 82, 113, 255),
        title: const Text('Nueva contraseña'),
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Cambiar Contraseña',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _viejaContraController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña Nueva',
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.lock_rounded),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo no puede estar vacio';
                  }
                  // Puedes agregar más validaciones según tus requisitos
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nuevaContraController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirme la nueva contraseña',
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.lock_outline_rounded),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo no puede estar vacio';
                  }
                  // Puedes agregar más validaciones según tus requisitos
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      cambiarC(_viejaContraController.text,
                              _nuevaContraController.text)
                          .then((value) => {
                                if (value.contains('Error'))
                                  {
                                    showCustomSnackBar(
                                        context, value, Colors.red)
                                  }
                                else
                                  {
                                    showCustomSnackBar(
                                        context,
                                        'Contraseña cambiada con éxito',
                                        Colors.green),
                                    Navigator.pop(context)
                                  }
                              });
                    }
                  },
                  child: const Text(
                    'Aplicar',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void showCustomSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 5), // Duración de 5 segundos
      ),
    );

    // Eliminar el SnackBar después de 5 segundos
    Future.delayed(const Duration(seconds: 5), () {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });
  }
}
