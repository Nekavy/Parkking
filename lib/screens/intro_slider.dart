import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:parkking/main.dart';

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
      "caption": "Encontrar lugar nunca foi tão fácil!",
    },
    {
      "title": "Segurança",
      "description": "Usa o teu espaço",
      "image": "assets/images/ease_image.png",
      "caption": "Arrendar o seu espaço nunca foi tão fácil!",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fundo branco para toda a tela
      body: Column(
        children: [
          // Nome da aplicação no topo
          Container(
            color: Colors.white, // Fundo branco no topo
            padding: const EdgeInsets.only(top: 40.0, bottom: 16.0),
            child: const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Park',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00313B), // Azul-petróleo escuro (mais sério)
                  ),
                ),
                TextSpan(
                  text: 'King',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFC107), // Amarelo dourado
                  ),
                ),
              ],
            ),
          ),
          ),

          // Slider com as imagens e texto
          Expanded(
            child: PageView.builder(
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
          ),

          // Área dos botões, título, legenda e indicadores
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título da página atual
                Text(
                  _slides[_currentPage]['title']!,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),

                // Descrição da página atual
                Text(
                  _slides[_currentPage]['description']!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),

                // Legenda e indicadores de página
                Text(
                  _slides[_currentPage]['caption']!,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                SmoothPageIndicator(
                  controller: _controller,
                  count: _slides.length,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Colors.blue,
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),

                SizedBox(height: 24),

                // Botões
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed:() { Navigator.of(context).pushReplacementNamed('/login');},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(double.infinity, 56),
                  ),
                  child: Text(
                    "Entrar",
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
        ],
      ),
    );
  }

  Widget _buildSlide(Map<String, String> slide) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.white, // Fundo branco para a área da imagem
            child: Image.asset(
              slide['image']!,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
      ],
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
