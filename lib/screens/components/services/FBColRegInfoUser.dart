import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';  // Necessário para usar o Navigator

class FBColRegInfoUser {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Função para registar as informações do utilizador na coleção 'users'
  Future<void> regUserInfo(
      String role, String uid, String email, BuildContext context) async {
    try {
      // Referência para o documento do utilizador na coleção 'users'
      DocumentReference userRef = _firestore.collection('users').doc(uid);

      // Dados a serem guardados no documento do utilizador
      Map<String, dynamic> userData = {
        'role': role,  // O papel do utilizador (ex: 'admin', 'client', etc.)
        'email': email,  // O email do utilizador
        'timestamp': FieldValue.serverTimestamp(),  // Timestamp para indicar quando a conta foi criada
      };

      // Guarda ou atualiza o documento com as informações
      await userRef.set(userData, SetOptions(merge: true));  // Merge para não sobrescrever outros dados existentes

      print('Informações do utilizador com UID $uid registadas com sucesso!');
      
      // Redireciona para a página principal (pode ser outro nome de rota)
      Navigator.pushReplacementNamed(context, '/home');  
    } catch (e) {
      print('Erro ao registar informações do utilizador: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registar: $e'))
      );
    }
  }
}
