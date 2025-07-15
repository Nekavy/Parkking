import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String parkId;
  final String userId;
  final String ownerId;
  final String owner;
  final String? chatId;
  final String? username;

  ChatScreen({
    this.chatId,
    this.username,
    required this.parkId,
    required this.userId,
    required this.ownerId,
    required this.owner,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}
Future<String> _getUserNameById(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data();
        return data?['nome'] ?? '';
      }
    } catch (e) {
      print('Erro ao obter nome do utilizador ($userId): $e');
    }
    return '';
  }

class _ChatScreenState extends State<ChatScreen> {
  String username = "";  // variável mutável aqui
  final TextEditingController _messageController = TextEditingController();
  final DatabaseReference _messageRef = FirebaseDatabase.instance.ref("chats");

  //String get chatId => "${widget.parkId}_${widget.ownerId}_${widget.userId}";
  String get chatId => (widget.chatId != null && widget.chatId!.isNotEmpty)
    ? widget.chatId! 
    : "${widget.parkId}_${widget.ownerId}_${widget.userId}";


  void sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      final messageId = _messageRef.child(chatId).child("messages").push().key;
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      // Mensagem principal
      await _messageRef.child(chatId).child("messages").child(messageId!).set({
        'sender': widget.userId,
        'message': message,
        'timestamp': timestamp,
      });

      // Chat visível para o utilizador
      await FirebaseDatabase.instance
          .ref("users/${widget.userId}/chats/$chatId")
          .set({
        'lastMessage': message,
        'timestamp': timestamp,
        'parkId': widget.parkId,
        'ownerId': widget.ownerId,
        'owner': widget.owner,
      });

    final nome = await _getUserNameById(widget.userId);
    setState(() => username = nome.isNotEmpty ? nome : 'Sem Nome');
    print("usernamecliente: $username, id: ${widget.userId}");

      await FirebaseDatabase.instance
          .ref("users/${widget.ownerId}/chats/$chatId")
          .set({
        'lastMessage': message,
        'timestamp': timestamp,
        'parkId': widget.parkId,
        'userId': widget.userId,
        'username': username,
      });

      _messageController.clear();
    }
  }

  Widget _buildMessageBubble(String message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isMe ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(color: isMe ? Colors.white : Colors.black87, fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text((widget.owner.isNotEmpty ? widget.owner : (widget.username?.isNotEmpty == true ? widget.username! : '')),
                  style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('Parque ${widget.parkId}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70)),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _messageRef
                  .child(chatId)
                  .child("messages")
                  .orderByChild('timestamp')
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao carregar mensagens.'));
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('Sem mensagens ainda.'));
                }

                final dbEvent = snapshot.data as DatabaseEvent;
                final messages = dbEvent.snapshot.value;

                if (messages == null) {
                  return const Center(child: Text('Sem mensagens ainda.'));
                }

                Map<dynamic, dynamic> messagesMap = messages as Map<dynamic, dynamic>;
                var sortedMessages = messagesMap.entries.toList()
                  ..sort((a, b) =>
                      (a.value['timestamp'] as int)
                          .compareTo(b.value['timestamp'] as int));

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: sortedMessages.length,
                  reverse: false,
                  itemBuilder: (context, index) {
                    final messageData = sortedMessages[index].value;
                    final sender = messageData['sender'] ?? '';
                    final message = messageData['message'] ?? '';

                    final isMe = sender == widget.userId;

                    return _buildMessageBubble(message, isMe);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                        const InputDecoration(hintText: 'Escreva uma mensagem...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
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
