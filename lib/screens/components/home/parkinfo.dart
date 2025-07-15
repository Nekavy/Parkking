import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../chat_screen.dart';

class ParkInfo extends StatelessWidget {
  final Map<String, dynamic> parkData;
  
  const ParkInfo({super.key, required this.parkData});

  static const Color primaryColor = Color(0xFF00313B);
  static const Color white = Colors.white;

  @override
  Widget build(BuildContext context) {
    print('🚗 parkData: $parkData');
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          parkData['name'] ?? 'Detalhes do Parque',
          style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: primaryColor),
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
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.05),
                      image: parkData['image'] != null
                          ? DecorationImage(
                              image: NetworkImage(parkData['image']),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: parkData['image'] == null
                        ? const Icon(Icons.photo_camera, size: 50, color: primaryColor)
                        : null,
                  ),

                  // Nome e preço
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          parkData['name'] ?? 'Parque Sem Nome',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${parkData['price'] ?? 'Gratuito'} €',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                  ),

                  // Localização e detalhes
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.chat),
                    label: const Text('Chat'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (parkData['parkId'] == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ID do parque não encontrado.')),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            parkId: parkData['parkId']!,
                            userId: FirebaseAuth.instance.currentUser!.uid,
                            ownerId: parkData['ownerid'],  // com i minúsculo para bater com o mapa
                            owner: parkData['owner'] ,
                          ),

                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.call),
                    label: const Text('Ligar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Lógica para chamada telefónica
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
