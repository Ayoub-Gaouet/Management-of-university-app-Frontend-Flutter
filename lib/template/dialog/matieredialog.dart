import 'package:flutter/material.dart';
import 'package:tp7_test/entities/matiere.dart';
import 'package:tp7_test/entities/classe.dart';
import 'package:tp7_test/service/matiereservice.dart';
import 'package:tp7_test/service/classeservice.dart';

class addMatieredialog extends StatefulWidget {
  final Matiere? matiere;
  addMatieredialog({this.matiere});

  @override
  _addMatieredialogState createState() => _addMatieredialogState();
}

class _addMatieredialogState extends State<addMatieredialog> {
  final _formKey = GlobalKey<FormState>();
  final MatiereService matiereService = MatiereService();
  final ClasseService classeService = ClasseService();
  List<Classe>? classes;
  Classe? selectedClasse;
  TextEditingController nomController = TextEditingController();
  TextEditingController coefController = TextEditingController();
  TextEditingController nbHeuresController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchClasses();
    if (widget.matiere != null) {
      nomController.text = widget.matiere!.nom!;
      coefController.text = widget.matiere!.coef.toString();
      nbHeuresController.text = widget.matiere!.nbHeures.toString();
      selectedClasse = widget.matiere!.classe;
    }
  }

  fetchClasses() async {
    classes = await classeService.getAllClasses();
    if (widget.matiere != null && !classes!.contains(widget.matiere!.classe)) {
      classes!.add(widget.matiere!.classe!);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nomController,
              decoration: const InputDecoration(labelText: "Nom"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: coefController,
              decoration: const InputDecoration(labelText: "Coef"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: nbHeuresController,
              decoration: const InputDecoration(labelText: "NbHeures"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            DropdownButton<Classe>(
              value: selectedClasse,
              items: classes != null ? classes!.map((Classe classe) {
                return DropdownMenuItem<Classe>(
                  value: classe,
                  child: Text(classe.nomClass),
                );
              }).toList() : [],
              onChanged: (Classe? newClasse) {
                setState(() {
                  selectedClasse = newClasse;
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Matiere matiere = Matiere(
                    nom: nomController.text,
                    coef: int.parse(coefController.text),
                    nbHeures: int.parse(nbHeuresController.text),
                    classe: selectedClasse,
                  );
                  if (widget.matiere == null) {
                    await matiereService.addMatiere(matiere);
                  } else {
                    matiere.code = widget.matiere!.code;
                    await matiereService.updateMatiere(matiere);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text(widget.matiere == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}