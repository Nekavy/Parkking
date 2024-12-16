import 'package:flutter/material.dart';
import 'screens/intro_slider.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const ParkKingApp());
}

class ParkKingApp extends StatelessWidget {
  const ParkKingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkKing',
      debugShowCheckedModeBanner: false, // Remove o rótulo de debug
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/intro', // Rota inicial
      routes: {
        '/intro': (context) => IntroSliderPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
