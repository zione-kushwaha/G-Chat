import 'package:FLUTTER_APPLICATION_1/chats/message.dart';
import 'package:FLUTTER_APPLICATION_1/chats/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class chat_screen extends StatelessWidget {
  const chat_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'G-Chat',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        actions: [
          DropdownButton(
              underline: Container(),
              icon: const Icon(Icons.more_vert),
              items: [
                DropdownMenuItem(
                    value: 'logout',
                    child: Container(
                      child: const Row(
                        children: [
                          Icon(Icons.exit_to_app),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Log out')
                        ],
                      ),
                    ))
              ],
              onChanged: (identifer) {
                if (identifer == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              })
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.only(left: 7, right: 7),
        child: Column(
          children: [Expanded(child: Messages()), NewMessages()],
        ),
      ),
    );
  }
}
