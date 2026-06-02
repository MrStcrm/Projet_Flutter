import 'package:flutter/material.dart';

enum ModeTransport { voiture, bus, moto, marche, velo }

extension ModeTransportExtension on ModeTransport {
  // Facteurs d'émission en g CO2 par km par passager adaptés au contexte de Dakar (Sources : CETUD / DEEC)
  double get facteur {
    switch (this) {
      case ModeTransport.voiture: 
        return 190.0; // Véhicules souvent d'occasion, carburant diesel, embouteillages
      case ModeTransport.moto: 
        return 75.0;  // Motos et Jakarta très présentes
      case ModeTransport.bus: 
        return 35.0;  // Cars Rapides, Dakar Dem Dikk
      case ModeTransport.marche: 
        return 0.0;
      case ModeTransport.velo: 
        return 0.0;
    }
  }

  String get label => name[0].toUpperCase() + name.substring(1);

  IconData get icon {
    switch (this) {
      case ModeTransport.voiture: return Icons.directions_car;
      case ModeTransport.moto: return Icons.two_wheeler;
      case ModeTransport.bus: return Icons.directions_bus;
      case ModeTransport.marche: return Icons.directions_walk;
      case ModeTransport.velo: return Icons.pedal_bike;
    }
  }

  Color get color => (this == ModeTransport.marche || this == ModeTransport.velo) ? Colors.green : Colors.orange;
}

class Trajet {
  final String id;
  final String motif;
  final ModeTransport mode;
  final double distance;
  final DateTime date;

  Trajet({
    required this.id, 
    required this.motif, 
    required this.mode, 
    required this.distance, 
    required this.date
  });

  // Formule pour calculer l'empreinte carbone : distance (km) x facteur (g CO2 / km)
  double get co2 => distance * mode.facteur;
}