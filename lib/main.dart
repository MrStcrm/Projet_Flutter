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
      
      // 1. Personnalisation de l'UI (ThemeData) - ODD 13 (Vert/Écolo)
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

      // 2. Routage par Routes Nommées (Au moins 3 écrans exigés)
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