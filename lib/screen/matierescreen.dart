import 'package:flutter/material.dart';

import 'package:tp7_test/entities/matiere.dart';
import 'package:tp7_test/service/matiereservice.dart';

import '../entities/classe.dart';
import '../service/classeservice.dart';
import '../template/dialog/matieredialog.dart';

class MatiereScreen extends StatefulWidget {
  @override
  _MatiereScreenState createState() => _MatiereScreenState();
}

class _MatiereScreenState extends State<MatiereScreen> {
  final MatiereService matiereService = MatiereService();
  final ClasseService classeService = ClasseService(); // Assuming you have a ClasseService
  Classe? selectedClasse;
  List<Classe>? classes;

  @override
  void initState() {
    super.initState();
    fetchClasses();
  }

  fetchClasses() async {
    classes = await classeService.getAllClasses();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Matieres'),
      ),
      body: Column(
        children: [
          if (classes != null)
            DropdownButton<Classe>(
              value: selectedClasse,
              items: classes!.map((Classe classe) {
                return DropdownMenuItem<Classe>(
                  value: classe,
                  child: Text(classe.nomClass),
                );
              }).toList(),
              onChanged: (Classe? newClasse) {
                setState(() {
                  selectedClasse = newClasse;
                });
              },
            ),
          if (selectedClasse != null && selectedClasse!.codClass != null)
            FutureBuilder<List<Matiere>>(
              future: matiereService.getMatieresByClasseId(selectedClasse!.codClass!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Matiere>? data = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(data[index].nom!),
                        subtitle: Text('Coef: ${data[index].coef}, NbHeures: ${data[index].nbHeures}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => addMatieredialog(matiere: data[index]),
                                ).then((_) => setState(() {}));
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await matiereService.deleteMatiere(data[index].code!);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => addMatieredialog(),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}