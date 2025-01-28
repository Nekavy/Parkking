import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/intro_slider.dart'; // Exemplo de tela
import 'screens/home_page.dart';
import 'screens/login_page.dart'; // Exemplo de tela de login
import 'screens/register_page.dart'; // Exemplo de tela de login

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Garante que os bindings do Flutter estão prontos
  try {
    // Inicializa o Firebase
    await Firebase.initializeApp();
  } catch (e) {
    print("Erro ao inicializar o Firebase: $e");
  }
  runApp(ParkKingApp());  // Chama o app após a inicialização
}

class ParkKingApp extends StatelessWidget {
  const ParkKingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkKing',
      debugShowCheckedModeBanner: false,  // Remove o banner de debug
      theme: ThemeData(
        primarySwatch: Colors.blue, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/intro',  // Rota inicial
      routes: {
        '/intro': (context) => IntroSliderPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}
