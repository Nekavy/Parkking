import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../chat_screen.dart'; // Importação da tela de chat

class ParkInfo extends StatelessWidget {
  final Map<String, dynamic> parkData;

  const ParkInfo({super.key, required this.parkData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(parkData['name'] ?? 'Detalhes do Parque'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagem
                  Container(
                    height: 250,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: Icon(Icons.photo_camera, size: 50, color: Colors.grey[600]),
                  ),

                  // Nome e preço
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          parkData['name'] ?? 'Parque Sem Nome',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${parkData['price'] ?? 'Gratuito'} €',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                  ),

                  // Localização e detalhes
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(Icons.location_on, parkData['location'] ?? 'Desconhecido'),
                        _buildDetailRow(Icons.directions_car, 'Capacidade: ${parkData['capacity'] ?? '2'} veículos'),
                        _buildDetailRow(Icons.credit_card, 'Métodos de Pagamento: ${parkData['paymentMethods']?.join(', ') ?? 'Online ou em mão'}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botões fixos no fundo
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.chat),
                    label: Text('Chat'),
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 16)),
                    onPressed: () {
                      if (parkData['parkId'] == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('ID do parque não encontrado.')),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            parkId: parkData['parkId']!,
                            userId: FirebaseAuth.instance.currentUser!.uid,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.call),
                    label: Text('Ligar'),
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.green),
                    onPressed: () {
                      // Adicione a lógica para fazer uma chamada telefônica
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}