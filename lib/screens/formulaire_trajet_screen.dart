import 'package:flutter/material.dart';

class FormulaireTrajetScreen extends StatelessWidget {
  const FormulaireTrajetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un trajet')),
      body: const Center(child: Text('Formulaire pour la saisie à venir')),
    );
  }
}