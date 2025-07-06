import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart'; // Importando o ChatScreen

class ChatManager extends StatelessWidget {
  final String userId;

  ChatManager({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chats Ativos')),
      body: StreamBuilder(
        stream: FirebaseDatabase.instance.ref("users/$userId/chats").onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            final chatsData = (snapshot.data! as DatabaseEvent).snapshot.value;
            if (chatsData == null) {
              return Center(child: Text('Nenhum chat ativo.'));
            }

            final List<Widget> chatList = [];
            (chatsData as Map).forEach((parkId, chatData) {
              final lastMessage = chatData['lastMessage'];
              final timestamp = chatData['timestamp'];

              chatList.add(
                ListTile(
                  title: Text('Chat com o Parque: $parkId'),
                  subtitle: Text('Última mensagem: $lastMessage'),
                  trailing: Text(
                    DateTime.fromMillisecondsSinceEpoch(timestamp).toString(),
                  ),
                  onTap: () {
                    // Navegar para o ChatScreen correspondente
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          parkId: parkId,
                          userId: userId,
                        ),
                      ),
                    );
                  },
                ),
              );
            });

            return ListView(children: chatList);
          }

          return Center(child: Text('Erro ao carregar chats.'));
        },
      ),
    );
  }
}
