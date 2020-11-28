import 'package:ChatUp/widgets/chat/messages.dart';
import 'package:ChatUp/widgets/chat/new_message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      return;
    }, onLaunch: (msg) {
      return;
    }, onResume: (msg) {
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[50],
        title: const Text(
          'ChatUp',
          style: TextStyle(color: Colors.pink),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.pink,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
