import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class TestPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Função para adicionar um usuário
  Future<void> addUser(String email, String name, String role, String uid) async {
    try {
      await _firestore.collection('user').add({
        'email': email,
        'name': name,
        'role': role,
        'uid': uid,
      });
      print('Usuário adicionado: $name');
    } catch (e) {
      print('Erro ao adicionar usuário: $e');
    }
  }

  // Função para adicionar os usuários de teste
  Future<void> addTestUsers() async {
    await addUser("joao@example.com", "João Silva", "admin", "user123");
    await addUser("maria@example.com", "Maria Souza", "user", "user124");
    print('Usuários de teste adicionados com sucesso!');
  }

  // Função para pesquisar pelo nome "Maria"
  Future<void> searchMaria() async {
    try {
      // Realiza a consulta no Firestore
      QuerySnapshot querySnapshot = await _firestore
          .collection('user')
          .where('name', isEqualTo: 'Maria Souza')
          .get();

      // Verifica se há resultados
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          print('Usuário encontrado: ${doc.data()}');
        }
      } else {
        print('Nenhum usuário encontrado com o nome "Maria Souza".');
      }
    } catch (e) {
      print('Erro ao pesquisar usuário: $e');
    }
  }

  // Função para exibir o UID do usuário atual
  Future<void> showCurrentUserUid(BuildContext context) async {
    User? user = _auth.currentUser;
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('UID do usuário atual: ${user.uid}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nenhum usuário autenticado.')),
      );
    }
  }

  // Função para fazer login com o Google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login com Google realizado com sucesso! UID: ${user.uid}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login com o Google: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Teste'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Chama a função para adicionar os usuários de teste
                await addTestUsers();

                // Mostra uma mensagem de confirmação
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('2 usuários de teste adicionados!')),
                );
              },
              child: Text('Adicionar Usuários de Teste'),
            ),
            SizedBox(height: 20), // Espaço entre os botões
            ElevatedButton(
              onPressed: () async {
                // Chama a função para pesquisar pelo nome "Maria"
                await searchMaria();

                // Mostra uma mensagem de confirmação
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pesquisa por "Maria Souza" realizada!')),
                );
              },
              child: Text('Pesquisar por Maria'),
            ),
            SizedBox(height: 20), // Espaço entre os botões
            ElevatedButton(
              onPressed: () async {
                // Chama a função para exibir o UID do usuário atual
                await showCurrentUserUid(context);
              },
              child: Text('Mostrar UID do Usuário Atual'),
            ),
            SizedBox(height: 20), // Espaço entre os botões
            ElevatedButton(
              onPressed: () async {
                // Chama a função para fazer login com o Google
                await signInWithGoogle(context);
              },
              child: Text('Login com Google'),
            ),
          ],
        ),
      ),
    );
  }
}