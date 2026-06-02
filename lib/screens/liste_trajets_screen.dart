import 'package:flutter/material.dart';
import '../models/trajet.dart';

class ListeTrajetsScreen extends StatefulWidget {
  const ListeTrajetsScreen({super.key});

  @override
  State<ListeTrajetsScreen> createState() => _ListeTrajetsScreenState();
}

class _ListeTrajetsScreenState extends State<ListeTrajetsScreen> {
  // BD simulée avec des distances géographiquement cohérentes pour Dakar
  final List<Trajet> _trajets = [
    Trajet(
      id: '1', 
      motif: 'Aller au centre commercial (Ngor à Sea Plaza)', 
      mode: ModeTransport.bus, 
      distance: 8.0, // Distance réelle ajustée 
      date: DateTime.now()
    ),
    Trajet(
      id: '2', 
      motif: 'Achat à la boutique de quartier', 
      mode: ModeTransport.marche, 
      distance: 0.4, 
      date: DateTime.now()
    ),
  ];

  double get totalCO2 => _trajets.fold(0, (sum, t) => sum + t.co2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Journal Carbone'), 
        actions: [
          IconButton(
            icon: const Icon(Icons.info), 
            onPressed: () => Navigator.pushNamed(context, '/apropos')
          ),
        ]
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.green.shade100,
            child: Column(
              children: [
                const Text("Total de l'Empreinte Carbone (Dakar)", style: TextStyle(fontSize: 16)),
                Text('${totalCO2.toStringAsFixed(1)} g CO₂', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _trajets.length,
              itemBuilder: (context, index) {
                final t = _trajets[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: t.mode.color.withOpacity(0.2), 
                      child: Icon(t.mode.icon, color: t.mode.color)
                    ),
                    title: Text(t.motif, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${t.distance} km en ${t.mode.label}'),
                    trailing: Text('${t.co2.toStringAsFixed(0)} g', style: const TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () => Navigator.pushNamed(context, '/detail', arguments: t),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/formulaire'),
        child: const Icon(Icons.add),
      ),
    );
  }
}