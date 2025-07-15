import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Obtém pontos filtrados pelo geohash
  Future<List<Map<String, dynamic>>> getPointsByGeohash(String geohashPrefix) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('points')
          .where('geohash', isGreaterThanOrEqualTo: geohashPrefix)
          .where('geohash', isLessThanOrEqualTo: '$geohashPrefix\uf8ff')
          .get();

      List<Map<String, dynamic>> points = querySnapshot.docs.map((doc) {
        return {
          'name': doc['name'],
          'lat': doc['lat'],
          'lng': doc['lng'],
          'geohash': doc['geohash'],
          'userId': doc['userId'],
          'price': doc['price'],
          'parkId': doc['parkId'],
          'country': doc['parkId'],
        };
      }).toList();

      return points;
    } catch (e) {
      print('Erro ao obter pontos: $e');
      return [];
    }
  }
}
