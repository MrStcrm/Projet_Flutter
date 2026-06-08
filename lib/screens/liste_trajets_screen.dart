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

  // État pour activer/désactiver le classement du plus polluant au moins polluant
  bool _filtrerPlusPolluant = false;

  double get totalCO2 => _trajets.fold(0, (sum, t) => sum + t.co2);

  @override
  Widget build(BuildContext context) {
    // Préparation de la liste à afficher
    List<Trajet> trajetsAffiches = List.from(_trajets);

    if (_filtrerPlusPolluant) {
      // Tri du plus polluant (t2.co2) au moins polluant (t1.co2)
      trajetsAffiches.sort((t1, t2) => t2.co2.compareTo(t1.co2));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Journal Carbone'), 
        actions: [
          IconButton(
            icon: Icon(_filtrerPlusPolluant ? Icons.sort : Icons.filter_alt_off),
            onPressed: () {
              setState(() {
                _filtrerPlusPolluant = !_filtrerPlusPolluant;
              });
            },
          ),
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
          if (_filtrerPlusPolluant)
            Container(
              color: Colors.orange.shade100,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: const Text(
                "Classement Énergétique (Du plus polluant au moins polluant)",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: trajetsAffiches.length,
              itemBuilder: (context, index) {
                final t = trajetsAffiches[index];

                // Logique de calcul du rang avec gestion des ex aequo
                int rang = 1;
                if (_filtrerPlusPolluant && index > 0) {
                  // Si le trajet actuel a le même CO2 que le précédent, il prend le même rang
                  for (int i = 0; i < index; i++) {
                    if (trajetsAffiches[i].co2 > t.co2) {
                      rang++;
                    }
                  }
                }

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 2,
                  child: ListTile(
                    // Affiche le numéro de rang si le filtre est actif, sinon l'icône normale
                    leading: _filtrerPlusPolluant
                        ? CircleAvatar(
                            backgroundColor: Colors.orange.shade200,
                            child: Text('$rang', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                          )
                        : CircleAvatar(backgroundColor: t.mode.color.withOpacity(0.2), child: Icon(t.mode.icon, color: t.mode.color)),
                    
                    // Format nom du trajet et moyen de transport (Ex: "Aller au centre commercial [Bus]")
                    title: Text(
                      _filtrerPlusPolluant ? "${t.motif} [${t.mode.label}]" : t.motif, 
                      style: const TextStyle(fontWeight: FontWeight.bold)
                    ),
                    subtitle: Text('${t.distance} km en ${t.mode.label}'),
                    
                    //Calcul CO2 + Modifier + Supprimer
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${t.co2.toStringAsFixed(0)} g', style: const TextStyle(fontWeight: FontWeight.bold)),
                        
                        // On n'affiche les boutons d'action QUE si le filtre est inactif
                        if (!_filtrerPlusPolluant) ...[
                          // 1. BOUTON MODIFIER
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                            onPressed: () async {
                              final trajetModifie = await Navigator.pushNamed(context, '/formulaire', arguments: t);
                              if (trajetModifie != null && trajetModifie is Trajet) {
                                setState(() {
                                  final indexReel = _trajets.indexWhere((element) => element.id == t.id);
                                  if (indexReel != -1) {
                                    _trajets[indexReel] = trajetModifie;
                                  }
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
                                          _trajets.removeWhere((element) => element.id == t.id);
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