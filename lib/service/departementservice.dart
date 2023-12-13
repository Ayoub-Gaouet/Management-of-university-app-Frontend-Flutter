import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:tp7_test/entities/departement.dart';

Future getAlldepartements() async {
  Response response =
      await http.get(Uri.parse("http://10.0.2.2:8081/departement/all"));
  print("departements");
  print(response.body);
  return jsonDecode(response.body);
}

Future deletedepartement(int id) {
  return http
      .delete(Uri.parse("http://10.0.2.2:8081/departement/delete?id=${id}"));
}

Future adddepartement(Departement departement) async {
  Response response = await http.post(
      Uri.parse("http://10.0.2.2:8081/departement/add"),
      headers: {"Content-type": "Application/json"},
      body: jsonEncode(
          <String, dynamic>{"nomDepartement": departement.nomDepartement}));

  return response.body;
}

Future updatedepartemente(Departement departement) async {
  Response response =
      await http.put(Uri.parse("http://10.0.2.2:8081/departement/update"),
          headers: {"Content-type": "Application/json"},
          body: jsonEncode(<String, dynamic>{
            "code": departement.code,
            "nomDepartement": departement.nomDepartement,
          }));

  return response.body;
}
