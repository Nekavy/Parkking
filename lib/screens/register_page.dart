import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'components/services/FBColRegInfoUser.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  String? _fullPhoneNumber;

  Future<void> _registerWithEmail() async {
    if (!_formKey.currentState!.validate() || _fullPhoneNumber == null || _fullPhoneNumber!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos obrigatórios.')),
      );
      return;
    }

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      registerUser();
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.message}')),
      );
    }
  }

  void registerUser() async {
    String role = 'client';
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    String email = FirebaseAuth.instance.currentUser?.email ?? '';
    String nome = _userNameController.text.trim();
    String telefone = _fullPhoneNumber ?? '';

    if (uid.isNotEmpty) {
      await FBColRegInfoUser().regUserInfo(role, uid, email, context, nome, telefone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text("Registe-se", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text("Crie a sua conta para começar.", style: TextStyle(fontSize: 18, color: Colors.black54)),
                  const SizedBox(height: 30),

                  // Nome
                  _buildValidatedField(
                    label: 'Nome de Utilizador',
                    controller: _userNameController,
                    validatorText: 'Insira o nome de utilizador',
                  ),
                  const SizedBox(height: 16),

                  // Telemóvel
                  IntlPhoneField(
                    decoration: const InputDecoration(
                      labelText: 'Número de Telemóvel',
                      border: OutlineInputBorder(),
                    ),
                    initialCountryCode: 'PT',
                    onChanged: (phone) => _fullPhoneNumber = phone.completeNumber,
                    validator: (phone) {
                      if (_fullPhoneNumber == null || _fullPhoneNumber!.isEmpty) {
                        return 'Insira o número de telemóvel';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email
                  _buildValidatedField(
                    label: 'Email',
                    controller: _emailController,
                    validatorText: 'Insira o email',
                  ),
                  const SizedBox(height: 16),

                  // Password
                  _buildValidatedField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: true,
                    validatorText: 'Insira a password',
                  ),
                  const SizedBox(height: 16),

                  // Confirmar Password
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirme a password';
                      }
                      if (value != _passwordController.text) {
                        return 'As passwords não coincidem';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: _registerWithEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text("Registar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Já tem conta?", style: TextStyle(color: Colors.black54)),
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                        child: const Text("Entre aqui", style: TextStyle(color: Colors.blue)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildValidatedField({
    required String label,
    required TextEditingController controller,
    required String validatorText,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return validatorText;
        return null;
      },
    );
  }
}
