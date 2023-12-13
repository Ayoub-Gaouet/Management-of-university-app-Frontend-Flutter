
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:tp7_test/entities/classe.dart';
import 'package:tp7_test/entities/student.dart';
import 'package:tp7_test/service/classeservice.dart';
import 'package:tp7_test/service/studentservice.dart';
import 'package:tp7_test/template/navbar.dart';
import '../template/dialog/studentdialog.dart';

class StudentScreen extends StatefulWidget {
  final Classe? classe;

  const StudentScreen({Key? key, this.classe}) : super(key: key);

  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  String nomClasse = "tous les étudiants";
  List<Classe> classes = [];
  Classe? selectedClass;
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    if (widget.classe != null) {
      selectedClass = widget.classe;
      nomClasse = "étudiants ${widget.classe!.nomClass}";
    }

    List<dynamic> result = await getAllClasses();
    setState(() {
      classes.clear();
      for (var element in result) {
        classes.add(Classe(element['nbreEtud'], element['nomClass'], element['codClass']));
      }
      if (widget.classe == null && classes.isNotEmpty) {
        selectedClass = classes[0];
        nomClasse = "étudiants ${selectedClass!.nomClass}";
      }
    });
    getStudentList();
  }

  Future<void> getStudentList() async {
    List<dynamic> studentData = selectedClass != null
        ? await getStudentsByClasseId(selectedClass!.codClass)
        : await getAllStudent();

    setState(() {
      students.clear();
      for (var element in studentData) {
        students.add(Student(
          element['dateNais'],
          element['nom'],
          element['prenom'],
          Classe(element['classe']['nbreEtud'], element['classe']['nomClass'], element['classe']['codClass']),
          element['id'],
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nomClasse),
      ),
      body: Column(
        children: [
          DropdownButton<Classe>(
            hint: const Text("Choisir une classe"),
            value: selectedClass,
            onChanged: (Classe? value) {
              setState(() {
                selectedClass = value;
                nomClasse = "étudiants ${selectedClass!.nomClass}";
                getStudentList();
              });
            },
            items: classes.map((classe) {
              return DropdownMenuItem<Classe>(
                value: classe,
                child: Text(classe.nomClass),
              );
            }).toList(),
          ),
          Expanded(
            child: students.isEmpty
                ? const Center(child: Text("Aucun étudiant trouvé"))
                : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: students.length,
              itemBuilder: (BuildContext context, int index) {
                Student student = students[index];
                return _buildStudentListItem(student);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddStudentDialog(
                  notifyParent: getStudentList,
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  Widget _buildStudentListItem(Student student) {
    return Slidable(
      key: Key(student.id.toString()),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              if (student.id == null) {
                // Handle the case where student.id is null
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Student ID is missing. Cannot delete.')),
                );
                return;
              }

              AlertDialog alert = AlertDialog(
                title: Text("Supprimer"),
                content: Text("Voulez-vous supprimer cet étudiant ?"),
                actions: [
                  TextButton(
                    child: Text("Oui"),
                    onPressed: () async {
                      await deleteStudent(student.id!); // Using ! to assert that id is not null
                      getStudentList(); // refresh the list
                      Navigator.of(context).pop(); // close the dialog
                    },
                  ),
                  TextButton(
                    child: Text("Non"),
                    onPressed: () {
                      Navigator.of(context).pop(); // close the dialog
                    },
                  ),
                ],
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
            backgroundColor: Color.fromARGB(255, 202, 33, 33),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'delete',
            spacing: 1,
          ),
        ],
      ),
      child: ListTile(
        title: Text("Nom et Prénom: ${student.nom} ${student.prenom}"),
        subtitle: Text(
          'Date de Naissance: ${DateFormat("dd-MM-yyyy").format(DateTime.parse(student.dateNais))}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddStudentDialog(
                  notifyParent: getStudentList,
                  student: student,
                );
              },
            );
          },
        ),
      ),
    );
  }

}
