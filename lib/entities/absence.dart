class Absence {
  String date;
  String codeMatiere;
  int nha;
  int id;  // Add this line

  Absence({required this.date, required this.codeMatiere, required this.nha, required this.id});  // Modify this line

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      date: json['date'],
      codeMatiere: json['matiere']['nom'],
      nha: json['nha'],
      id: json['id'],  // Assuming JSON has an 'id' field
    );
  }
}
