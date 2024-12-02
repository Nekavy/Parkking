import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Para o indicador de páginas

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intro Slider',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IntroSliderPage(),
    );
  }
}

class IntroSliderPage extends StatefulWidget {
  @override
  _IntroSliderPageState createState() => _IntroSliderPageState();
}

class _IntroSliderPageState extends State<IntroSliderPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  // Lista de páginas da introdução
  final List<Widget> _pages = [
    _buildPage("Bem-vindo!", "Explore nosso aplicativo e comece agora."),
    _buildPage("Facilidade", "Oferecemos opções de aluguel simples e rápidas."),
    _buildPage("Escolha seu papel", "Arrendador ou Cliente, a escolha é sua."),
  ];

  static Widget _buildPage(String title, String description) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        Text(description, textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Intro Slider')),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: _pages,
            ),
          ),
          SmoothPageIndicator(
            controller: _controller,
            count: _pages.length,
            effect: ExpandingDotsEffect(),
          ),
          if (_currentPage == _pages.length - 1)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RoleSelectionPage(role: "Arrendador")),
                    ),
                    child: Text("Arrendador"),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RoleSelectionPage(role: "Cliente")),
                    ),
                    child: Text("Cliente"),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class RoleSelectionPage extends StatelessWidget {
  final String role;

  RoleSelectionPage({required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Escolha o seu papel")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Você escolheu: $role", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoginPage(role: role)),
              ),
              child: Text("Login"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RegisterPage(role: role)),
              ),
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}

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

class RegisterPage extends StatelessWidget {
  final String role;

  RegisterPage({required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$role Register")),
      body: Center(
        child: Text("Página de Registro para $role"),
      ),
    );
  }
}
