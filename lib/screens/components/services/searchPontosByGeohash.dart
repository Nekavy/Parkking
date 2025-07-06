import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> searchPontosByGeohash(String geohash) async {
    try {
      // Usa os primeiros 6 caracteres da geohash para uma busca mais abrangente
      String geohashPrefix = geohash.substring(0, 6);

      // Verifique o geohashPrefix antes da consulta para garantir que está correto
      print("Procurando por geohashPrefix: $geohashPrefix");

      QuerySnapshot snapshot = await _db
          .collection('parks')
          .where('geohash', isGreaterThanOrEqualTo: geohashPrefix)
          .where('geohash', isLessThan: geohashPrefix + '\uf8ff')
          .get();

      print("Número de documentos encontrados: ${snapshot.docs.length}");

      // Se não encontrar documentos, adicione uma verificação
      if (snapshot.docs.isEmpty) {
        print("Nenhum documento encontrado.");
      }

      List<Map<String, dynamic>> pontos = snapshot.docs.map((doc) {
        return {
          'id': doc.id, // Inclui o ID do documento
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();

      return pontos;
    } catch (e) {
      print("Erro ao pesquisar pontos: $e");
      return [];
    }
  }
}
