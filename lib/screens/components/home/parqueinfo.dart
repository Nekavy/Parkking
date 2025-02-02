// parqueinfo.dart
import 'package:flutter/material.dart';

class ParkInfo extends StatelessWidget {
  final Map<String, dynamic> parkData;

  const ParkInfo({super.key, required this.parkData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(parkData['name'] ?? 'Detalhes do Parque'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detalhes do Parque: ${parkData['name']}'),
            // Adicione mais elementos conforme necessário
          ],
        ),
      ),
    );
  }
}