import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tp7_test/entities/classe.dart';
import 'package:tp7_test/entities/departement.dart';
import 'package:tp7_test/service/classeservice.dart';
import 'package:tp7_test/service/departementservice.dart';

class ClassDialog extends StatefulWidget {
  final Function()? notifyParent;
  Classe? classe;
  Departement? departement;

  ClassDialog(
      {super.key, @required this.notifyParent, this.classe, this.departement});
  @override
  State<ClassDialog> createState() => _ClassDialogState();
}

class _ClassDialogState extends State<ClassDialog> {
  List<Departement> departements = [];
  Departement? selectedDepartement;
  TextEditingController nomCtrl = TextEditingController();

  TextEditingController nbrCtrl = TextEditingController();

  String title = "Ajouter Classe";
  String action = "Ajouter";
  bool modif = false;

  late int idClasse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // print(widget.departement!.toJson());

    if (widget.classe != null) {
      modif = true;
      title = "Modifier Classe";
      action = "Modifier";
      nomCtrl.text = widget.classe!.nomClass;
      nbrCtrl.text = (widget.classe!.nbreEtud).toString();
      idClasse = widget.classe!.codClass!;
    }
    getAlldepartementss();
  }
// Future<void> _loadClasses() async {
//     List<dynamic> result = await getAllClasses();
//     setState(() {
//       print("get all classes");
//       print(result);

//       // foreach
//       result.forEach((element) {
//         classes.add(Classe(
//             element['nbreEtud'], element['nomClass'], element['codClass']));
//       });
//     });
//     if (widget.student != null) {
//       print("student classe");
//       classes.forEach((element) {
//         if (element.codClass == widget.student!.classe!.codClass) {
//           selectedClasse = element;
//         }
//       });
//     } else if (widget.currentClasse != null) {
//       print("current classe");
//       print(widget.currentClasse);
//       classes.forEach((element) {
//         if (element.codClass == widget.currentClasse!.codClass) {
//           selectedClasse = element;
//         }
//       });
//     } else {
//       print("first classe");
//       selectedClasse = classes[0];
//     }
//   }

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

    if (widget.departement != null) {
      print("widget.departement");
      print(widget.departement);
      departements.forEach((element) {
        if (element.code == widget.departement!.code) {
          selectedDepartement = element;
        }
      });
    } else if (widget.classe != null) {
      print("widget.classe");
      print(widget.classe);
      departements.forEach((element) {
        if (element.code == widget.classe!.departement!.code) {
          selectedDepartement = element;
        }
      });
    } else {
      print("first departement");
      selectedDepartement = departements[0];
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
              decoration: const InputDecoration(labelText: "nom"),
            ),
            TextFormField(
              controller: nbrCtrl,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Champs est obligatoire";
                }
                return null;
              },
              decoration:
                  const InputDecoration(labelText: "Nombre des etudiants"),
            ),
            DropdownButton<Departement>(
              hint: const Text("Choisir un département"),
              value: selectedDepartement,
              onChanged: (Departement? value) {
                setState(() {
                  selectedDepartement = value;
                  // nomDepartement =
                  //     "département ${selectedDepartement!.nomDepartement}";
                  // getAllClassess();
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
            ElevatedButton(
                onPressed: () async {
                  if (modif == false) {
                    Classe c = Classe(int.parse(nbrCtrl.text), nomCtrl.text);
                    c.setDepartement(selectedDepartement!);
                    print(selectedDepartement!.nomDepartement);

                    print(c.departement!.nomDepartement);
                    print(c.toJson());
                    await addClass(c);
                    widget.notifyParent!();
                  } else {
                    Classe c =
                        Classe(int.parse(nbrCtrl.text), nomCtrl.text, idClasse);
                    c.setDepartement(selectedDepartement!);
                    print(c.toJson());
                    await updateClasse(c);
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
