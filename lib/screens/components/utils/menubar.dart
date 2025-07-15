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
        currentIndex = 4;
        break;
      default:
        currentIndex = 0;
    }

    return Column(
      children: [
        BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF00313B),     // Cor do item selecionado
          unselectedItemColor: Colors.grey,         // Cor dos itens não selecionados
          selectedIconTheme: IconThemeData(
            size: 28,
            color: Color(0xFF00313B),
          ),
          unselectedIconTheme: IconThemeData(
            size: 24,
            color: Colors.grey,
          ),
          selectedLabelStyle: TextStyle(
            color: Color(0xFF00313B),
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            color: Colors.grey,
          ),
          onTap: (index) {
            if (index == currentIndex) return;

            String route;
            switch (index) {
              case 0:
                route = "/home";
                break;
              case 1:
                route = "/reservas";
                break;
              case 2:
                route = "/ad";
                break;
              case 3:
                route = "/cm";
                break;
              default:
                route = "/profile";
            }
            Navigator.pushNamed(context, route);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Mapa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Reservas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Anuncie',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Mensagens',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ],
    );
  }
}
