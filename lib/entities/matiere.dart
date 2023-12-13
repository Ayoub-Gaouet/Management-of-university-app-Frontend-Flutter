import 'package:tp7_test/entities/classe.dart';

class Matiere {
  int? code;
  String? nom;
  int? coef;
  int? nbHeures;
  Classe? classe;

  Matiere({this.code, this.nom, this.coef, this.nbHeures, this.classe});

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'nom': nom,
      'coef': coef,
      'nbHeures': nbHeures,
      'classe': classe?.toJson(),
    };
  }
  factory Matiere.fromJson(Map<String, dynamic> json) {
    return Matiere(
      code: json['code'] as int,
      nom: json['nom'] as String,
      coef: json['coef'] as int,
      nbHeures: json['nbHeures'] as int,
      classe: Classe.fromJson(json['classe']),
    );
  }
}
