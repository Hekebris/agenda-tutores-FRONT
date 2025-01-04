//import 'package:Tutoapp/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Tutoapp/providers/CitaProvider.dart';
import '../Entidades.dart';
import '../SolicitudesBack.dart';
import '../widgets/customOutputs.dart';
import 'Citas.dart';

enum OptLabel {
  todos('Todos', 1),
  pendiente('Pendientes', 2),
  confirmado('Confirmados', 3);

  const OptLabel(this.label, this.val);
  final String label;
  final int val;
}

class CitasTScreen extends StatefulWidget {
  const CitasTScreen({super.key});

  @override
  State<CitasTScreen> createState() => _CitasTScreenState();
}

class _CitasTScreenState extends State<CitasTScreen> {
  int selectedOpt = 1;
  bool zoomCita = false;
  bool showStudents = false;

  int zoomId = 0;
  Future<void> refreshCitas() async {
    List<Map<String, dynamic>> value = [];
    bool isTimeout = false;

    try {
      value = await getTutorCita().timeout(const Duration(seconds: 5));
    } catch (e) {
      if (e.toString().contains("TimeoutException")) {
        isTimeout = true;
      }
    }
    if (!isTimeout) {
      if (value.isEmpty) {
        print('Esta vacio');
        setState(() {
          context.read<CitaProvider>().noCitas();
        });
      } else {
        if (value[0].containsKey('Error')) {
          msg(context, value[0]['Error'], Colors.red);
        } else {
          setState(() {
            context.read<CitaProvider>().updateCitas(value);
          });
        }
      }
    }

    await Future.delayed(const Duration(seconds: 2));
  }

  List<int> ids = [];
  @override
  void initState() {
    // TODO: implement initState
    zoomCita = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (selectedOpt == 1) {
      ids = context.read<CitaProvider>().getIds();
    } else if (selectedOpt == 2) {
      ids = context.read<CitaProvider>().getIdsYet();
    } else if (selectedOpt == 3) {
      ids = context.read<CitaProvider>().getIdsReady();
    }

    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: zoomCita
            ? CitaCard(
                citaID: zoomId,
                refresh: () {
                  setState(() {
                    refreshCitas();
                  });
                },
                back: () {
                  setState(() {
                    zoomCita = false;
                  });
                },
              )
            : showStudents
                ? MyStudentsDisplayer(
                    back: () {
                      setState(() {
                        showStudents = false;
                      });
                    },
                  )
                : RefreshIndicator(
                    onRefresh: refreshCitas,
                    child: Column(
                      //mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: DropdownButton<int>(
                                value: selectedOpt,
                                isExpanded: true,
                                padding: const EdgeInsets.symmetric(
                                    //vertical: 5,
                                    horizontal: 15),
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black87),
                                iconSize: 40,
                                iconEnabledColor: Colors.blue.shade800,
                                onChanged: (int? opt) {
                                  setState(() {
                                    selectedOpt = opt!;
                                  });
                                },
                                items: const [
                                  DropdownMenuItem<int>(
                                    value: 1,
                                    child: Text('Todos'),
                                  ),
                                  DropdownMenuItem<int>(
                                    value: 2,
                                    child: Text('Pendientes'),
                                  ),
                                  DropdownMenuItem<int>(
                                    value: 3,
                                    child: Text('Confirmados'),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      showStudents = true;
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blue.shade700),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    elevation:
                                        MaterialStateProperty.all<double>(0),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    ' Mis estudiantes',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (context.read<CitaProvider>().areThereCitas() > 0)
                          Expanded(
                              child: ListView.builder(
                                  itemCount: ids.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final int id = ids[index];
                                    return listTileTutor(id, () {
                                      setState(() {
                                        zoomCita = true;
                                        //showStudents = false;
                                        zoomId = id;
                                      });
                                    });
                                  }))
                        /*Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return CitaT(
                            id: ids[index],
                            callback: () => refreshCitas(),
                          );
                        },
                        childCount: ids.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (context.read<CitaProvider>().areThereCitas() == 0)*/
                        else
                          Expanded(
                              child: ListView(children: const [
                            Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                'No tienes citas aun',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                          ])),
                      ],
                    ),
                  ));
  }

  Widget listTileTutor(int id, Function() callbackZoom) {
    Cita cita = context.read<CitaProvider>().getCitaById(id);
    return Card(
      color: Colors.blueGrey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        onTap: () => callbackZoom(),
        title: Text(
          cita.myStudent!.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          cita.category,
          style: const TextStyle(
              fontStyle: FontStyle.italic, color: Colors.black87),
        ),
        trailing: Padding(
          padding: const EdgeInsets.all(6.0),
          child: StatusIndicator(
            status: cita.status,
            exp: false,
          ),
        ),
      ),
    );
  }
}

//----------------------------------------------------

class CitaCard extends StatefulWidget {
  final int citaID;
  final Function() back;
  final Function() refresh;
  const CitaCard(
      {Key? key,
      required this.citaID,
      required this.refresh,
      required this.back})
      : super(key: key);

  @override
  _CitaCardState createState() => _CitaCardState();
}

class _CitaCardState extends State<CitaCard> {
  late Color color;
  late IconData icon;
  late String text;
  late Cita cita;
  String categoria = '';
  bool accept = true;
  bool showForm = false;
  void getMiCita() {
    cita = context.read<CitaProvider>().getCitaById(widget.citaID);
  }

  @override
  void initState() {
    getMiCita();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (scope) {
        if (showForm == true) {
          setState(() {
            showForm = !showForm;
          });
        } else {
          widget.back();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade200,
          leading: IconButton(
              onPressed: () {
                if (showForm == true) {
                  setState(() {
                    showForm = !showForm;
                  });
                } else {
                  widget.back();
                }
              },
              icon: const Icon(Icons.arrow_back)),
          actions: [
            if (!showForm)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: StatusIndicator(status: cita.status, exp: true),
              ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation.drive(
                    Tween<double>(begin: 0.0, end: 1.0).chain(
                      CurveTween(curve: Curves.easeInOut),
                    ),
                  ),
                  child: child,
                );
              },
              child: showForm
                  ? CitaTForm(
                      citaID: cita.id,
                      nombre: cita.myStudent.name,
                      correo: cita.myStudent.mail,
                      aceptando: accept,
                      onFinal: (data) {
                        setState(() {
                          if (data["Status"] == "Aceptada") {
                            data["PlaceID"] = context
                                .read<CitaProvider>()
                                .findPlaceByID(data["PlaceID"]);
                          }
                          cita.updateStatus(data);
                          showForm = !showForm;
                        });
                      },
                      onCancel: () {
                        setState(() {
                          showForm = !showForm;
                        });
                      },
                    )
                  : Column(children: <Widget>[
                      studentInfo(cita.myStudent.name, cita.myStudent.mail),
                      const Divider(thickness: 2),
                      DataDisplay(
                          label: 'Categoria:',
                          contenido: cita.category,
                          isColumn: false,
                          labelStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      DataDisplay(
                          label: 'Motivo:',
                          contenido: cita.reason,
                          labelStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      if (cita.status == 2)
                        citaInfo(cita.getDateWeek(), cita.formatDateTime(),
                            cita.place),
                      if (cita.status == 2 || cita.status == 3)
                        DataDisplay(
                            label: 'Comentario:',
                            contenido: cita.coment,
                            labelStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 14),
                      const Divider(thickness: 2),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  showForm = !showForm;
                                  accept = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red.shade400,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const Text(
                                'Denegar cita',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (cita.status == 1)
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    showForm = !showForm;
                                    accept = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.green.shade400,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
                                  'Aceptar cita',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    ]),
            ),
          ),
        ),
      ),
    );
  }

  int updateMisCitas(BuildContext context) {
    int returnValue = -1;
    getTutorCita().then((value) => {
          if (value.isEmpty)
            {context.read<CitaProvider>().noCitas(), returnValue = 0}
          else
            {
              if (value[0].containsKey('Error'))
                {msg(context, value[0]['Error'], Colors.red), returnValue = 1}
              else
                {
                  context.read<CitaProvider>().updateCitas(value),
                  returnValue = 2
                }
            }
        });
    return returnValue;
  }

  Widget studentInfo(
    String name,
    String mail,
  ) {
    return ListTile(
      //contentPadding: const EdgeInsets.all(15),
      title: const Text(
        'Cita Solicitada por:',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
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
        Icons.co_present_outlined,
        size: 45,
      ),
    );
  }
}

class CitaTForm extends StatefulWidget {
  final int citaID;
  final String nombre;
  final String correo;
  final bool aceptando;
  final Function() onCancel;
  final Function(Map<String, dynamic>) onFinal;

  const CitaTForm(
      {Key? key,
      required this.citaID,
      required this.nombre,
      required this.correo,
      required this.onFinal,
      required this.aceptando,
      required this.onCancel})
      : super(key: key);

  @override
  _CitaTFormState createState() => _CitaTFormState();
}

class _CitaTFormState extends State<CitaTForm> {
  //Controles
  late TextEditingController coment;
  late int placeID;
  late TimeOfDay time;
  late DateTime date;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //Display
  String title = '';
  late Color color;
  @override
  void initState() {
    super.initState();
    if (widget.aceptando) {
      title = 'Aceptando';
      color = Colors.green.shade500;
      time = TimeOfDay.now();
      date = DateTime.now();
      placeID = 0;
    } else {
      title = 'Cancelando';
      color = Colors.red.shade500;
    }
    coment = TextEditingController();
  }

  @override
  void dispose() {
    coment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            ListTile(
              title: Text(title),
              tileColor: color,
              titleTextStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    widget.nombre,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    widget.correo,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.blueAccent),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Divider(thickness: 2),
            if (widget.aceptando)
              Column(
                children: [
                  TimePickerButton(
                      time: time,
                      onTimeChanged: (newTime) {
                        time = newTime;
                      }),
                  DatePickerButton(
                      date: date,
                      onDateChanged: (newDate) {
                        date = newDate;
                      }),
                  PlacePicker2(
                    places: context.read<CitaProvider>().getPlaces(),
                    callback: (id) {
                      placeID = id;
                    },
                  ),
                  const SizedBox(height: 5),
                  const Divider(thickness: 2),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: coment,
                minLines: 1,
                maxLines: 15,
                decoration: const InputDecoration(
                  labelText: 'Agrega un comentario al estudiante',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, escribe un comentario';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => widget.onCancel(),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      if (widget.aceptando == true) {
                        _aceptarCita();
                      } else {
                        _denegarCita();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text('Confirmar'),
                ),
              ],
            )
          ],
        ));
  }

  void _aceptarCita() {
    if (date.weekday >= 1 && date.weekday <= 5) {
      date = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      if (time.hour >= 7 && time.hour <= 21) {
        showConfirmationDialog(
                context, 'Estas seguro de aceptar esta cita con estos datos?')
            .then((value) {
          if (value != null) {
            Map<String, dynamic> datos = {
              "Status": "Aceptada",
              "AppointmentDateTime": customFormatDateTime(date),
              "PlaceID": placeID,
              "Comment": coment.text
            };

            msg(context, 'Cargando...', Colors.grey);
            updateTutorCita(datos, widget.citaID).then((data) {
              if (data.containsKey('Error')) {
                msg(context, data['Error'], Colors.red);
              } else {
                msg(context, 'Cita Aceptada', Colors.teal[800]);
                widget.onFinal(datos);
              }
            });
          }
        });
      } else {
        msg(context, 'La hora debe estar en horarios escolares', Colors.red);
      }
    } else {
      msg(context, 'La cita debe programarse en un día de la semana laborable',
          Colors.red);
    }
  }

  void _denegarCita() {
    showConfirmationDialog(context, 'Estas seguro de denegar esta cita?')
        .then((value) {
      if (value != null) {
        Map<String, dynamic> data = {
          'Status': 'Cancelada',
          'Comment': coment.text
        };
        updateTutorCita(data, widget.citaID).then((value) {
          if (value.containsKey('Error') || value.containsKey('error')) {
            msg(context, value['Error'], Colors.red);
          } else {
            msg(context, 'Cita cancelada', Colors.amber.shade400);
            widget.onFinal(data);
          }
        });
      }
    });
  }

  Future<bool?> showConfirmationDialog(
      BuildContext context, String text) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text),
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

class MyStudentsDisplayer extends StatefulWidget {
  final Function() back;

  const MyStudentsDisplayer({Key? key, required this.back}) : super(key: key);

  @override
  _MyStudentsDisplayerState createState() => _MyStudentsDisplayerState();
}

class _MyStudentsDisplayerState extends State<MyStudentsDisplayer> {
  bool cargando = true;
  List<Map<String, dynamic>> estudiantes = [];
  late User user;

  @override
  void initState() {
    cargando = true;
    super.initState();
    getCosas('tutor/students').then((value) => {
          if (value[0].containsKey('Error'))
            {print('Error')}
          else
            {estudiantes = value},
          setState(() {
            cargando = false;
          })
        });
  }

  Widget studentInfo(String name, String mail, String code) {
    return ListTile(
      title: Text(
        name,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mail,
            style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500),
          ),
          Text(
            code,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
        ],
      ),
      /*trailing:
      const Icon(
        Icons.co_present_outlined,
        size: 45,
      ),*/
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => widget.back(),
        ),
        title: const Text('Tus estudiantes', textAlign: TextAlign.center),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : estudiantes.isEmpty
              ? const Center(child: Text('No tienes estudiantes'))
              : ListView.builder(
                  itemCount: estudiantes.length,
                  itemBuilder: (context, index) {
                    final student = estudiantes[index];
                    final fullName =
                        '${student["Name"]} ${student["FirstSurname"]} ${student["SecondSurname"]}';
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.all(8),
                      child: studentInfo(
                          fullName, student["Mail"], student["Code"]),
                    );
                  },
                ),
    );
  }
}

String customFormatDateTime(DateTime dateTime) {
  // Formato personalizado: YYYY-MM-DDTHH:mm:ssZ
  String formattedDateTime =
      '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)}T${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}Z';
  return formattedDateTime;
}

String _twoDigits(int n) {
  return n.toString().padLeft(2, '0');
}

void msg(BuildContext context, String mensaje, Color? color) {
  color ??= Colors.blueAccent;
  final snackBar = SnackBar(
    content: Text(mensaje),
    backgroundColor: color, // Puedes personalizar el color de fondo
  );

  // Mostrar el SnackBar en el contexto del Scaffold
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class TimePickerButton extends StatefulWidget {
  late TimeOfDay time;
  final ValueChanged<TimeOfDay> onTimeChanged;

  TimePickerButton({
    super.key,
    required this.time,
    required this.onTimeChanged,
  });

  @override
  _TimePickerButtonState createState() => _TimePickerButtonState();
}

class _TimePickerButtonState extends State<TimePickerButton> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = widget.time.hour.toString().padLeft(2, '0');
    final minutes = widget.time.minute.toString().padLeft(2, '0');
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 30),
        const Text(
          'Hora:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 10),
        TextButton(
          onPressed: () async {
            TimeOfDay? newTime = await showTimePicker(
                context: context,
                initialTime: widget.time,
                barrierLabel: 'Selecciona la hora',
                cancelText: 'Cancelar',
                confirmText: 'Aceptar');

            if (newTime != null) {
              setState(() {
                widget.onTimeChanged(newTime);
                widget.time = newTime;
              });
            }
          },
          child: Text(
            '$hours:$minutes',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class DatePickerButton extends StatefulWidget {
  late DateTime date;
  final ValueChanged<DateTime> onDateChanged;

  DatePickerButton({
    super.key,
    required this.date,
    required this.onDateChanged,
  });

  @override
  _DatePickerButtonState createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 30),
        const Text(
          'Dia:  ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 10),
        TextButton(
          onPressed: () async {
            DateTime? newDate = await showDatePicker(
              context: context,
              firstDate: DateTime.now().toLocal(),
              lastDate: DateTime(2024, 12, 20),
              initialDate: widget.date,
              barrierLabel: 'Selecciona el dia',
              cancelText: 'Cancelar',
              confirmText: 'Aceptar',
              //locale: const Locale('es', 'ES')
            );

            if (newDate != null) {
              widget.onDateChanged(newDate);
              setState(() {
                widget.date = newDate;
              });

              // Notificar el cambio de tiempo a través de la devolución de llamada
            }
          },
          child: Text(
            '${widget.date.year}/${widget.date.month}/${widget.date.day}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class PlacePickerButton extends StatefulWidget {
  late String place;
  final ValueChanged<String> onPlaceChanged;
  PlacePickerButton({
    super.key,
    required this.place,
    required this.onPlaceChanged,
  });

  @override
  State<PlacePickerButton> createState() => _PlacePickerButtonState();
}

class _PlacePickerButtonState extends State<PlacePickerButton> {
  late List<String> items = [];
  late String selectedValue;
  @override
  void initState() {
    super.initState();
    items = [
      'Biblioteca',
      'Mod. X',
      'Mod. T',
      'Mod. V',
      'Mod. R',
      'Mod. H',
      'Beta',
      'Alfa'
    ];
    if (items.contains(widget.place)) {
      selectedValue = widget.place;
    } else {
      selectedValue = items[0];
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 30),
        const Text(
          'Lugar:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: selectedValue,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              widget.onPlaceChanged(newValue);
              setState(() {
                selectedValue = newValue;
              });
            }
          },
        ),
      ],
    );
  }
}

class PlacePicker2 extends StatefulWidget {
  final List<Map<String, dynamic>> places;
  Function(int) callback;
  PlacePicker2({required this.places, required this.callback});
  @override
  _PlacePicker2State createState() => _PlacePicker2State();
}

class _PlacePicker2State extends State<PlacePicker2> {
  //final FocusNode _focusNode = FocusNode();
  late Map<String, dynamic> selectedPlace;
  TextEditingController place = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    selectedPlace = widget.places[0];
    widget.callback(selectedPlace['ID']);
    super.initState();
  }

  void showSearchDialog(Function(Map<String, dynamic> a) callUpdate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            List<Map<String, dynamic>> filteredPlaces = widget.places;

            /*void filterSearchResults(String query) {
              setState(() {
                filteredPlaces = query.isEmpty
                    ? places
                    : places
                        .where((place) =>
                            place.toLowerCase().startsWith(query.toLowerCase()))
                        .toList();
              });
            }*/

            return AlertDialog(
              title: const Text('Selecciona un lugar'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /*TextField(
                    controller: place,
                    focusNode: _focusNode,
                    onChanged: (value) {
                      print(value);
                      //filterSearchResults(place.text);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Busca un lugar',
                    ),
                  ),*/
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredPlaces.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                              title: Text(
                                filteredPlaces[index]['Place'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              onTap: () {
                                setState(() {
                                  callUpdate(filteredPlaces[index]);
                                  place.text = '';
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 30),
        const Text(
          'Lugar:  ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 10),
        TextButton(
          onPressed: () => showSearchDialog((a) {
            setState(() {
              selectedPlace = a;
              widget.callback(a["ID"]);
            });
          }),
          child: Text(
            selectedPlace["Place"],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

/*
class LabeledInfo extends StatelessWidget {
  const LabeledInfo({super.key, required this.label, required this.info});
  final String label;
  final String info;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        Text(info)
      ],
    );
  }
}

Future<Map<String, dynamic>?> denegarCita(BuildContext context, String citaID,
    String nombre, String correo, TextEditingController coment) async {
  return showDialog<Map<String, dynamic>?>(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      title: const Text('Alumno/a:'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            nombre,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          Text(
            correo,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.blueAccent),
            textAlign: TextAlign.center,
          ),
          const Divider(),
          const SizedBox(height: 10),
          const Text(
            'Comentario:',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          TextField(
            controller: coment,
            minLines: 1,
            maxLines: 20,
            decoration: const InputDecoration(
              hoverColor: Colors.indigo,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (coment.text.isNotEmpty) {
              msg(context, 'Cita cancelada', Colors.amber.shade400);
              Map<String, dynamic> data = {
                'Status': 'Cancelada',
                'Comment': coment.text
              };
              Navigator.of(context).pop(data);
            } else {
              msg(context, 'Error, Escribe un comentario', Colors.red.shade400);
            }
          },
          child: const Text('Listo'),
        ),
      ],
    ),
  );
}

Future<Map<String, dynamic>?> aceptarCita(BuildContext context, String nombre,
    String correo, TextEditingController coment) async {
  TimeOfDay time = TimeOfDay.now();
  DateTime date = DateTime.now();
  String place = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  return showDialog<Map<String, dynamic>?>(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      title: const Text('Alumno/a:'),
      content: SizedBox(
          width: double.maxFinite,
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    nombre,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    correo,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.blueAccent),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(thickness: 2),
                  //const SizedBox(height: 10),
                  TimePickerButton(
                      time: time,
                      onTimeChanged: (newTime) {
                        time = newTime;
                      }),
                  // const SizedBox(height: 5),
                  DatePickerButton(
                      date: date,
                      onDateChanged: (newDate) {
                        date = newDate;
                      }),
                  //const SizedBox(height: 5),
                  PlacePickerButton(
                      place: place,
                      onPlaceChanged: (newPlace) {
                        place = newPlace;
                      }),
                  const SizedBox(height: 5),
                  const Divider(thickness: 2),
                  const Text(
                    'Comentario:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  TextFormField(
                    controller: coment,
                    minLines: 1,
                    maxLines: 15,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, escribe un comentario';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hoverColor: Colors.indigo,
                    ),
                  ),
                ],
              ))),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              // Validación del formulario

              // Verificación de la hora y el día
              if (date.weekday >= 1 && date.weekday <= 5) {
                date = DateTime(
                    date.year, date.month, date.day, time.hour, time.minute);
                if (time.hour >= 7 && time.hour <= 21) {
                  Map<String, dynamic> datos = {
                    "Status": "Aceptada",
                    "AppointmentDateTime": customFormatDateTime(date),
                    "PlaceID": 1,
                    "Comment": coment.text
                  };

                  msg(context, 'Solicitud enviada', Colors.teal[800]);
                  Navigator.of(context).pop(datos);
                } else {
                  print('La hora debe estar en horarios escolares');
                  msg(context, 'La hora debe estar en horarios escolares',
                      Colors.red.shade400);
                }
              } else {
                print(
                    'La cita debe programarse en un día de la semana laborable');
                msg(
                    context,
                    'La cita debe programarse en un día de la semana laborable',
                    Colors.red.shade400);
              }
            }
          },
          child: const Text('Listo'),
        ),
      ],
    ),
  );
}

class CitaT extends StatefulWidget {
  CitaT({super.key, required this.id, required this.callback});
  final int id;
  Function() callback;
  //Aqui se mandan a llamar los datos de los usuarios

  @override
  State<CitaT> createState() => _CitaTState();
}

class _CitaTState extends State<CitaT> {
  late TextEditingController comentController;
  late bool _showwidget;
  late Cita cita;

  @override
  void initState() {
    comentController = TextEditingController();
    super.initState();
    //cita = context.read<CitaProvider>().getCitaById(widget.id);
    _showwidget = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    comentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cita = context.read<CitaProvider>().getCitaById(widget.id);
    return GestureDetector(
      child: Card(
          color: Colors.blueGrey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              if (_showwidget)
                ListTile(
                  //leading: const Icon(Icons.person_outline_rounded),
                  title: Text(cita.myStudent!.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text(cita.category!),
                  subtitleTextStyle: const TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.black87),
                  trailing: StatusIndicator(
                    status: cita.status,
                    exp: false,
                  ),
                  dense: false,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                )
              else
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          alignment: Alignment.topRight,
                          child: StatusIndicator(
                            status: cita.status,
                            exp: true,
                          ),
                        ),
                        VerticalLabel(label: 'Motivo:', info: cita.reason),
                        HorizontalLabel(
                            label: 'Categoria:', info: cita.category!),
                        if (cita.status == 2) //Aceptada
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Divider(),
                              HorizontalLabel(
                                  label: 'Hora:', info: cita.formatDateTime()),
                              HorizontalLabel(
                                  label: 'Dia:', info: cita.getDateWeek()),
                              HorizontalLabel(label: 'Lugar:', info: cita.place)
                            ],
                          ),
                        if (cita.status != 1 && cita.coment.isNotEmpty)
                          VerticalLabel(
                              label: 'Comentario:', info: cita.coment),
                        StudentDisplay(myStudent: cita.myStudent!),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const SizedBox(height: 20),
                            if (cita.status != 4)
                              CustomButton(
                                  estado: 1,
                                  funcion: () {
                                    denegarCita(
                                            context,
                                            cita.id.toString(),
                                            cita.myStudent!.name,
                                            cita.myStudent!.mail,
                                            comentController)
                                        .then((value) => {
                                              if (value != null)
                                                {
                                                  updateTutorCita(
                                                          value, cita.id)
                                                      .then((value) {
                                                    context
                                                        .read<CitaProvider>()
                                                        .changeStatus(
                                                            cita.id, value);
                                                  }),
                                                  setState(() {
                                                    cita.coment =
                                                        comentController.text;
                                                    cita.status = 4;
                                                  })
                                                }
                                            });
                                  }),
                            if (cita.status == 1)
                              CustomButton(
                                  estado: 2,
                                  funcion: () {
                                    aceptarCita(
                                            context,
                                            cita.myStudent!.name,
                                            cita.myStudent!.mail,
                                            comentController)
                                        .then((data) => {
                                              if (data != null)
                                                {
                                                  //print(data.entries),
                                                  updateTutorCita(data, cita.id)
                                                      .then((data) {
                                                    print(data.entries);
                                                    if (data
                                                        .containsKey('Error')) {
                                                      print(data.entries);
                                                    } else {
                                                      /*print(data.entries);
                                                      context
                                                          .read<CitaProvider>()
                                                          .changeStatus(
                                                              cita.id, data);*/
                                                      widget.callback();
                                                    }
                                                  }),
                                                  setState(() {
                                                    _showwidget = !_showwidget;
                                                  })
                                                }
                                            });
                                  }),
                            const SizedBox(height: 20)
                          ],
                        )
                      ]),
                )
            ],
          )),
    );
  }
}

*/
