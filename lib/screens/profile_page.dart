import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'components/utils/menubar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String nome = 'A carregar...';
  String telefone = 'A carregar...';
  bool isGoogleAccount = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(user.uid).get();

      Map<String, dynamic>? data = snapshot.data();
      setState(() {
        nome = data?['nome'] ?? user.displayName ?? 'Nome não disponível';
        telefone = data?['telefone'] ?? 'Não informado';
        isGoogleAccount = user.providerData.any((info) => info.providerId == 'google.com');
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Erro ao fazer logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Perfil'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: user?.photoURL != null
                                ? NetworkImage(user!.photoURL!)
                                : null,
                            backgroundColor: Colors.grey[300],
                            child: user?.photoURL == null
                                ? Icon(Icons.person,
                                    size: 50, color: Colors.black)
                                : null,
                          ),
                          SizedBox(height: 15),
                          Text(
                            nome,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            user?.email ?? 'E-mail não disponível',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700]),
                          ),
                          if (isGoogleAccount)
                            Text(
                              'Conta Google',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueGrey,
                                  fontStyle: FontStyle.italic),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Card(
                      elevation: 1,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.phone, color: Colors.black),
                            title: Text('Telefone',
                                style: TextStyle(color: Colors.black)),
                            subtitle: Text(telefone,
                                style: TextStyle(color: Colors.grey[700])),
                          ),
                          Divider(height: 1, color: Colors.grey[300]),
                          ListTile(
                            leading:
                                Icon(Icons.verified_user, color: Colors.black),
                            title: Text('Verificado',
                                style: TextStyle(color: Colors.black)),
                            subtitle: Text(
                                user?.emailVerified == true ? 'Sim' : 'Não',
                                style: TextStyle(color: Colors.grey[700])),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _logout(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text('Logout',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BottomMenuBar("Perfil"),
          ],
        ),
      ),
    );
  }
}
