import 'package:flutter/material.dart';
import '../models/trajet.dart';

class FormulaireTrajetScreen extends StatefulWidget {
  const FormulaireTrajetScreen({super.key});

  @override
  State<FormulaireTrajetScreen> createState() => _FormulaireTrajetScreenState();
}

class _FormulaireTrajetScreenState extends State<FormulaireTrajetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _motifController = TextEditingController();
  final _distanceController = TextEditingController();
  ModeTransport _modeSelectionne = ModeTransport.voiture;
  
  Trajet? _trajetAModifier; // Permet de savoir si on est en mode "Édition"
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      // Récupération automatique de l'argument si on fait une MODIFICATION
      final arguments = ModalRoute.of(context)!.settings.arguments;
      if (arguments != null && arguments is Trajet) {
        _trajetAModifier = arguments;
        _motifController.text = _trajetAModifier!.motif;
        _distanceController.text = _trajetAModifier!.distance.toString();
        _modeSelectionne = _trajetAModifier!.mode;
      }
      _isInit = false;
    }
  }

  @override
  void dispose() {
    _motifController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_trajetAModifier == null ? 'Ajouter un trajet' : 'Modifier le trajet')),
      body: Center( // Centre tout le contenu au milieu de l'écran
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card( // Box qui enveloppe le formulaire
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // S'adapte au contenu
                    children: [
                      Text(
                        _trajetAModifier == null ? 'Nouveau Déplacement' : 'Mise à jour',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _motifController,
                        decoration: const InputDecoration(labelText: 'Motif (ex: Cours à l\'ESP)', border: OutlineInputBorder()),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Saisissez un motif' : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _distanceController,
                        decoration: const InputDecoration(labelText: 'Distance (km)', border: OutlineInputBorder()),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) => value == null || double.tryParse(value) == null || double.parse(value) <= 0 ? 'Nombre supérieur à 0' : null,
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<ModeTransport>(
                        value: _modeSelectionne,
                        decoration: const InputDecoration(labelText: 'Mode de transport', border: OutlineInputBorder()),
                        items: ModeTransport.values.map((m) => DropdownMenuItem(value: m, child: Text(m.label))).toList(),
                        onChanged: (m) => setState(() => _modeSelectionne = m!),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final trajetResultat = Trajet(
                                id: _trajetAModifier?.id ?? DateTime.now().toString(), // Garde le même ID si modification
                                motif: _motifController.text,
                                mode: _modeSelectionne,
                                distance: double.parse(_distanceController.text),
                                date: _trajetAModifier?.date ?? DateTime.now(),
                              );
                              Navigator.pop(context, trajetResultat); // Renvoie l'objet
                            }
                          },
                          child: const Text('Enregistrer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}