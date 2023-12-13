import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tp7_test/entities/classe.dart';
import 'package:tp7_test/entities/departement.dart';
import 'package:tp7_test/entities/student.dart';
import 'package:tp7_test/service/classeservice.dart';
import 'package:tp7_test/service/studentservice.dart';

class AddStudentDialog extends StatefulWidget {
  final Function()? notifyParent;
  final Student? student;
  final Classe? currentClasse;

  AddStudentDialog(
      {Key? key, @required this.notifyParent, this.student, this.currentClasse})
      : super(key: key);

  @override
  State<AddStudentDialog> createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<AddStudentDialog> {
  TextEditingController nomCtrl = TextEditingController();
  TextEditingController prenomCtrl = TextEditingController();
  TextEditingController dateCtrl = TextEditingController();
  List<Classe> classes = [];
  DateTime selectedDate = DateTime.now();
  Classe selectedClasse = Classe(0, "");
  String title = "Ajouter Etudiant";
  String action = "Ajouter";
  bool modif = false;
  late int idStudent;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        dateCtrl.text =
            DateFormat("yyyy-MM-dd").format(DateTime.parse(picked.toString()));
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _loadClasses();

    if (widget.student != null) {
      print("modification");
      modif = true;
      action = "Modifier";
      title = "Modifier Etudiant";
      nomCtrl.text = widget.student!.nom;
      prenomCtrl.text = widget.student!.prenom;
      dateCtrl.text = DateFormat("yyyy-MM-dd")
          .format(DateTime.parse(widget.student!.dateNais.toString()));

      idStudent = widget.student!.id!;
      // Set selectedClasse based on the student's class
      selectedClasse = widget.student!.classe!;
    }
  }

  Future<void> _loadClasses() async {
    List<dynamic> result = await getAllClasses();
    setState(() {
      print("get all classes");
      print(result);

      // foreach
      result.forEach((element) {
        classes.add(Classe(
            element['nbreEtud'], element['nomClass'], element['codClass']));
      });
    });
    if (widget.student != null) {
      print("student classe");
      classes.forEach((element) {
        if (element.codClass == widget.student!.classe!.codClass) {
          selectedClasse = element;
        }
      });
    } else if (widget.currentClasse != null) {
      print("current classe");
      print(widget.currentClasse);
      classes.forEach((element) {
        if (element.codClass == widget.currentClasse!.codClass) {
          selectedClasse = element;
        }
      });
    } else {
      print("first classe");
      selectedClasse = classes[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(title),
            TextFormField(
              controller: nomCtrl,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Champs est obligatoire";
                }
                return null;
              },
              decoration: const InputDecoration(labelText: "Nom"),
            ),
            TextFormField(
              controller: prenomCtrl,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Champs est obligatoire";
                }
                return null;
              },
              decoration: const InputDecoration(labelText: "Prénom"),
            ),
            TextFormField(
              controller: dateCtrl,
              readOnly: true,
              decoration: const InputDecoration(labelText: "Date de naissance"),
              onTap: () {
                _selectDate(context);
              },
            ),
            DropdownButton<Classe>(
              hint: const Text("Choisir une classe"),
              value: selectedClasse,
              onChanged: (Classe? value) {
                setState(() {
                  selectedClasse = value!;
                  print(selectedClasse.nomClass);
                });
              },
              items: classes.map((classe) {
                return DropdownMenuItem<Classe>(
                  value: classe,
                  child: Text(classe.nomClass),
                );
              }).toList(),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (modif == false) {
                    print(selectedClasse.nomClass +
                        " " +
                        selectedDate.toString());
                    Student s = Student(
                      selectedDate.toString(),
                      nomCtrl.text,
                      prenomCtrl.text,
                      selectedClasse,
                    );
                    print(s.classe!.nomClass);
                    await addStudent(s);
                    widget.notifyParent!();
                  } else {
                    await updateStudent(Student(
                      selectedDate.toString(),
                      nomCtrl.text,
                      prenomCtrl.text,
                      selectedClasse,
                      idStudent,
                    ));
                    widget.notifyParent!();
                  }
                },
                child: Text(action))
          ],
        ),
      ),
    );
  }
}
