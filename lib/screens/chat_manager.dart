import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'chat_screen.dart';

class ChatManager extends StatelessWidget {
  final String userId;

  const ChatManager({
    required this.userId,
  });

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
            (chatsData as Map).forEach((chatId, chatData) {
              final lastMessage = chatData['lastMessage'] ?? '';
              final timestamp = chatData['timestamp'] ?? 0;
              final parkId = chatData['parkId'] ?? '';
              final ownerId = chatData['ownerId'] ?? '';
              final owner = chatData['owner'] ?? '';
              final username = chatData['username'] ?? '';

              chatList.add(
                ListTile(
                  title: Text('Parque: $parkId'),
                  subtitle: Text('Última mensagem: $lastMessage'),
                  trailing: Text(
                    DateTime.fromMillisecondsSinceEpoch(timestamp).toString(),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          chatId: chatId,  // aqui passas o chatId existente
                          parkId: parkId,
                          userId: userId,
                          owner: owner,
                          ownerId: ownerId,
                          username: username,
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
