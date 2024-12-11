import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroSliderPage extends StatefulWidget {
  @override
  _IntroSliderPageState createState() => _IntroSliderPageState();
}

class _IntroSliderPageState extends State<IntroSliderPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      "title": "Bem-vindo!",
      "description": "Explore o nosso aplicativo e comece agora.",
      "image": "assets/images/welcome_image.png",
      "caption": "Descubra a facilidade do nosso serviço.",
    },
    {
      "title": "Facilidade",
      "description": "Oferecemos opções de aluguel simples e rápidas.",
      "image": "assets/images/ease_image.png",
      "caption": "Alugar nunca foi tão fácil!",
    },
    {
      "title": "Escolha seu papel",
      "description": "Arrendador ou Cliente, a escolha é sua.",
      "image": "assets/images/role_choice_image.png",
      "caption": "Decida como quer participar.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Slider com as imagens e texto
          PageView.builder(
            controller: _controller,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return _buildSlide(slide);
            },
          ),

          // Indicadores de página
          Positioned(
            bottom: 250,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: _slides.length,
                effect: ExpandingDotsEffect(
                  dotColor: Colors.grey,
                  activeDotColor: Colors.blue,
                  dotHeight: 8,
                  dotWidth: 8,
                ),
              ),
            ),
          ),

          // Área dos botões com fundo branco e bordas arredondadas
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: _currentPage == _slides.length - 1
                        ? () => _navigateToRoleSelection(context, "Particular")
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(double.infinity, 56), // Botão mais longo
                    ),
                    child: Text(
                      "Particular",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _currentPage == _slides.length - 1
                        ? () => _navigateToRoleSelection(context, "Cliente")
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(double.infinity, 56), // Botão mais longo
                    ),
                    child: Text(
                      "Cliente",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(Map<String, String> slide) {
    return Column(
      children: [
        // Imagem ocupa metade da tela
        Expanded(
          flex: 1,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: Image.asset(
                  slide['image']!,
                  fit: BoxFit.cover, // Garante que a imagem preencha sem cortes
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned(
                bottom: 16,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    slide['caption']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Conteúdo do slide
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                slide['title']!,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                slide['description']!,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToRoleSelection(BuildContext context, String role) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RoleSelectionPage(role: role),
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
      appBar: AppBar(
        title: Text("Seleção de Papel"),
      ),
      body: Center(
        child: Text(
          "Bem-vindo, $role!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}