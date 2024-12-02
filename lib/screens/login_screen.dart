import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Login",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 40),
            // Campo de e-mail
            const TextField(
              decoration: InputDecoration(
                labelText: "E-mail",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Campo de senha
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            // Botão de login
            ElevatedButton(
              onPressed: () {
                // Lógica de autenticação será implementada aqui
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Login"),
            ),
            const SizedBox(height: 16),
            // Botão de login com Google
            OutlinedButton.icon(
              onPressed: () {
                // Implementação do Google Auth
              },
              icon: const Icon(Icons.login),
              label: const Text("Login com Google"),
            ),
            const Spacer(),
            // Link para registo
            TextButton(
              onPressed: () {
                // Lógica para registar o utilizador
              },
              child: const Text(
                "Ainda não tens conta? Regista-te",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
