import 'package:flutter/material.dart';
import 'screens/liste_trajets_screen.dart';
import 'screens/detail_trajet_screen.dart';
import 'screens/formulaire_trajet_screen.dart';
import 'screens/apropos_screen.dart';

void main() {
  runApp(const MonJournalCarboneApp());
}

class MonJournalCarboneApp extends StatelessWidget {
  const MonJournalCarboneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Journal d'empreinte carbone",
      debugShowCheckedModeBanner: false,
      
      //Personnalisation de l'UI en Vert
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),

      //Routage pour chaque écran 
      initialRoute: '/',
      routes: {
        '/': (context) => const ListeTrajetsScreen(),
        '/detail': (context) => const DetailTrajetScreen(),
        '/formulaire': (context) => const FormulaireTrajetScreen(),
        '/apropos': (context) => const AProposScreen(),
      },
    );
  }
}