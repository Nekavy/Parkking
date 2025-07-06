import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components/utils/menubar.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      backgroundColor: Colors.grey[200], // Fundo para evitar tudo branco
      appBar: AppBar(
        title: Text('Perfil'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
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
                            backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                            backgroundColor: Colors.grey[300],
                            child: user?.photoURL == null ? Icon(Icons.person, size: 50, color: Colors.black) : null,
                          ),
                          SizedBox(height: 15),
                          Text(
                            user?.displayName ?? 'Nome não disponível',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          Text(
                            user?.email ?? 'E-mail não disponível',
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30),

                    Card(
                      elevation: 1,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.phone, color: Colors.black),
                            title: Text('Telefone', style: TextStyle(color: Colors.black)),
                            subtitle: Text(user?.phoneNumber ?? 'Não informado', style: TextStyle(color: Colors.grey[700])),
                          ),
                          Divider(height: 1, color: Colors.grey[300]),
                          ListTile(
                            leading: Icon(Icons.verified_user, color: Colors.black),
                            title: Text('Verificado', style: TextStyle(color: Colors.black)),
                            subtitle: Text(user?.emailVerified == true ? 'Sim' : 'Não', style: TextStyle(color: Colors.grey[700])),
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
                        child: Text('Logout', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            BottomMenuBar("Perfil"), // Agora está FIXA NO FUNDO corretamente
          ],
        ),
      ),
    );
  }
}
