//import 'dart:js';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:Tutoapp/providers/CitaProvider.dart';
import 'package:Tutoapp/providers/userProvider.dart';
import '../Entidades.dart';
import '../SolicitudesBack.dart';
import '../widgets/customOutputs.dart';

class CitasScreen extends StatefulWidget {
  @override
  _CitasScreenState createState() => _CitasScreenState();
}

class _CitasScreenState extends State<CitasScreen> {
  Future<void> refreshCita() async {
    getStudentCita().then((value) {
      if (value.containsKey('Error')) {
        showMsg(context, value['Error'], Colors.red);
      } else {
        context.read<CitaProvider>().updateCita(value);
      }
    });
    await Future.delayed(const Duration(seconds: 2));
  }

  String titulo = 'Cita';

  bool showCita = false;
  late Tutor tutor;
  late Cita cita = Cita();
  @override
  void initState() {
    // TODO: implement initState
    tutor = context.read<UserProvider>().getTutor();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cita = context.watch<CitaProvider>().cita;
    if (cita.status == 0) {
      showCita = false;
      titulo = 'Agendar una Cita';
    } else {
      showCita = true;
      titulo = 'Revisar mi Cita';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        elevation: 4,
        titleSpacing: 10,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshCita,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: showCita
                  ? CitaCard(
                      cita: cita,
                      tutor: tutor,
                      onCancel: () {
                        setState(() {
                          refreshCita();
                        });
                      },
                    )
                  : StudentForm(
                      tutor: tutor,
                      onFormSubmit: (data) {
                        setState(() {
                          cita.updateStatus(data);
                          showCita = !showCita;
                        });
                      },
                    )),
        ),
      ),
    );
  }
}

/*
class CitasScreen extends StatelessWidget {
  const CitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> refreshCita() async {
      getStudentCita().then((value) {
        if (value.containsKey('Error')) {
          showMsg(context, value['Error'], Colors.red);
        } else {
          context.read<CitaProvider>().updateCita(value);
        }
      });
      await Future.delayed(const Duration(seconds: 2));
    }

    return RefreshIndicator(
      onRefresh: refreshCita,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(5.0),
              //height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(9.0),
              ),
              child: 
            ),
          ),
        ],
      ),
    );
  }
}
*/

/*
class _AgendaAlumnoForm extends StatefulWidget {
  const _AgendaAlumnoForm({super.key, required this.callback});
  final void Function() callback;

  @override
  State<_AgendaAlumnoForm> createState() => __AgendaAlumnoFormState();
}

class __AgendaAlumnoFormState extends State<_AgendaAlumnoForm> {
  late bool showForm;
  
  final _formKey = GlobalKey<FormState>();

  late TextEditingController motivoController;
  int selectedIndex = 0;
  List<String> categorias = [];

  @override
  void initState() {
    motivoController = TextEditingController();
    //cita = context.read<CitaProvider>().cita;
    cita = Cita();
    tutor = context.read<UserProvider>().getTutor();
    categorias = context.read<CitaProvider>().getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cita = context.watch<CitaProvider>().cita;
    if (cita.status == 0) {
      showForm = true;
    } else {
      showForm = false;
    }

    return Column(
      children: [
        const Padding(
            padding: EdgeInsets.all(10),
            child: Text('Agenda una cita',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600))),
        if (showForm) //----------------------------------------------------------------------
          Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: motivoController,
                    maxLines: 10,
                    minLines: 1,
                    decoration: const InputDecoration(
                      labelText: '¿Porqué quieres tener una cita?',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor, ingresa un motivo.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                      padding: EdgeInsets.all(4),
                      child: Center(
                          child: Text('¿En qué categoria cae tu motivo?',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)))),
                  const Divider(),
                  DropdownButton<int>(
                    value: selectedIndex,
                    onChanged: (int? newIndex) {
                      setState(() {
                        selectedIndex = newIndex!;
                      });
                    },
                    items: List.generate(categorias.length, (index) {
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(categorias[index]),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showMsg(context, 'Procesando...', Colors.grey);
                        createStudentCita(selectedIndex, motivoController.text)
                            .then((response) {
                          if (response.containsKey('Error')) {
                            showMsg(context, response as String, Colors.red);
                          } else {
                            showMsg(
                                context, 'Cita creada !!', Colors.greenAccent);
                            context.read<CitaProvider>().studentUpdate(
                                motivoController.text, response['ID']);
                            motivoController.text = '';
                            /*setState(() {
                                  showForm = !showForm;
                                });*/
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Solicitar',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    child: tutorInfo(widget.tutor.name, widget.tutor.mail),
                  ),
                ],
              ))
        else //------------------------------------------------------------------------------
          Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(15),
            child: Column(children: [
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(2.5),
                child: const StatusIndicator(
                  status: 1,
                  exp: true,
                ),
              ),
              Container(
                  alignment: Alignment.topLeft,
                  child: infoColumn('Motivo:', cita.reason)),
              const SizedBox(height: 5),
              /*LabelAndText(
                  label: 'Categoria:',
                  text: categorias[selectedIndex],
                  isShort: false),*/
              const SizedBox(height: 5),
              if (cita.status == 2)
                citaInfo(cita.getDateWeek(), cita.formatDateTime(), cita.place,
                    cita.coment),
              tutorInfo(tutor.name, tutor.mail),
              const SizedBox(height: 2),
              CustomButton(
                estado: 1,
                funcion: () async {
                  bool? userClickedYes = await showConfirmationDialog(context);

                  if (userClickedYes ?? false) {
                    cancelarStudentCita(cita.id).then((response) {
                      if (response.containsKey('Error')) {
                        showMsg(context, response as String, Colors.red);
                      } else {
                        showMsg(context, 'Cita cancelada', Colors.green);
                        context.read<CitaProvider>().cancelateCita();
                      }
                    });
                  }
                },
                alignment: Alignment.centerLeft,
              ),
            ]),
          )
      ],
    );
  }

  Future<bool?> showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Estás seguro?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sí'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Widget infoColumn(String label, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(text,
            style: const TextStyle(
                fontSize: 15.0,
                fontStyle: FontStyle.italic,
                color: Colors.black87))
      ],
    );
  }
}
*/
class DataDisplay extends StatelessWidget {
  final String label;
  final String contenido;
  final TextStyle labelStyle;
  final bool isColumn;

  DataDisplay({
    required this.label,
    required this.contenido,
    required this.labelStyle,
    this.isColumn = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: isColumn
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ' $label',
                  textAlign: TextAlign.justify,
                  style: labelStyle,
                ),

                //const SizedBox(height: 2.0),
                Container(
                  padding: EdgeInsets.all(4),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38),
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  child: Text(
                    contenido,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Icon(Icons.arrow_forward),
                const SizedBox(width: 2),
                Text(
                  label,
                  style: labelStyle,
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Center(
                    child: Text(
                      contenido,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final int estado;
  final Function() funcion;
  final Alignment alignment;

  const CustomButton({
    Key? key,
    required this.estado,
    required this.funcion,
    this.alignment = Alignment.centerRight, // Alineamiento por defecto
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String texto;
    Color color;

    switch (estado) {
      case 1:
        texto = 'Cancelar';
        color = Colors.red[900]!; // Usamos un tono más oscuro de rojo
        break;
      case 2:
        texto = 'Agendar';
        color = Colors.green[900]!; // Usamos un tono más oscuro de verde
        break;
      case 3:
        texto = 'Enterado';
        color = Colors.blue[900]!; // Usamos un tono más oscuro de verde
        break;
      default:
        texto = 'Enviar';
        color = Colors.blue[900]!; // Usamos un tono más oscuro de azul
    }

    return Align(
      alignment: alignment,
      child: ElevatedButton(
        onPressed: funcion,
        // Texto blanco para contraste
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // bordes redondeados
          ),
        ),
        child: Text(texto, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

Widget tutorInfo(String name, String mail) {
  if (name.isEmpty && mail.isEmpty) {
    return GestureDetector(
      onTap: () {
        print('Pressed');
      },
      child: Card(
        elevation: 2,
        color: Colors.red.shade300,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: const ListTile(
          contentPadding: EdgeInsets.all(15),
          title: Text(
            'No tienes un tutor asignado aun',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text('Presiona para solicitar un tutor'),
          trailing: Icon(
            Icons.error_outline,
            size: 45,
          ),
        ),
      ),
    );
  } else {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        title: const Text(
          'Tu tutor',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              mail,
              style: const TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: Colors.blueAccent),
            )
          ],
        ),
        trailing: const Icon(
          Icons.person_pin_rounded,
          size: 45,
        ),
      ),
    );
  }
}

Widget citaInfo(String dia, String hora, String lugar) {
  return Container(
    color: Colors.grey.shade400,
    padding: const EdgeInsets.all(8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Datos de confirmación',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        DataDisplay(
          label: 'Fecha:',
          contenido: dia,
          isColumn: false,
          labelStyle:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        DataDisplay(
          label: 'Hora:',
          contenido: hora,
          isColumn: false,
          labelStyle:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        DataDisplay(
          label: 'Lugar:',
          contenido: lugar,
          isColumn: false,
          labelStyle:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}

class StudentForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onFormSubmit;
  final Tutor tutor;
  const StudentForm({Key? key, required this.onFormSubmit, required this.tutor})
      : super(key: key);

  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  late TextEditingController motivoController;
  int selectedIndex = 0;
  List<Map<String, dynamic>> categorias = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    categorias = context.read<CitaProvider>().getCategories();
    motivoController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    motivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: motivoController,
              maxLines: 10,
              minLines: 1,
              decoration: const InputDecoration(
                labelText: '¿Porqué quieres tener una cita?',
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor, ingresa un motivo.';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(4),
              child: Center(
                child: Text(
                  '¿En qué categoria cae tu motivo?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Divider(),
            DropdownButton<int>(
              value: selectedIndex,
              onChanged: (int? newIndex) {
                setState(() {
                  selectedIndex = newIndex!;
                });
              },
              items: List.generate(categorias.length, (index) {
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text(categorias[index]["Category_type"]),
                );
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Map<String, dynamic> datosCita = {
                    "CategoryID": categorias[selectedIndex]["ID"],
                    "Reason": motivoController.text,
                  };
                  showMsg(context, 'Procesando...', Colors.grey);
                  createStudentCita(datosCita).then((response) {
                    if (response.containsKey('Error')) {
                      showMsg(context, response as String, Colors.red);
                    } else {
                      datosCita["Category"] =
                          categorias[selectedIndex]["Category_type"];
                      showMsg(context, 'Cita creada !!', Colors.greenAccent);
                      widget.onFormSubmit(datosCita);
                    }
                  });
                }
              },
              child: const Text(
                'Solicitar cita',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              child: tutorInfo(widget.tutor.name, widget.tutor.mail),
            ),
          ],
        ),
      ),
    );
  }
}

class CitaCard extends StatefulWidget {
  final Cita cita;
  final Tutor tutor;
  final VoidCallback onCancel;
  const CitaCard(
      {Key? key,
      required this.cita,
      required this.tutor,
      required this.onCancel})
      : super(key: key);

  @override
  _CitaCardState createState() => _CitaCardState();
}

class _CitaCardState extends State<CitaCard> {
  late Color color;
  late IconData icon;
  late String text;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Cita Actual',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              StatusIndicator(status: widget.cita.status, exp: true)
            ],
          ),
        ),
        const Divider(thickness: 2),
        DataDisplay(
            label: 'Motivo:',
            contenido: widget.cita.reason,
            labelStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        if (widget.cita.status == 2)
          citaInfo(widget.cita.getDateWeek(), widget.cita.formatDateTime(),
              widget.cita.place),
        if (widget.cita.status > 1)
          DataDisplay(
              label: 'Comentario del Tutor:',
              contenido: widget.cita.coment,
              labelStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: tutorInfo(widget.tutor.name, widget.tutor.mail),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red.shade400,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              textStyle: const TextStyle(fontSize: 18),
            ),
            onPressed: () async {
              bool? userClickedYes = await showConfirmationDialog(context);
              if (userClickedYes ?? false) {
                cancelarStudentCita(widget.cita.id).then((response) {
                  if (response.containsKey('Error')) {
                    showMsg(context, response as String, Colors.red);
                  } else {
                    showMsg(context, 'Cita cancelada', Colors.green);
                    context.read<CitaProvider>().cancelateCita();
                  }
                });
              }
            },
            child: const Text('Cancelar cita'),
          ),
        ),
      ],
    );
  }

  Future<bool?> showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Estás seguro de cancelar la cita?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sí'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
