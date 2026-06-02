import 'package:flutter/material.dart';
import '../models/trajet.dart';

class DetailTrajetScreen extends StatelessWidget {
  const DetailTrajetScreen({super.key});

  @override
  Widget build(BuildContext context) {
   
    // Passage d'arguments via la route nommée
    final t = ModalRoute.of(context)!.settings.arguments as Trajet;

    return Scaffold(
      appBar: AppBar(title: const Text('Détails du Déplacement')),
      body: Column(
        children: [
          
          // Grand bandeau visuel coloré selon le mode
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            color: t.mode.color.withOpacity(0.15),
            child: Column(
              children: [
                Icon(t.mode.icon, size: 80, color: t.mode.color),
                const SizedBox(height: 10),
                Text(t.mode.label, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: t.mode.color)),
              ],
            ),
          ),
          
          // Informations du trajet 
          ListTile(leading: const Icon(Icons.notes), title: const Text('Motif'), subtitle: Text(t.motif)),
          const Divider(),
          ListTile(leading: const Icon(Icons.straighten), title: const Text('Distance parcourue'), subtitle: Text('${t.distance} km')),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.co2, size: 30),
            title: const Text('Impact Environnemental'),
            subtitle: Text('${t.co2.toStringAsFixed(1)} g de CO₂ émis'),
          ),
        ],
      ),
    );
  }
}