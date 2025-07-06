import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String parkId;
  final String userId;

  ChatScreen({required this.parkId, required this.userId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final DatabaseReference _messageRef = FirebaseDatabase.instance.ref("chats");

  void sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      final messageId = _messageRef.child(widget.parkId).child("messages").push().key;
      await _messageRef.child(widget.parkId).child("messages").child(messageId!).set({
        'sender': widget.userId,
        'message': message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      // Atualizar a lista de chats ativos do utilizador com a última mensagem
      FirebaseDatabase.instance.ref("users/${widget.userId}/chats/${widget.parkId}").set({
        'lastMessage': message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat com o Parque')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _messageRef
                  .child(widget.parkId)
                  .child("messages")
                  .orderByChild('timestamp') // Garantir a ordenação correta
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  final messages = (snapshot.data! as DatabaseEvent).snapshot.value;
                  if (messages == null) {
                    return Center(child: Text('Sem mensagens ainda.'));
                  }

                  // Organizando as mensagens pela chave do timestamp
                  List<Widget> messageWidgets = [];
                  Map<dynamic, dynamic> messagesMap = messages as Map<dynamic, dynamic>;
                  
                  // Ordenando as mensagens pelo timestamp
                  var sortedMessages = messagesMap.entries.toList()
                    ..sort((a, b) => (a.value['timestamp'] as int).compareTo(b.value['timestamp']));

                  // Criando os widgets de mensagem
                  for (var entry in sortedMessages) {
                    final messageData = entry.value;
                    final sender = messageData['sender'];
                    final message = messageData['message'];

                    messageWidgets.add(
                      ListTile(
                        title: Text(sender),
                        subtitle: Text(message),
                      ),
                    );
                  }

                  return ListView(children: messageWidgets);
                }

                return Center(child: Text('Erro ao carregar mensagens.'));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Escreva uma mensagem...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
