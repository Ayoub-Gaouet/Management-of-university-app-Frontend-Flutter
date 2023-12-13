import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../entities/absence.dart';
import '../entities/matiere.dart';
import '../entities/student.dart';
import 'DetailsAbsenceScreen.dart';
class AbsenceScreen extends StatefulWidget {
  @override
  _AbsenceScreenState createState() => _AbsenceScreenState();
}

class _AbsenceScreenState extends State<AbsenceScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Student> students = [];
  Absence? _selectedAbsence; // Add this line

  Student? _selectedStudent;
  List<Absence> absences = [];
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _classeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }
  void _updateStudentInfo(Student student) {
    // Update the controllers with the selected student's information
    _nomController.text = student.nom;
    _prenomController.text = student.prenom;
    _classeController.text = student.classe!.nomClass;
    // Fetch absences for the selected student
    if (student.id != null) {
      _fetchAbsences(student.id!);
    }
  }
  Future<void> _fetchStudents() async {
    var response = await http.get(Uri.parse('http://10.0.2.2:8081/etudiant/all'));
    if (response.statusCode == 200) {
      List<dynamic> studentsJson = json.decode(response.body);
      setState(() {
        students = studentsJson.map((json) => Student.fromJson(json)).toList();
      });
    } else {
      // Handle error
    }
  }
  Future<List<Matiere>> _fetchMatieresForClass(String id) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8081/matiere/findByClasseId/$id'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Matiere> matieres = body.map((dynamic item) => Matiere.fromJson(item)).toList();
      return matieres;
    } else {
      throw Exception('Failed to load matieres');
    }
  }
  Future<void> _fetchAbsences(int studentId) async {
    var response = await http.get(Uri.parse('http://10.0.2.2:8081/absences/getByStudent/$studentId'));
    if (response.statusCode == 200) {
      List<dynamic> absencesJson = json.decode(response.body);
      setState(() {
        absences = absencesJson.map((json) => Absence.fromJson(json)).toList();
      });
    } else {
      // Handle error
    }
  }
  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _nomController.dispose();
    _prenomController.dispose();
    _classeController.dispose();
    super.dispose();
  }
  Future<void> _deleteAbsence(Absence absence) async {
    var response = await http.delete(Uri.parse('http://10.0.2.2:8081/absences/delete?id=${absence.id}'));
    if (response.statusCode == 200) {
      setState(() {
        absences.removeWhere((a) => a.id == absence.id);
      });
    } else {
      // Handle error
    }
  }


  DataRow _buildRow(Absence absence) {
    return DataRow(
      onSelectChanged: (bool? selected) {
        if (selected != null && selected) {
          _selectedAbsence = absence; // Store the selected absence
          // You can show a dialog here to confirm deletion
        }
      },
      cells: [
        DataCell(Text(absence.date)),
        DataCell(Text(absence.codeMatiere)),
        DataCell(Text(absence.nha.toString())),
      ],
    );
  }
  Future<void> _showAddAbsenceDialog() async {
    // Initialize variables for the dialog
    Matiere? _selectedMatiere;
    DateTime _selectedDate = DateTime.now();
    TextEditingController _nhaController = TextEditingController();

    // Fetch matières for the selected student's class
    // You need to implement this function based on your backend API
    List<Matiere> matieres = await _fetchMatieresForClass(_selectedStudent!.classe!.codClass?.toString() ?? '');

    // Show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter une absence'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // Dropdown for Matière
                DropdownButtonFormField<Matiere>(
                  value: _selectedMatiere,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedMatiere = newValue!;
                    });
                  },
                  items: matieres.map<DropdownMenuItem<Matiere>>((Matiere matiere) {
                    return DropdownMenuItem<Matiere>(
                      value: matiere,
                      child: Text(matiere.nom!),
                    );
                  }).toList(),
                ),
                // Date Picker
                ListTile(
                  title: Text("Date d'absence: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}"),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2025),
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                ),
                // TextField for NHA
                TextField(
                  controller: _nhaController,
                  decoration: InputDecoration(labelText: 'Nombre d\'heures d\'absence (NHA)'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ajouter'),
              onPressed: () {
                // Handle the form submission
                _addAbsence(_selectedStudent!.id!, _selectedMatiere!.code!, _selectedDate, int.parse(_nhaController.text));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _addAbsence(int studentId, int matiereId, DateTime date, int nha) async {
    // Log the data to console for debugging
    print('Student ID: $studentId');
    print('Matiere ID: $matiereId');
    print('Date: ${DateFormat('yyyy-MM-dd').format(date)}');
    print('NHA: $nha');

    // Create the absence JSON
    var absenceData = {
      'etudiant': {'id': studentId},
      'matiere': {'code': matiereId},
      'date': DateFormat('yyyy-MM-dd').format(date),
      'nha': nha,
    };

    print('Absence Data: $absenceData'); // Log the absence data

    // Send a POST request to your backend
    var response = await http.post(
      Uri.parse('http://10.0.2.2:8081/absences/add'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(absenceData),
    );

    // Log the HTTP response for debugging
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // Handle the response
    if (response.statusCode == 200) {
      // Absence added successfully, update your UI accordingly
      _fetchAbsences(studentId); // Refresh the list of absences
    } else {
      // Handle error
      // You could show an error message to the user here
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saisie des absences pour un étudiant'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            DropdownButtonFormField<Student>(
              value: _selectedStudent,
              hint: Text('Sélectionner un étudiant'),
              onChanged: (newValue) {
                setState(() {
                  _selectedStudent = newValue!;
                  _updateStudentInfo(_selectedStudent!);
                });
              },
              items: students.map<DropdownMenuItem<Student>>((Student student) {
                return DropdownMenuItem<Student>(
                  value: student,
                  child: Text('${student.nom} ${student.prenom}'),
                );
              }).toList(),
            ),
            TextFormField(
              controller: _nomController,
              decoration: InputDecoration(labelText: 'Nom de l\'étudiant:'),
              readOnly: true, // As this is just for display
            ),
            TextFormField(
              controller: _prenomController,
              decoration: InputDecoration(labelText: 'Prénom:'),
              readOnly: true, // As this is just for display
            ),
            TextFormField(
              controller: _classeController,
              decoration: InputDecoration(labelText: 'Classe:'),
              readOnly: true, // As this is just for display
            ),
            SizedBox(height: 20),
            Text('Liste des absences'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Code m')),
                  DataColumn(label: Text('NHA *')),
                ],
                rows: absences.map((absence) => _buildRow(absence)).toList(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Insérer'),
              onPressed: () {
                if (_selectedStudent != null) {
                  _showAddAbsenceDialog();
                } else {
                  // Inform the user to select a student first
                }
              },
            ),

            ElevatedButton(
              child: Text('Supprimer'),
              onPressed: () {
                if (_selectedAbsence != null) {
                  _deleteAbsence(_selectedAbsence!); // Use the '!' operator to assert that the value is not null
                } else {
                  // You can show an alert dialog or a snackbar here to inform the user to select an absence first
                  print("No absence selected"); // Or handle this case as needed
                }
              },
            ),
            ElevatedButton(
              child: Text('Détails'),
              onPressed: () {
                if (_selectedStudent != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailsAbsenceScreen(
                        student: _selectedStudent!,
                        absences: absences,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Veuillez sélectionner un étudiant.'),
                    ),
                  );
                }
              },
            ),

          ],
        ),
      ),
    );
  }
}