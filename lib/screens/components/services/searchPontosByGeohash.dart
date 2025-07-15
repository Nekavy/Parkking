import 'package:cloud_firestore/cloud_firestore.dart';
import 'geohash_service.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Busca pontos próximos com base em um geohash completo
  Future<List<Map<String, dynamic>>> searchPontosByGeohash(String fullGeohash) async {
    try {
      const int prefixLength = 5;

      if (fullGeohash.length < prefixLength) {
        print('⚠️ Geohash muito curto. Esperado pelo menos $prefixLength caracteres.');
        return [];
      }

      final String prefix = fullGeohash.substring(0, prefixLength);

      final geohashService = GeohashService();
      final Map<String, String> neighborsMap = geohashService.getNeighbors(prefix);

      List<String> geohashPrefixes = [prefix, ...neighborsMap.values];
      geohashPrefixes = geohashPrefixes.toSet().toList(); // remove duplicados

      print('🔍 Prefixo central: $prefix');
      print('🌐 Prefixos para busca (${geohashPrefixes.length}): $geohashPrefixes');

      final List<Map<String, dynamic>> allPontos = [];

      for (String prefix in geohashPrefixes) {
        final QuerySnapshot snapshot = await _db
            .collection('parks')
            .where('geohash', isGreaterThanOrEqualTo: prefix)
            .where('geohash', isLessThan: prefix + '\uf8ff')
            .get();

        print('📁 Resultados encontrados para "$prefix": ${snapshot.docs.length}');

        final pontos = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          };
        }).toList();

        allPontos.addAll(pontos);
      }

      final uniquePontos = {
        for (var ponto in allPontos) ponto['id']: ponto,
      }.values.toList();

      print('✅ Total de pontos únicos encontrados: ${uniquePontos.length}');

      return uniquePontos;

    } catch (e) {
      print('❌ Erro ao buscar pontos por geohash: $e');
      return [];
    }
  }
}
