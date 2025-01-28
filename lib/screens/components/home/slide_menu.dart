import 'package:flutter/material.dart';

class SlideMenu extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems;

  // Construtor para receber a lista de itens
  SlideMenu({required this.menuItems}); // Certifique-se de usar "required"

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.2,
      maxChildSize: 0.5,
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 5,
                width: 30,
                margin: EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(menuItems[index]['name']), // Exibe o nome
                      subtitle: Text('Distância: ${menuItems[index]['distance']} km'), // Exibe a distância
                      onTap: () {
                        print("Selecionado: ${menuItems[index]['name']} - ${menuItems[index]['distance']} km");
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
