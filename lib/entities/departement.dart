class Departement {
  String nomDepartement;
  int? code;

  Departement(this.nomDepartement, [this.code]);
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'nomDepartement': nomDepartement,
    };
  }
}
