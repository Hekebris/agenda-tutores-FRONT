import 'dart:convert';
//import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<String> registrarEstudiante(Map<String, dynamic> estudiante) async {
  final url = Uri.parse('https://tutoapp.onrender.com/students/register');

  try {
    final respuesta = await http.post(
      url,
      body: jsonEncode(estudiante),
    );

    if (respuesta.statusCode == 200) {
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);
      print('Usuario creado: ${datosRespuesta["user"]}');
      return 'EXITO';
    } else if (respuesta.statusCode == 409) {
      Map<String, dynamic> mensaje = jsonDecode(respuesta.body);
      return '409: ${mensaje['message']}';
    } else {
      // Manejar errores
      print('Error en la solicitud HTTP: ${respuesta.statusCode}');
      return 'Error en la solicitud HTTP ${respuesta.statusCode}';
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return 'Error de red o excepción $error';
  }
}

Future<String> logUser(String mail, String password) async {
  final url = Uri.parse('https://tutoapp.onrender.com/login');
  // Datos del estudiante
  Map<String, dynamic> datosEstudiante = {
    "Mail": mail,
    "Password": password,
  };

  try {
    final respuesta = await http.post(
      url,
      body: jsonEncode(datosEstudiante),
    );

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);
      //print(datosRespuesta);
      //print('Usuario logeado: ${datosRespuesta["user"]}');
      final storage = FlutterSecureStorage();
      await storage.write(key: 'access_token', value: datosRespuesta["token"]);
      await storage.write(key: 'user_type', value: datosRespuesta["user_type"]);

      //print('Si entro(logeado): ${datosRespuesta["user_type"]}');
      return datosRespuesta["user_type"];
    } else {
      // Manejar errores
      return 'Error: ${respuesta.statusCode} | ${respuesta.body}';
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return 'Error de red o excepción $error';
  }
}

Future<void> enviarToken(String email) async {
  final url = Uri.parse('https://tutoapp.onrender.com/users/resend');
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  final body = jsonEncode({'Mail': email});
  print(email);
  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // Token enviado con éxito
      print('Token enviado');
    } else {
      // Error al enviar el token
      print('Error al enviar el token: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<Map<String, dynamic>> getUserInfo() async {
  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');
  if (accessToken == null) {
    return {'Error': 'tokent'};
  }

  final userType = await storage.read(key: "user_type");
  print(userType);
  final url = Uri.parse('https://tutoapp.onrender.com/$userType/info');

  try {
    final respuesta = await http.get(url, headers: {'Auth': accessToken});

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);
      //print('GetUserInfo');
      //print('datosRespuesta');
      return datosRespuesta;
    } else {
      // Manejar errores
      print('Error en la solicitud HTTP: ${respuesta.statusCode}');
      return {
        'Error': 'Error en la solicitud HTTP',
        'statusCode': respuesta.statusCode
      };
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return {'Error': 'Error de red o excepción', 'exception': error.toString()};
  }
}

Future<Map<String, dynamic>> getStudentCita() async {
  final url = Uri.parse('https://tutoapp.onrender.com/students/appointments');

  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');

  if (accessToken == null) {
    return {'Error': 'tokent'};
  }

  try {
    final respuesta = await http.get(url, headers: {'Auth': accessToken});

    if (respuesta.statusCode == 200) {
      Map<String, dynamic> datosRespuesta = {};
      if (respuesta.body.isNotEmpty) {
        datosRespuesta = jsonDecode(respuesta.body);
        //print('Los datos si llegaron');
        print(datosRespuesta);
      } else {
        //print('La respuesta tiene un cuerpo vacío');
        datosRespuesta = {'Status': 'Sin cita'};
      }
      return datosRespuesta;
    } else {
      // Manejar errores
      print('Error en la solicitud HTTP: ${respuesta.statusCode}');
      return {
        'Error': 'Error en la solicitud HTTP',
        'statusCode': respuesta.statusCode
      };
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return {'Error': 'Error de red o excepción', 'exception': error.toString()};
  }
}

Future<Map<String, dynamic>> createStudentCita(
    Map<String, dynamic> datosCita) async {
  final url = Uri.parse('https://tutoapp.onrender.com/students/appointments');

  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');

  if (accessToken == null) {
    return {'Error': 'tokent'};
  }

  try {
    final respuesta = await http.post(url,
        headers: {'Auth': accessToken}, body: jsonEncode(datosCita));

    if (respuesta.statusCode == 201 || respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);
      print(datosRespuesta);
      return datosRespuesta;
    } else {
      // Manejar errores
      print('Error en la solicitud HTTP: ${respuesta.statusCode}');
      return {
        'Error': 'Error en la solicitud HTTP',
        'statusCode': respuesta.statusCode
      };
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return {'error': 'Error de red o excepción', 'exception': error.toString()};
  }
}

Future<Map<String, dynamic>> cancelarStudentCita(
  int idCita,
) async {
  final url =
      Uri.parse('https://tutoapp.onrender.com/students/appointments/$idCita');
  print(url);
  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');
  Map<String, dynamic> datosCita = {"Status": "Cancelada"};

  if (accessToken == null) {
    return {'Error': 'tokent'};
  }

  try {
    final respuesta = await http.put(url,
        headers: {'Auth': accessToken}, body: jsonEncode(datosCita));

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);
      print(datosRespuesta);
      return datosRespuesta;
    } else {
      // Manejar errores
      Map<String, dynamic> body = jsonDecode(respuesta.body);
      if (body.containsKey('error')) {
        print('Error: ${respuesta.statusCode}: ${body['error']}');
      } else {
        print('Error: ${respuesta.statusCode}');
      }
      return {
        'Error': 'Error en la solicitud HTTP',
        'statusCode': respuesta.statusCode
      };
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return {'Error': 'Error de red o excepción', 'exception': error.toString()};
  }
}

Future<Map<String, dynamic>> eliminarImagenPerfil() async {
  final url = Uri.parse('https://tutoapp.onrender.com/users/profile-image');

  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');

  if (accessToken == null) {
    return {'Error': 'tokent'};
  }

  try {
    final respuesta = await http.delete(url, headers: {'Auth': accessToken});

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario

      return {'Success': 'Imagen borrada...'};
    } else {
      // Manejar errores
      Map<String, dynamic> body = jsonDecode(respuesta.body);
      if (body.containsKey('error')) {
        print('Error: ${respuesta.statusCode}: ${body['error']}');
      } else {
        print('Error: ${respuesta.statusCode}');
      }
      return {
        'Error': 'Error en la solicitud HTTP',
        'statusCode': respuesta.statusCode
      };
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return {'Error': 'Error de red o excepción', 'exception': error.toString()};
  }
}

Future<List<Map<String, dynamic>>> getTutorCita() async {
  final url = Uri.parse('https://tutoapp.onrender.com/tutors/appointments');

  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');

  if (accessToken == null) {
    return [
      {'Error': 'tokent'}
    ];
  }
  try {
    final respuesta = await http.get(url, headers: {'Auth': accessToken});

    if (respuesta.statusCode == 200) {
      List<dynamic> data = jsonDecode(respuesta.body);

      // Convertir la lista de dynamic a una lista de Map<String, dynamic>
      List<Map<String, dynamic>> dataConversion =
          List<Map<String, dynamic>>.from(data);

      return dataConversion;
    } else {
      print('Error en la solicitud HTTP: ${respuesta.statusCode}');
      return [
        {'Error': respuesta.body}
      ];
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return [
      {'error': 'Error de red o excepción', 'body': error.toString()}
    ];
  }
}

Future<Map<String, dynamic>> updateTutorCita(
    Map<String, dynamic> datosCita, int idCita) async {
  final url =
      Uri.parse('https://tutoapp.onrender.com/tutors/appointments/$idCita');

  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');

  if (accessToken == null) {
    return {'Error': 'tokent'};
  }

  try {
    final respuesta = await http.put(url,
        headers: {'Auth': accessToken}, body: jsonEncode(datosCita));

    if (respuesta.statusCode == 200) {
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);
      return datosRespuesta;
    } else {
      // Manejar errores
      print('Error en la solicitud HTTP: ${respuesta.statusCode}');
      return {
        'Error': respuesta.body,
      };
    }
  } catch (error) {
    print('Error: $error');
    return {'Error': 'Error ${error.toString()}'};
  }
}

Future<Map<String, dynamic>> denegateTutorCita(
    int idCita, String datetime, int place, String comment) async {
  final url =
      Uri.parse('https://tutoapp.onrender.com/tutors/appointments/$idCita');

  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');
  Map<String, dynamic> datosCita = {
    "Status": "Cancelada",
  };

  if (accessToken == null) {
    return {'Error': 'tokent'};
  }

  try {
    final respuesta = await http.post(url,
        headers: {'Auth': accessToken}, body: jsonEncode(datosCita));

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);
      print(datosRespuesta);
      return datosRespuesta;
    } else {
      // Manejar errores
      print('Error en la solicitud HTTP: ${respuesta.statusCode}');
      return {
        'Error': 'Error en la solicitud HTTP',
        'statusCode': respuesta.statusCode
      };
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return {'Error': 'Error de red o excepción', 'exception': error.toString()};
  }
}

Future<List<Map<String, dynamic>>> getCategorias() async {
  final url = Uri.parse('https://tutoapp.onrender.com/categories');

  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');

  if (accessToken == null) {
    return [
      {'Error': 'tokent'}
    ];
  }

  try {
    final respuesta = await http.get(url, headers: {'Auth': accessToken});

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario
      List<Map<String, dynamic>> datosRespuesta = jsonDecode(respuesta.body);
      print('Las categorias llegaron si llegaron $datosRespuesta');
      return datosRespuesta.cast<Map<String, dynamic>>();
    } else {
      // Manejar errores
      print('Error en la solicitud HTTP: ${respuesta.statusCode}');
      return [
        {
          'error': 'Error en la solicitud HTTP',
          'statusCode': respuesta.statusCode
        }
      ];
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return [
      {'Error': 'Error de red o excepción', 'exception': error.toString()}
    ];
  }
}

Future<void> deleteAccessToken() async {
  final storage = FlutterSecureStorage();

  // Eliminar el token almacenado
  await storage.delete(key: 'access_token');

  print('Token eliminado');
}

Future<List<Map<String, dynamic>>> getCosas(String term) async {
  final url = Uri.parse('https://tutoapp.onrender.com/$term');

  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');

  if (accessToken == null) {
    return [
      {'Error': 'tokent'}
    ];
  }

  try {
    final respuesta = await http.get(url, headers: {'Auth': accessToken});

    if (respuesta.statusCode == 200) {
      List<dynamic> datosRespuesta = jsonDecode(respuesta.body);

      return datosRespuesta.cast<Map<String, dynamic>>();
    } else {
      // Manejar errores
      print('Error en la solicitud HTTP: ${respuesta.statusCode}');
      return [
        {
          'error': 'Error en la solicitud HTTP',
          'statusCode': respuesta.statusCode
        }
      ];
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return [
      {'Error': 'Error de red o excepción', 'exception': error.toString()}
    ];
  }
}

Future<String> cambiarC(String cActual, String cNueva) async {
  final url = Uri.parse('https://tutoapp.onrender.com/users/password/verify');
  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');
  if (accessToken == null) {
    return 'Error: tokent';
  }
  Map<String, dynamic> datosBody = {"Password": cActual, "NewPassword": cNueva};
  try {
    final respuesta = await http.put(
      url,
      headers: {'Auth': accessToken},
      body: jsonEncode(datosBody),
    );

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);

      return datosRespuesta["message"];
    } else {
      // Manejar errores
      print('Error en la solicitud HTTP: ${respuesta.statusCode}');
      return 'Error en la solicitud HTTP ${respuesta.statusCode}';
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return 'Error de red o excepción $error';
  }
}

Future<String> sendSug(String contenido) async {
  final url = Uri.parse('https://tutoapp.onrender.com/suggestions');
  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');
  if (accessToken == null) {
    return 'Error: tokent';
  }
  Map<String, dynamic> datosBody = {"Content": contenido};
  try {
    final respuesta = await http.post(
      url,
      headers: {'Auth': accessToken},
      body: jsonEncode(datosBody),
    );

    if (respuesta.statusCode == 201) {
      // Procesar la respuesta si es necesario
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);

      return datosRespuesta["message"];
    } else {
      // Manejar errores
      print('Error en la solicitud HTTP: ${respuesta.statusCode}');
      return 'Error en la solicitud HTTP ${respuesta.statusCode}';
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return 'Error de red o excepción $error';
  }
}

Future<String> verifyUser(String mail, String token) async {
  final url = Uri.parse('https://tutoapp.onrender.com/students/verify');
  // Datos del estudiante
  print(mail);
  print(token);
  Map<String, dynamic> datosEstudiante = {
    "Mail": mail,
    "Token": token,
  };

  try {
    final respuesta = await http.post(
      url,
      body: jsonEncode(datosEstudiante),
    );

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);
      print(datosRespuesta);
      //print('Si entro(logeado): ${datosRespuesta["user_type"]}');
      return datosRespuesta["message"];
    } else {
      // Manejar errores
      return 'Error: ${respuesta.statusCode} | ${respuesta.body}';
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return 'Error: $error';
  }
}

Future<String> ChangePassword(
    String mail, String token, String password) async {
  final url = Uri.parse('https://tutoapp.onrender.com/forgot-password/verify');
  // Datos del estudiante
  print(mail);
  print(token);
  print(password);
  Map<String, dynamic> datosEstudiante = {
    "Mail": mail,
    "Token": token,
    "Password": password,
  };

  try {
    final respuesta = await http.put(
      url,
      body: jsonEncode(datosEstudiante),
    );

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);
      print(datosRespuesta);
      //print('Si entro(logeado): ${datosRespuesta["user_type"]}');
      return datosRespuesta["message"];
    } else {
      // Manejar errores
      return 'Error: ${respuesta.statusCode} | ${respuesta.body}';
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return 'Error: $error';
  }
}

Future<Map<String, dynamic>> updateProfileImg(String img64) async {
  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');

  if (accessToken == null) {
    return {'Error': 'tokent'};
  }

  Map<String, dynamic> datosCita = {"Image": img64};
  final url = Uri.parse('https://tutoapp.onrender.com/users/profile-image');
  try {
    final respuesta = await http.put(url,
        headers: {'Auth': accessToken}, body: jsonEncode(datosCita));

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);
      print(datosRespuesta);
      return datosRespuesta;
    } else {
      // Manejar errores
      print('Error en la solicitud HTTP: ${respuesta.statusCode}');
      return {
        'Error': 'Error en la solicitud HTTP',
        'statusCode': respuesta.statusCode,
        'message': respuesta.body
      };
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return {'error': 'Error de red o excepción', 'message': error.toString()};
  }
}

Future<Map<String, dynamic>> getProfileImg(bool isTutor) async {
  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');

  if (accessToken == null) {
    return {'Error': 'tokent'};
  }
  String estutor = '';
  if (isTutor) {
    estutor = 'tutor';
  } else {
    estutor = 'student';
  }
  //Map<String, dynamic> datosCita = {"Image": img64};
  final url = Uri.parse('https://tutoapp.onrender.com/$estutor/profile-image');
  try {
    final respuesta = await http.get(url, headers: {'Auth': accessToken});

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario
      Map<String, dynamic> datosRespuesta = {};
      if (!respuesta.body.contains('message')) {
        datosRespuesta["Image"] = respuesta.body;
      } else {
        datosRespuesta = jsonDecode(respuesta.body);
      }
      return datosRespuesta;
    } else {
      // Manejar errores
      print('Error en la solicitud HTTP: ${respuesta.statusCode}');
      return {
        'Error': 'Error en la solicitud HTTP',
        'statusCode': respuesta.statusCode,
        'message': respuesta.body
      };
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return {'error': 'Error de red o excepción', 'message': error.toString()};
  }
}
