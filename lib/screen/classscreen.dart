import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tp7_test/entities/departement.dart';
import 'package:tp7_test/screen/studentsscreen.dart';
import 'package:tp7_test/service/classeservice.dart';
import 'package:tp7_test/service/departementservice.dart';
import 'package:tp7_test/template/dialog/classedialog.dart';
import 'package:tp7_test/template/navbar.dart';

import '../entities/classe.dart';

class ClasseScreen extends StatefulWidget {
  @override
  _ClasseScreenState createState() => _ClasseScreenState();
}

class _ClasseScreenState extends State<ClasseScreen> {
  String nomDepartement = "toutes les classes";
  List<Departement> departements = [];
  Departement? selectedDepartement;
  refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getAlldepartementss();
  }

  Future<void> getAlldepartementss() async {
    List<dynamic> result = await getAlldepartements();
    setState(() {
      print("get all departements");
      print(result);

      result.forEach((element) {
        departements
            .add(Departement(element['nomDepartement'], element['code']));
      });
    });
  }

  // Future<void> getStudentList() async {
  //   if (selectedClass != null) {
  //     return getStudentsByClasseId(selectedClass!.codClass);
  //   } else if (widget.classe != null) {
  //     return getStudentsByClasseId(widget.classe!.codClass);
  //   } else {
  //     return getAllStudent();
  //   }
  // }
  Future<void> getAllClassess() async {
    if (selectedDepartement != null) {
      return getClassesByDepartementId(selectedDepartement!.code);
    } else {
      return getAllClasses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar('classes'),
      body: Column(
        children: [
          DropdownButton<Departement>(
            hint: const Text("Choisir un département"),
            value: selectedDepartement,
            onChanged: (Departement? value) {
              setState(() {
                selectedDepartement = value;
                nomDepartement =
                    "département ${selectedDepartement!.nomDepartement}";
                getAllClassess();
              });
            },
            items: departements.map((dep) {
              print("dep");
              print(dep);
              return DropdownMenuItem<Departement>(
                value: dep,
                child: Text(dep.nomDepartement),
              );
            }).toList(),
          ),
          Expanded(
            child: FutureBuilder(
              future: getAllClassess(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                  return Center(
                    child: Text(
                      "Aucune classe trouvée",
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      print(index);
                      print(snapshot.data[index]);
                      return Slidable(
                        key: Key((snapshot.data[index]['codClass']).toString()),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ClassDialog(
                                        notifyParent: refresh,
                                        classe: Classe(
                                          snapshot.data[index]['nbreEtud'],
                                          snapshot.data[index]['nomClass'],
                                          snapshot.data[index]['codClass'],
                                        ),
                                        departement: Departement(
                                          snapshot.data[index]['departement']
                                              ['nomDepartement'],
                                          snapshot.data[index]['departement']
                                              ['code'],
                                        ),
                                      );
                                    });
                                //print("test");
                              },
                              backgroundColor: Color(0xFF21B7CA),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          dismissible: DismissiblePane(onDismissed: () async {
                            await deleteClass(snapshot.data[index]['codClass']);
                            setState(() {
                              snapshot.data.removeAt(index);
                            });
                          }),
                          children: [Container()],
                        ),
                        child: InkWell(
                          onTap: () {
                            // Navigate to the list of students for the selected class
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentScreen(
                                  classe: Classe(
                                    snapshot.data[index]['nbreEtud'],
                                    snapshot.data[index]['nomClass'],
                                    snapshot.data[index]['codClass'],
                                    // snapshot.data[index]['departement']
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text("Classe : "),
                                        Text(
                                          snapshot.data[index]['nomClass'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 2.0,
                                        ),
                                      ],
                                    ),
                                    Text(
                                        "Nombre etudiants : ${snapshot.data[index]['nbreEtud']}"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: const CircularProgressIndicator());
                }
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ClassDialog(
                  notifyParent: refresh,
                );
              });
          //print("test");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
