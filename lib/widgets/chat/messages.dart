import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final chatDocs = chatSnapshot.data.documents;
        return ListView.builder(
          reverse: true,
          itemBuilder: (context, index) => MessageBubble(
              chatDocs[index]['text'],
              chatDocs[index]['userName'],
              chatDocs[index]['userId'] ==
                  FirebaseAuth.instance.currentUser.uid,
              key: ValueKey(chatDocs[index])),
          itemCount: chatDocs.length,
        );
      },
    );
  }
}
