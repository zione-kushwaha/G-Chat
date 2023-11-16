import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:FLUTTER_APPLICATION_1/chats/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final User? user = authSnapshot.data as User?;

        if (user == null) {
          // No user is signed in, you can handle this case accordingly
          return const Center(
            child: Text('No user signed in'),
          );
        }

        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final chatDocs = snapshot.data!.docs;

            return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (context, index) {
                return MessageBubble(
                  userimage: chatDocs[index]['image'],
                  userid: chatDocs[index]['userId'].toString(),
                  texts: chatDocs[index]['text'].toString(),
                  isMe: chatDocs[index]['userId'] == user.uid,
                );
              },
            );
          },
        );
      },
    );
  }
}
