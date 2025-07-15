import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FBColRegInfoUser {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Agora a função aceita também nome e telefone
  Future<void> regUserInfo(
    String role,
    String uid,
    String email,
    BuildContext context,
    String nome,
    String telefone,
  ) async {
    try {
      DocumentReference userRef = _firestore.collection('users').doc(uid);

      Map<String, dynamic> userData = {
        'role': role,
        'email': email,
        'nome': nome,
        'telefone': telefone,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await userRef.set(userData, SetOptions(merge: true));

      print('Informações do utilizador com UID $uid registadas com sucesso!');
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print('Erro ao registar informações do utilizador: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registar: $e')),
      );
    }
  }
}
