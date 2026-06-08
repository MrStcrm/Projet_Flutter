import 'package:flutter/material.dart';
import '../models/trajet.dart';

class ListeTrajetsScreen extends StatefulWidget {
  const ListeTrajetsScreen({super.key});

  @override
  State<ListeTrajetsScreen> createState() => _ListeTrajetsScreenState();
}

class _ListeTrajetsScreenState extends State<ListeTrajetsScreen> {
  // Notre liste globale dynamique
  final List<Trajet> _trajets = [
    //Données prédéfinies pour tester l'affichage
    Trajet(id: '1', motif: 'Aller au centre commercial (Ngor à Sea Plaza)', mode: ModeTransport.bus, distance: 8.0, date: DateTime.now()),
    Trajet(id: '2', motif: 'Achat à la boutique du quartier', mode: ModeTransport.marche, distance: 0.4, date: DateTime.now()),
  ];

  double get totalCO2 => _trajets.fold(0, (sum, t) => sum + t.co2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Journal Carbone'), 
        actions: [
          IconButton(icon: const Icon(Icons.info), onPressed: () => Navigator.pushNamed(context, '/apropos')),
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
                    leading: CircleAvatar(backgroundColor: t.mode.color.withOpacity(0.2), child: Icon(t.mode.icon, color: t.mode.color)),
                    title: Text(t.motif, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${t.distance} km en ${t.mode.label}'),
                    
                    //Calcul CO2 + Modifier + Supprimer
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${t.co2.toStringAsFixed(0)} g', style: const TextStyle(fontWeight: FontWeight.bold)),
                        // 1. BOUTON MODIFIER
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                          onPressed: () async {
                            final trajetModifie = await Navigator.pushNamed(context, '/formulaire', arguments: t);
                            if (trajetModifie != null && trajetModifie is Trajet) {
                              setState(() {
                                _trajets[index] = trajetModifie; // Remplace l'ancien trajet par le nouveau
                              });
                            }
                          },
                        ),
                        // 2. BOUTON SUPPRIMER (Avec dialogue de confirmation)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Supprimer ?'),
                                content: const Text('Voulez-vous retirer ce déplacement de votre journal dakarois ?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _trajets.removeAt(index); // Supprime de la liste
                                      });
                                      Navigator.pop(ctx);
                                    },
                                    child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () => Navigator.pushNamed(context, '/detail', arguments: t),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // 3. BOUTON AJOUTER 
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final nouveauTrajet = await Navigator.pushNamed(context, '/formulaire');
          if (nouveauTrajet != null && nouveauTrajet is Trajet) {
            setState(() {
              _trajets.add(nouveauTrajet); // Ajoute le trajet créé à la liste
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}