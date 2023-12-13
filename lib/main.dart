import 'package:flutter/material.dart';
import 'package:tp7_test/screen/absencescreen.dart';
import 'package:tp7_test/screen/departementscreen.dart';
import 'package:tp7_test/screen/matierescreen.dart';

import 'screen/classscreen.dart';
import 'screen/formationscreen.dart';
import 'screen/login.dart';
import 'screen/studentsscreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
      routes: {
        '/login': (context) => Login(),
        '/students': (context) => StudentScreen(),
        '/class': (context) => ClasseScreen(),
        '/formation': (context) => FormationScreen(),
        '/departement': (context) => DepartementScreen(),
        '/matiere': (context) => MatiereScreen(),
        '/absence': (context) => AbsenceScreen(),
      },
    );
  }
}
