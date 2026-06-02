import 'package:flutter/material.dart';

// 1. Énumération des modes de transport
enum ModeTransport { voiture, bus, moto, marche, velo }

// Extension pour associer facilement les facteurs d'émission et le design
extension ModeTransportExtension on ModeTransport {
  // Facteurs d'émission fictifs en g de CO2 par km (À AJUSTER avec vos données réelles collectées)
  double get facteurCO2 {
    switch (this) {
      case ModeTransport.voiture: return 150.0;
      case ModeTransport.moto: return 90.0;
      case ModeTransport.bus: return 40.0;
      case ModeTransport.marche: return 0.0;
      case ModeTransport.velo: return 0.0;
    }
  }

  // Libellé propre pour l'affichage textuel
  String get label {
    switch (this) {
      case ModeTransport.voiture: return 'Voiture';
      case ModeTransport.moto: return 'Moto';
      case ModeTransport.bus: return 'Bus';
      case ModeTransport.marche: return 'Marche';
      case ModeTransport.velo: return 'Vélo';
    }
  }

  // Couleur pour le badge (Exigence UI : vert pour marche/vélo)
  Color get couleurBadge {
    if (this == ModeTransport.marche || this == ModeTransport.velo) {
      return Colors.green;
    }
    if (this == ModeTransport.voiture) {
      return Colors.redAccent;
    }
    return Colors.orange;
  }
}

// 2. Classe Modèle Trajet
class Trajet {
  final String id;
  final String motif;
  final ModeTransport mode;
  final double distance; // en km
  final DateTime date;

  Trajet({
    required this.id,
    required this.motif,
    required this.mode,
    required this.distance,
    required this.date,
  });

  // Calcule le CO2 pour d'un trajet
  double get calculCO2 => distance * mode.facteurCO2;
}