import 'package:flutter/material.dart';

import '../entities/absence.dart';
import '../entities/student.dart';

class DetailsAbsenceScreen extends StatelessWidget {
  final Student student;
  final List<Absence> absences;

  DetailsAbsenceScreen({Key? key, required this.student, required this.absences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Group absences by matiere and sum nha
    Map<String, int> matieresAbsences = {};
    for (var absence in absences) {
      if (!matieresAbsences.containsKey(absence.codeMatiere)) {
        matieresAbsences[absence.codeMatiere] = 0;
      }
      matieresAbsences[absence.codeMatiere] = matieresAbsences[absence.codeMatiere]! + absence.nha;
    }

    // Convert to list of DataRow for DataTable
    List<DataRow> rows = matieresAbsences.entries.map((entry) {
      return DataRow(cells: [
        DataCell(Text(entry.key)),
        DataCell(Text(entry.value.toString())),
      ]);
    }).toList();

    // Calculate the total number of absences
    int totalAbsences = matieresAbsences.values.fold(0, (sum, nha) => sum + nha);

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails des absences pour ${student.nom}'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Matière')),
            DataColumn(label: Text('Total NHA')),
          ],
          rows: rows,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Nombre total d\'heures d\'absence : $totalAbsences'),
        ),
      ),
    );
  }
}
