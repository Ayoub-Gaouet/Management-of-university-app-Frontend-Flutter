import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tp7_test/template/navbar.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar('Dashboard'),
      backgroundColor: Colors.deepPurple,
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 50.0,
            ),
            ListTile(
              title: const Text('Etudiant'),
              onTap: () {
                Navigator.pushNamed(context, '/students');
              },
            ),
            ListTile(
              title: const Text('Classes'),
              onTap: () {
                Navigator.pushNamed(context, '/class');
              },
            ),
            ListTile(
              title: const Text('Formations'),
              onTap: () {
                Navigator.pushNamed(context, '/formation');
              },
            ),
            ListTile(
              title: const Text('Departements'),
              onTap: () {
                Navigator.pushNamed(context, '/departement');
              },
            ),
            ListTile(
              title: const Text('Matieres'),
              onTap: () {
                Navigator.pushNamed(context, '/matiere');
              },
            ),
            ListTile(
              title: const Text('Absences'),
              onTap: () {
                Navigator.pushNamed(context, '/absence');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: SizedBox(
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 30.0,
              fontFamily: 'Agne',
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText('Welcome Back'),
                TypewriterAnimatedText('Dashboard'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
