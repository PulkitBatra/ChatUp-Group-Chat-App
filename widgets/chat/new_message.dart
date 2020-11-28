import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();

  var _enteredMessage = '';
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData =
        // ignore: deprecated_member_use
        await Firestore.instance.collection('users').document(user.uid).get();
    // ignore: deprecated_member_use
    Firestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['imageUrl'],
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.pink, width: 2.0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: Colors.black,
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                hintText: 'Send a message',
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.send,
            ),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
