import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import necessário para GeoPoint

class Calculator {
  Future<List<Map<String, dynamic>>> calculate(
      double lat, double lng, List<Map<String, dynamic>> pontos) async {
    // Calcular a distância para cada ponto na lista
    List<Map<String, dynamic>> distances = pontos.map((place) {
      final coordinates = place['coordinates'];

      if (coordinates is GeoPoint) { // Verifica se é um GeoPoint
        double placeLat = coordinates.latitude;
        double placeLng = coordinates.longitude;

        double distance = _calculateDistance(lat, lng, placeLat, placeLng);

        print('Distância de ${place['name']} : ${distance.toStringAsFixed(2)} km');
        print('id parqur${place['parkId']} : ${distance.toStringAsFixed(2)} km');

        return {
          'name': place['name'],
          'distance': distance,
          'price': place['price'],
          'lat': placeLat,
          'lng': placeLng,
          'parkId': place['parkId'],
        };
      } else {
        print("Erro: 'coordinates' inválido para ${place['name']}");
        return null;
      }
    }).where((element) => element != null).cast<Map<String, dynamic>>().toList(); // Remove valores nulos

    // Ordenar por distância (mais próximos primeiro)
    distances.sort((a, b) => a['distance'].compareTo(b['distance']));

    return distances; // Retorna a lista ordenada
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
