import 'package:flutter/material.dart';

class BottomMenuBar extends StatelessWidget {
  final String selectedPage;

  // Construtor que recebe a string da página selecionada
  BottomMenuBar(this.selectedPage);

  @override
  Widget build(BuildContext context) {
    int currentIndex;

    // Define qual item está selecionado com base na string
    switch (selectedPage) {
      case "Mapa":
        currentIndex = 0;
        break;
      case "Fav":
        currentIndex = 1;
        break;
      case "Reservas":
        currentIndex = 2;
        break;
      case "Perfil":
        currentIndex = 3;
        break;
      default:
        currentIndex = 0;
    }

    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: currentIndex, // O item selecionado
      type: BottomNavigationBarType.fixed, // Certifica-se de mostrar todos os itens
      onTap: (index) {
        // Navegação ao clicar nos botões
        String route;
        switch (index) {
          case 0:
            route = "Mapa";
            break;
          case 1:
            route = "Fav";
            break;
          case 2:
            route = "Reservas";
            break;
          case 3:
            route = "Perfil";
            break;
          default:
            route = "Mapa";
        }
        Navigator.pushNamed(context, route);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Mapa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favoritos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Reservas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}
