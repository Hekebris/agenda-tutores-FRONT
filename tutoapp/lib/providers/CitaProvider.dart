import 'package:flutter/material.dart';
import '../widgets/customOutputs.dart';
import 'package:provider/provider.dart';
import 'userProvider.dart';
import '../SolicitudesBack.dart';
import '../Entidades.dart';

class CitaProvider extends ChangeNotifier {
  Cita _cita = Cita();
  List<Cita> _citas = [];
  List<Map<String, dynamic>> categorias = [];
  List<Map<String, dynamic>> places = [];

  Cita get cita => _cita;
  List<Cita> get citas => _citas;

  setCitaData(BuildContext context) {
    if (context.read<UserProvider>().getIsTutor()) {
      //si es tutor
      getTutorCita().then((response) {
        if (response.isNotEmpty) {
          if (response[0].containsKey('Error')) {
            showMsg(context, response[0]['Error'], Colors.red);
          } else {
            updateCitas(response);
            setPlaces();
          }
        }
      });
    } else if (context.read<UserProvider>().hasTutor()) {
      //Es estudiante y tiene tutor
      getStudentCita().then((value) {
        if (value.containsKey('Error')) {
          print(value['Error']);
        } else {
          updateCita(value);
          setCategories();
        }
      });
    }
  }

  setCategories() {
    getCosas('categories').then((values) {
      if (!values[0].containsKey('Error')) {
        for (Map<String, dynamic> d in values) {
          if (!categorias.any((element) => element["ID"] == d["ID"])) {
            categorias.add(d);
          }
        }
      } else {
        categorias = [];
      }
    });
  }

  setPlaces() {
    getCosas('places').then((values) {
      if (!values[0].containsKey('Error')) {
        for (Map<String, dynamic> d in values) {
          places.add(d);
        }
      } else {
        places = [];
      }
    });
  }

  List<Map<String, dynamic>> getPlaces() {
    return places;
  }

  String findPlaceByID(int id) {
    for (var place in places) {
      if (place["ID"] == id) {
        return place["Place"];
      }
    }
    return 'nulo';
  }

  List<Map<String, dynamic>> getCategories() {
    return categorias;
  }

  void studentUpdate(String stReason, int id) {
    _cita.reason = stReason;
    _cita.id = id;
    _cita.status = 1;
    notifyListeners();
  }

  void updateCita(Map<String, dynamic> data) {
    if (data.containsKey('Status')) {
      final Cita newData = Cita();
      newData.updateData(data);

      _cita = newData;

      Future.microtask(() {
        notifyListeners();
      });
    }
  }

  void noCitas() {
    _citas.clear();
  }

  void updateCitas(List<Map<String, dynamic>> data) {
    Cita cita;
    _citas.clear();
    for (Map<String, dynamic> d in data) {
      cita = Cita();
      cita.updateData(d);
      _citas.add(cita);
    }
    //Future.microtask(() {
    //notifyListeners();
    //});
  }

  Cita getCitaById(int id) {
    return _citas.firstWhere((Cita cita) => cita.id == id,
        orElse: () => Cita());
  }

  List<int> getIds() {
    List<int> ids = [];
    for (Cita c in _citas) {
      ids.add(c.id);
    }
    return ids;
  }

  List<int> getIdsYet() {
    List<int> ids = [];
    for (Cita c in _citas) {
      if (c.status == 1) {
        ids.add(c.id);
      }
    }
    return ids;
  }

  List<int> getIdsReady() {
    List<int> ids = [];
    for (Cita c in _citas) {
      if (c.status == 2) {
        ids.add(c.id);
      }
    }
    return ids;
  }
/*
  Cita changeStatus(int id, Map<String, dynamic> data) {
    int index = 0;
    for (Cita c in _citas) {
      if (c.id == id) {
        break;
      } else {
        index++;
      }
    }

    switch (data["Status"]) {
      case "Aceptada":
        _citas[index].status = 2;
        _citas[index].place = 'Biblioteca'; //data["Place"];
        _citas[index].dateTime =
            DateTime.tryParse(data[data["AppointmentDateTime"]]);
        _citas[index].coment = data["Comment"];
        break;
      case "Cancelada":
        _citas[index].status = 3;
        _citas[index].coment = data["Comment"];
        break;
    }

    return _citas[index];
  }*/

  int areThereCitas() {
    return _citas.length;
  }

  void cancelateCitas(int id) {
    _citas.removeWhere((Cita cita) => cita.id == id);
    notifyListeners();
  }

  void cancelateCita() {
    _cita = Cita();
    notifyListeners();
  }
}
