import 'package:tp7_test/entities/classe.dart';

class Student {
  String dateNais, nom, prenom;
  int? id;
  Classe? classe;

  Student(this.dateNais, this.nom, this.prenom, this.classe, [this.id]);

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      json['dateNais'] as String,
      json['nom'] as String,
      json['prenom'] as String,
      Classe.fromJson(json['classe'] as Map<String, dynamic>),
      json['id'] as int,
    );
  }
}

