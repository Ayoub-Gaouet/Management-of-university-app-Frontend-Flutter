import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:tp7_test/entities/classe.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tp7_test/entities/classe.dart';

class ClasseService {
  static const String url = 'http://10.0.2.2:8081/class';

  Future<List<Classe>> getAllClasses() async {
    final response = await http.get(Uri.parse('$url/all'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Classe> classes = body.map((dynamic item) => Classe.fromJson(item)).toList();
      return classes;
    } else {
      throw Exception('Failed to load classes');
    }
  }
}
Future getAllClasses() async {
  Response response =
      await http.get(Uri.parse("http://10.0.2.2:8081/class/all"));
  return jsonDecode(response.body);
}

Future deleteClass(int id) {
  return http.delete(Uri.parse("http://10.0.2.2:8081/class/delete?id=${id}"));
}

Future addClass(Classe classe) async {
  Response response =
      await http.post(Uri.parse("http://10.0.2.2:8081/class/add"),
          headers: {"Content-type": "Application/json"},
          body: jsonEncode(<String, dynamic>{
            "nomClass": classe.nomClass,
            "nbreEtud": classe.nbreEtud,
            "departement": classe.departement!.toJson()
          }));

  return response.body;
}

Future updateClasse(Classe classe) async {
  Response response =
      await http.put(Uri.parse("http://10.0.2.2:8081/class/update"),
          headers: {"Content-type": "Application/json"},
          body: jsonEncode(<String, dynamic>{
            "codClass": classe.codClass,
            "nomClass": classe.nomClass,
            "nbreEtud": classe.nbreEtud,
            "departement": classe.departement!.toJson()
          }));

  return response.body;
}

Future getClassesByDepartementId(int? id) async {
  Response response =
      await http.get(Uri.parse("http://10.0.2.2:8081/class/findByDepId/${id}"));
  return jsonDecode(response.body);
}
