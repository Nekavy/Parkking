import 'package:flutter/material.dart';
import 'parkinfo.dart';
import '../utils/menubar.dart';

class SlideMenu extends StatefulWidget {
  final List<Map<String, dynamic>> menuItems;

  const SlideMenu({
    super.key,
    required this.menuItems,
  });

  @override
  _SlideMenuState createState() => _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu> {
  double percentOpen = 0.085; // Tamanho inicial
  final DraggableScrollableController _controller = DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        setState(() {
          percentOpen = notification.extent / notification.maxExtent;
        });
        return true;
      },
      child: DraggableScrollableSheet(
        controller: _controller,
        initialChildSize: 0.075,
        minChildSize: 0.075,
        maxChildSize: 0.65,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
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
                // Barra de arraste (melhor acessibilidade)
                GestureDetector(
                  behavior: HitTestBehavior.opaque, // Garante que a área seja clicável
                  onVerticalDragUpdate: (details) {},
                  onVerticalDragEnd: (details) {},
                  child: Container(
                    height: 5,
                    width: 30,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                // Lista de itens
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: widget.menuItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.menuItems[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item['image'] ??
                                'https://maps.googleapis.com/maps/api/streetview?size=600x300&location=${item['lat']},${item['lng']}&fov=100&heading=90&pitch=0&key=AIzaSyDdwdpjWLdkfnFwZnhtAG3z64cseSqcycc',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey[200],
                              child: Icon(Icons.image_not_supported,
                                  color: Colors.grey[600]),
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.black54),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                item['name'] ?? 'Nome não disponível',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 22.0),
                          child: Row(
                            children: [
                              Text(
                                '${(item['distance'] as num?)?.toStringAsFixed(2) ?? 'N/A'} km ',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Container(
                                  width: 2,
                                  height: 16,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                item['price'] ?? 'Nome não disponível',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ParkInfo(parkData: item),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                if (percentOpen > 0.15) ...[
                  // Outro comportamento ou widget a ser exibido quando percentOpen > 0.085
                  Transform.translate(
                    offset: Offset(0, _calculateBottomMenuBarOffset(percentOpen)),
                    child: BottomMenuBar("Mapa"),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // Função para calcular o deslocamento do BottomMenuBar
  double _calculateBottomMenuBarOffset(double percentOpen) {
    if (percentOpen >= 0.4) {
      return 0;
    } else {
      return (1 - (percentOpen / 0.4)) * 100;
    }
  }
}
