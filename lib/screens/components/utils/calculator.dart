import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';

class Calculator {
  Future<List<Map<String, dynamic>>> calculate(double lat, double lng) async {
    // Carregar o ficheiro JSON dos assets
    String data = await rootBundle.loadString('assets/coordinates.json');
    
    // Decodificar o JSON diretamente como uma lista
    List<dynamic> coordinates = json.decode(data);

    // Calcular a distância para cada ponto no JSON
    List<Map<String, dynamic>> distances = coordinates.map((place) {
      double distance = _calculateDistance(
        lat,
        lng,
        place['lat'],
        place['lng'],
      );
      
      // Print das distâncias
      print('Distância de ${place['name']} : ${distance.toStringAsFixed(2)} km');
      
      return {
        'name': place['name'],
        'distance': distance,
      };
    }).toList();

    // Ordenar por distância
    distances.sort((a, b) => a['distance'].compareTo(b['distance']));

    return distances; // Retorna a lista ordenada dos mais próximos
  }

  // Função para calcular a distância entre dois pontos (em km)
  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double radius = 6371; // Raio da Terra em km
    double dLat = _degToRad(lat2 - lat1);
    double dLng = _degToRad(lng2 - lng1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) * cos(_degToRad(lat2)) *
            sin(dLng / 2) * sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radius * c;
  }

  // Converter graus para radianos
  double _degToRad(double deg) => deg * (pi / 180);
}
