import 'package:flutter/material.dart';
import '../SolicitudesBack.dart';
import '../widgets/customOutputs.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Configuraciones'),
          titleTextStyle:
              const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          backgroundColor: Color.fromARGB(255, 82, 113, 255),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingButton(
                onPressed: () {
                  mostrarSugerenciasDudasDialog(context);
                },
                texto: 'Dudas y Sugerencias',
              ),
              SettingButton(
                onPressed: () {
                  print('Pressed');
                },
                texto: 'Notificaciones',
              ),
              SettingButton(
                onPressed: () {
                  print('Pressed');
                },
                texto: 'Conexion con Google',
              ),
              SettingButton(
                onPressed: () {
                  _showConfirmationDialog(context).then(
                    (value) {
                      if (value != null) {
                        deleteAccessToken().then((value) => {
                              showMsg(context, 'Saliendo...',
                                  Colors.yellow.shade700),
                              Future.delayed(const Duration(seconds: 3), () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/login',
                                  (Route<dynamic> route) => false,
                                );
                              })
                            });
                      }
                    },
                  );
                },
                texto: 'Cerrar sesion',
              ),
            ],
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(5),
            child: ElevatedButton(
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationVersion: '1.0',
                  applicationName: 'TutoApp',
                  applicationLegalese: 'Open Code',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 82, 113, 255), // Color de fondo
              ),
              child: const Text('Mas informacion',
                  style: TextStyle(color: Colors.white)),
            )));
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            '¿Estás seguro de que quieres cerrar sesión?',
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}

class SettingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String texto;

  SettingButton({required this.onPressed, required this.texto});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        width: double.infinity,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 235, 235, 235),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: ListTile(
              title: Text(
                texto,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.transit_enterexit_rounded),
            )),
      ),
    );
  }
}

class SugerenciasDudasDialog extends StatefulWidget {
  @override
  _SugerenciasDudasDialogState createState() => _SugerenciasDudasDialogState();
}

class _SugerenciasDudasDialogState extends State<SugerenciasDudasDialog> {
  final TextEditingController _sugerenciaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sugerencias y Dudas'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: _sugerenciaController,
                decoration: InputDecoration(),
                minLines: 1,
                maxLines: 8,
              )),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Aquí puedes manejar la acción de enviar la sugerencia o duda

              sendSug(_sugerenciaController.text).then((value) => print(value));
              Navigator.of(context).pop();
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}

void mostrarSugerenciasDudasDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SugerenciasDudasDialog();
    },
  );
}
