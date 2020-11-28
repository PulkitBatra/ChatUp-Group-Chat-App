import 'package:ChatUp/widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthForm(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user.uid + '.jpg');
        await ref.putFile(image);
        final url = await ref.getDownloadURL();

        // ignore: deprecated_member_use
        await Firestore.instance
            .collection('users')
            // ignore: deprecated_member_use
            .document(authResult.user.uid)
            // ignore: deprecated_member_use
            .setData({
          'username': username,
          'email': email,
          'imageUrl': url,
        });
      }
    } on PlatformException catch (error) {
      var message = 'An error occurred, please check your credentials !';
      if (error.message != null) {
        message = error.message;
      }
      print(message);
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      var message = 'An error occurred, please check your credentials !';
      if (error.message != null) {
        message = error.message;
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
