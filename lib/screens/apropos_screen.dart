import 'package:flutter/material.dart';

class AProposScreen extends StatelessWidget {
  const AProposScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('À Propos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Card(
              child: ListTile(
                leading: Icon(Icons.person, color: Colors.green),
                title: Text('Développeur'),
                subtitle: Text('Kossi Elie VIAGBO'),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.source, color: Colors.green),
                title: const Text('Source des données CO2'),
                subtitle: const Text("Données indicatives issues des inventaires d'émissions du CETUD et de la DEEC - Sénégal (Mobilité Urbaine à Dakar)"),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.date_range, color: Colors.green),
                title: const Text('Date de collecte'),
                subtitle: Text('${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}