import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'role_selection_page.dart';

class IntroSliderPage extends StatefulWidget {
  @override
  _IntroSliderPageState createState() => _IntroSliderPageState();
}

class _IntroSliderPageState extends State<IntroSliderPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  // Lista de páginas da introdução
  final List<Widget> _pages = [
    _buildPage("Bem-vindo!", "Explore nosso aplicativo e comece agora.", 'assets/images/welcome_image.png'),
    _buildPage("Facilidade", "Oferecemos opções de aluguel simples e rápidas.", 'assets/images/ease_image.png'),
    _buildPage("Escolha seu papel", "Arrendador ou Cliente, a escolha é sua.", 'assets/images/role_choice_image.png'),
  ];

  static Widget _buildPage(String title, String description, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath, // Imagem específica para cada slide
            height: 200, // Ajuste o tamanho conforme necessário
            fit: BoxFit.contain, // A imagem fica proporcional
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fundo branco
      appBar: AppBar(
        title: Text('Intro Slider', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
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
            effect: ExpandingDotsEffect(
              dotColor: Colors.grey,
              activeDotColor: Colors.blue,
              dotHeight: 8,
              dotWidth: 8,
            ),
          ),
          if (_currentPage == _pages.length - 1)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Botão "Arrendador"
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RoleSelectionPage(role: "Arrendador"),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(double.infinity, 56), // Tamanho dos botões
                    ),
                    child: Text(
                      "Arrendador",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 16), // Espaço entre os botões
                  // Botão "Cliente"
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RoleSelectionPage(role: "Cliente"),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(double.infinity, 56), // Tamanho dos botões
                    ),
                    child: Text(
                      "Cliente",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
