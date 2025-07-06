import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importar para acessar o userId
import 'screens/intro_slider.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/profile_page.dart';
import 'screens/advertise.dart';
import 'screens/chat_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Erro ao inicializar o Firebase: $e");
  }
  runApp(ParkKingApp());
}

class ParkKingApp extends StatelessWidget {
  const ParkKingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkKing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/intro',
      routes: {
        '/intro': (context) => IntroSliderPage(),
        '/login': (context) => LoginPage(),
        '/ad': (context) => AdCreationPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/cm': (context) {
          final userId = FirebaseAuth.instance.currentUser?.uid;
          if (userId != null) {
            // Passar o userId para o ChatManager
            return ChatManager(userId: userId);
          } else {
            // Caso o usuário não esteja autenticado
            return Center(child: Text('Usuário não autenticado.'));
          }
        },
      },
    );
  }
}
