import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {required this.texts,
      required this.isMe,
      required this.userid,
      required this.userimage});
  final String userimage;
  final String userid;
  final String texts;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(userid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text(
                  'loading',
                  style: TextStyle(
                    fontSize: 12,
                    color: isMe ? Colors.red : Colors.red,
                  ),
                );
              }

              if (snapshot.hasError) {
                return const Text(
                  'Error loading username',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                );
              }

              final username =
                  snapshot.data?.get('username') as String? ?? 'Unknown';

              return Text(
                username,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              );
            },
          ),
        ),
        Container(
          constraints:
              const BoxConstraints(maxWidth: 175), // Limiting message width
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isMe
                      ? const Color.fromARGB(255, 92, 161, 234)
                      : const Color.fromARGB(255, 69, 162, 238),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: Radius.circular(isMe ? 12 : 12),
                    bottomRight: Radius.circular(isMe ? 12 : 12),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      texts,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                child: CircleAvatar(
                  radius: 8,
                  backgroundImage: NetworkImage(userimage),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }
}
