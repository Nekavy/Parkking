import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final String role;

  LoginPage({required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$role Login")),
      body: Center(
        child: Text("Página de Login para $role"),
      ),
    );
  }
}
