import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({Key? key});

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  var messages_entered = '';
  final TextEditingController text = TextEditingController();
  void sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance.collection('chats').add({
      'text': messages_entered,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'image': userData['url']
    });
    text.clear();
    messages_entered = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: text,
              onChanged: (value) {
                setState(() {
                  messages_entered = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Send Message....'),
            ),
          ),
          IconButton(
            onPressed: messages_entered.trim().isEmpty ? null : sendMessage,
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
