import 'package:flutter/material.dart';
import 'package:tp7_test/entities/departement.dart';
import 'package:tp7_test/service/departementservice.dart';

class DepartementDialog extends StatefulWidget {
  final Function()? notifyParent;
  Departement? departement;

  DepartementDialog({super.key, @required this.notifyParent, this.departement});
  @override
  State<DepartementDialog> createState() => _DepartementDialogState();
}

class _DepartementDialogState extends State<DepartementDialog> {
  TextEditingController nomCtrl = TextEditingController();

  TextEditingController nbrCtrl = TextEditingController();

  String title = "Ajouter Departement";
  String action = "Ajouter";
  bool modif = false;

  late int idDepartement;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.departement != null) {
      modif = true;
      title = "Modifier Departement";
      action = "Modifier";
      nomCtrl.text = widget.departement!.nomDepartement!;
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
            ElevatedButton(
                onPressed: () async {
                  if (modif == false) {
                    await adddepartement(Departement(nomCtrl.text));
                    widget.notifyParent!();
                  } else {
                    await updatedepartemente(
                        Departement(nomCtrl.text, idDepartement));
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
