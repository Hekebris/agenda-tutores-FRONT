class Student {
  String name;
  String mail;
  int id;

  Student(this.name, this.mail, this.id);
}

class Tutor {
  String name;
  String mail;
  int? id;
  Tutor(this.name, this.mail);
}

class User {
  late String id;
  late String code;
  late String name;
  late String lastnameA;
  late String lastnameB;
  late String mail;
  late bool isTutor;
  Tutor? myTutor;

  bool hasTutor() {
    return myTutor != null;
  }

  User();

  String fullName() {
    return '$name $lastnameA $lastnameB';
  }
}

class Cita {
  int id = 0;
  late String reason;
  late String category;
  late String creacion;
  String coment = '';
  late Student myStudent;
  DateTime? dateTime;
  String place = '';
  int status = 0;

  Cita();

  updateStatus(Map<String, dynamic> data) {
    switch (data["Status"]) {
      case "Aceptada":
        status = 2;
        place = data["PlaceID"];
        dateTime = DateTime.tryParse(data["AppointmentDateTime"]);
        coment = data["Comment"];
        break;
      case "Cancelada":
        status = 3;
        coment = data["Comment"];
        break;
      case null:
        status = 1;
        reason = data["Reason"];
        category = data["Category"];
    }
  }

  updateData(Map<String, dynamic> data) {
    if (data.containsKey("ID")) {
      id = data["ID"];
      if (data["Category"] == null) {
        category = 'Nulo';
      } else {
        category = data["Category"];
      }
      reason = data["Reason"];
      switch (data["Status"]) {
        case "Pendiente":
          status = 1;
          break;
        case "Aceptada":
          status = 2;
          //place = data["Place"]; OJOOOOOOOOOOO
          place = data['Place'];
          dateTime = DateTime.tryParse(data["DateTime"]);
          coment = data["Coment"];
          break;
        case "Cancelada":
          status = 3;
          coment = data["Coment"];
          break;
      }
      if (data.containsKey("Student")) {
        var studentData = data["Student"];
        myStudent = Student(
            '${studentData["Name"]} ${studentData["FirstSurname"]} ${studentData["SecondSurname"]}',
            studentData["Mail"],
            studentData["ID"]);
      }
    }
  }

  String formatDateTime() {
    // Obtener la hora en formato de 12 horas
    int hours = dateTime!.hour;
    int minutes = dateTime!.minute;

    // Obtener si es AM o PM
    String period = (hours < 12) ? 'AM' : 'PM';

    // Convertir la hora a formato de 12 horas
    hours = (hours > 12) ? hours - 12 : hours;
    if (hours == 0) {
      hours = 12; // 12:00 AM debería mostrarse como 12:00 PM
    }

    // Asegurarse de que las horas y minutos estén en formato de dos dígitos
    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');

    // Crear la cadena final con formato "hh:mm AM/PM"
    String formattedTime = '$formattedHours:$formattedMinutes $period';

    return formattedTime;
  }

  String getDateWeek() {
    List<String> diasSemana = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    List<String> meses = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    int indexWeek = dateTime!.weekday - 1;
    int indexMonth = dateTime!.month - 1;
    return "${diasSemana[indexWeek]} ${dateTime!.day} de ${meses[indexMonth]}";
  }
}

List<String> updateCategorias(List<Map<String, dynamic>> data) {
  List<String> categorias = [];
  for (var d in data) {
    categorias.insert(0, d["Categorie_type"]);
  }
  return categorias;
}
