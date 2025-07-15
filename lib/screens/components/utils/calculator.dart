import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class Calculator {
  Future<List<Map<String, dynamic>>> calculate(
      double lat, double lng, List<Map<String, dynamic>> pontos) async {
    List<Map<String, dynamic>> distances = [];

    for (final place in pontos) {
      final coordinates = place['coordinates'];

      if (coordinates is GeoPoint) {
        double placeLat = coordinates.latitude;
        double placeLng = coordinates.longitude;

        double distance = _calculateDistance(lat, lng, placeLat, placeLng);

        print('Distância de ${place['name']} : ${distance.toStringAsFixed(2)} km');
        print('id parque ${place['parkId']} : ${distance.toStringAsFixed(2)} km');

        // Buscar nome do utilizador com base no userid
        String ownerId = place['userid'];
        String ownerName = await _getUserNameById(ownerId);

        distances.add({
          'name': place['name'],
          'distance': distance,
          'price': place['price'],
          'lat': placeLat,
          'lng': placeLng,
          'parkId': place['parkId'],
          'ownerid': ownerId,
          'owner': ownerName,
        });
      } else {
        print("Erro: 'coordinates' inválido para ${place['name']}");
      }
    }

    // Ordenar por distância
    distances.sort((a, b) => a['distance'].compareTo(b['distance']));
    return distances;
  }

  Future<String> _getUserNameById(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data();
        return data?['nome'] ?? '';
      }
    } catch (e) {
      print('Erro ao obter nome do utilizador ($userId): $e');
    }
    return '';
  }

  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double radius = 6371;
    double dLat = _degToRad(lat2 - lat1);
    double dLng = _degToRad(lng2 - lng1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) * cos(_degToRad(lat2)) *
            sin(dLng / 2) * sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radius * c;
  }

  double _degToRad(double deg) => deg * (pi / 180);
}
