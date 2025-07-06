import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FBColRegInfoPark {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerPark({
    required String name,
    required String address,
    required String country,
    required String geohash,
    required double lat,
    required double lng,
    required String parkId,
    required String price,
    //required List<File> images,
  }) async {
    try {
      String userId = _auth.currentUser?.uid ?? "unknown_user";

      // Upload das imagens para Firebase Storage
      /*List<String> imageUrls = [];
      for (File image in images) {
        String filePath = 'parks/$parkId/${DateTime.now().millisecondsSinceEpoch}.jpg';
        TaskSnapshot snapshot = await _storage.ref(filePath).putFile(image);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }*/

      // Guardar os dados no Firestore
      await _firestore.collection('parks').doc(parkId).set({
        'name': name,
        'address': address,
        'country': country,
        'geohash': geohash,
        'coordinates': GeoPoint(lat, lng),
        'parkId': parkId,
        'price': price,
        'userid': userId,
        //'images': imageUrls, // URLs das imagens problemas com billing não permitem 
      });
    } catch (e) {
      print('Erro ao registar parque: $e');
    }
  }
}
