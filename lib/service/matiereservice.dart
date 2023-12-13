import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tp7_test/entities/matiere.dart';
import 'package:http/http.dart' as http;
class MatiereService {
  static const String url = 'http://10.0.2.2:8081/matiere';
  Future<List<Matiere>> getAllMatieres() async {
    final response = await http.get(Uri.parse('$url/all'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Matiere> matieres = body.map((dynamic item) => Matiere.fromJson(item)).toList();
      return matieres;
    } else {
      throw Exception('Failed to load matieres');
    }
  }
  Future<void> deleteMatiere(int id) async {
    final response = await http.delete(Uri.parse('$url/delete?id=$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete matiere');
    }
  }
  Future<List<Matiere>> getMatieresByClasseId(int id) async {
    final response = await http.get(Uri.parse('$url/findByClasseId/$id'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Matiere> matieres = body.map((dynamic item) => Matiere.fromJson(item)).toList();
      return matieres;
    } else {
      throw Exception('Failed to load matieres');
    }
  }
  Future<Matiere> addMatiere(Matiere matiere) async {
    final response = await http.post(
      Uri.parse('$url/add'),
      headers: {"Content-type": "Application/json"},
      body: jsonEncode(matiere),
    );
    if (response.statusCode == 200) {
      return Matiere.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add matiere');
    }
  }
  Future<Matiere> updateMatiere(Matiere matiere) async {
    final response = await http.put(
      Uri.parse('$url/update'),
      headers: {"Content-type": "Application/json"},
      body: jsonEncode(matiere),
    );
    if (response.statusCode == 200) {
      return Matiere.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update matiere');
    }
  }
}