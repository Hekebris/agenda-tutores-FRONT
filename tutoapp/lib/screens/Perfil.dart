import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/userProvider.dart'; // Ajusta el nombre del archivo según tu estructura de carpetas
import '../Entidades.dart';
import '../SolicitudesBack.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController nombreController;
  late TextEditingController telefonoController;
  String? base64Image;
  bool cargandoImagen = false;
  void cargarImagen() {
    //List<int> bytes = [];
    //String b64 = '';
    getProfileImg(context.read<UserProvider>().getIsTutor())
        .then((value) async => {
              if (value.containsKey('Error'))
                {
                  {showMessage(context, value['message'], Colors.red)}
                }
              else
                {
                  if (value.containsKey("Image"))
                    {
                      setState(() {
                        base64Image = base64Encode(value['Image'].codeUnits);
                      })
                    }
                }
            });
  }

  @override
  void initState() {
    super.initState();
    // Inicializar controladores u otros elementos necesarios
    cargarImagen();
    nombreController = TextEditingController();
    telefonoController = TextEditingController();
  }

  Future<void> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      updateProfileImg(base64Encode(bytes)).then((value) => {
            if (value.containsKey('Error'))
              {showMessage(context, value['message'], Colors.red)}
            else
              {
                showMessage(context, 'Foto modificada', Colors.green),
                setState(() {
                  base64Image = base64Encode(bytes);
                })
              },
          });
    }
    setState(() {
      cargandoImagen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Supongo que tienes una clase UserProvider que extiende de ChangeNotifier
    // y proporciona el método getUser() para obtener el usuario.
    User user = Provider.of<UserProvider>(context).getUser();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 25,
          onPressed: () {
            Navigator.of(context).pop(); // Acción del botón trailing
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), // Icono trailing
          splashColor: Colors.transparent, // Deshabilitar el hover
          highlightColor: Colors.transparent, // Deshabilitar el hover
        ),
        backgroundColor: const Color.fromARGB(255, 82, 113, 255),
        centerTitle: true, // Centraliza el título
        title: const Text(
          'Perfil',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white // Estilo del título
              ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blueGrey.shade200,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: getImage,
                      onLongPress: () {
                        if (base64Image != null) {
                          eliminarImagen(context);
                        }
                      },
                      child: CircleAvatar(
                        minRadius: 50,
                        maxRadius: 100,
                        backgroundColor: Colors.black87,
                        backgroundImage: base64Image != null
                            ? MemoryImage(base64Decode(base64Image!))
                            : null,
                        child: base64Image == null
                            ? const Icon(Icons.file_upload_rounded,
                                size: 130, color: Colors.white)
                            : null,
                      ),
                    ),
                    if (cargandoImagen) // Mostrar el icono de carga si cargandoImagen es true
                      const Positioned.fill(
                        child: Center(
                            child:
                                CircularProgressIndicator(color: Colors.white)),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileInfo(label: 'Nombre:', info: user.fullName()),
                  ProfileInfo(label: 'Correo:', info: user.mail),
                  ProfileInfo(label: 'Código:', info: user.code),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          OverlayPageRoute(widget: const CambiarContra()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'Cambiar Contraseña',
                        style: estiloBoton1,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void eliminarImagen(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text('¿Quieres borrar tu foto de perfil?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: const Text('Sí'),
              onPressed: () {
                eliminarImagenPerfil().then((value) {
                  if (value.containsKey('Success')) {
                    setState(() {
                      base64Image = null;
                    });
                  } else {
                    showMessage(
                        context, 'Error al eliminar imagen', Colors.red);
                  }
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  TextStyle estiloBoton1 = const TextStyle(
      color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500);
}

class ProfileInfo extends StatelessWidget {
  final String label;
  final String info;
  final IconData? icon;

  const ProfileInfo(
      {Key? key, required this.label, required this.info, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 10),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            Text('  $info',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontStyle: FontStyle.italic)),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ],
    );
  }
}

class CambiarContra extends StatefulWidget {
  const CambiarContra({Key? key}) : super(key: key);

  @override
  _CambiarContraState createState() => _CambiarContraState();
}

class _CambiarContraState extends State<CambiarContra> {
  final _formKey = GlobalKey<FormState>();
  final _viejaContraController = TextEditingController();
  final _nuevaContraController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                  labelText: 'Contraseña Actual',
                  icon: Icon(Icons.lock_rounded),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese la contraseña actual';
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
                  labelText: 'Contraseña Nueva',
                  icon: Icon(Icons.lock_outline_rounded),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese la contraseña nueva';
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
                    // Validar el formulario antes de proceder
                    if (_formKey.currentState?.validate() ?? false) {
                      cambiarC(_viejaContraController.text,
                              _nuevaContraController.text)
                          .then((value) => {
                                if (value.contains('Error'))
                                  {print(value)}
                                else
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Contraseña cambiada con éxito')),
                                    ),
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
}

class RotatePageRoute extends PageRouteBuilder {
  final Widget widget;

  RotatePageRoute({required this.widget})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: RotationTransition(
                turns: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
                child: child,
              ),
            );
          },
        );
}

class OverlayPageRoute extends PageRouteBuilder {
  final Widget widget;

  OverlayPageRoute({required this.widget})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            const begin = Offset(0.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: offsetAnimation,
                child: child,
              ),
            );
          },
        );
}

void showMessage(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: const Duration(seconds: 5), // Duración de 5 segundos
    ),
  );
}
