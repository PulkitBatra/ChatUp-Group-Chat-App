import 'package:ChatUp/constants.dart';
import 'package:ChatUp/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';
import '../../components/rounded_button.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitForm, this._isLoading);
  final void Function(
    String email,
    String password,
    String userName,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitForm;
  final bool _isLoading;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _userImageFile;
  var _isLogin = true;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text('Pleaase upload an image !'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState.save();
      widget.submitForm(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isLogin)
                    Flexible(
                      child: Container(
                        height: 170,
                        child: Image.asset('images/logo.png'),
                      ),
                    ),
                  if (_isLogin)
                    SizedBox(
                      height: 24,
                    ),
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    cursorColor: Colors.black,
                    key: ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    decoration: kTextFeildDecoration.copyWith(
                        hintText: 'Email Address'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Enter a valid email !';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    SizedBox(
                      height: 8,
                    ),
                  if (!_isLogin)
                    TextFormField(
                      cursorColor: Colors.black,
                      key: ValueKey('username'),
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Username must be at least 4 characters long !';
                        }
                        return null;
                      },
                      decoration:
                          kTextFeildDecoration.copyWith(hintText: 'Username'),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    cursorColor: Colors.black,
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        if (_isLogin) {
                          return 'Enter Password !';
                        } else {
                          return 'Password must be at least 7 characters long !';
                        }
                      }
                      return null;
                    },
                    decoration:
                        kTextFeildDecoration.copyWith(hintText: 'Password'),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget._isLoading) CircularProgressIndicator(),
                  if (!widget._isLoading)
                    RoundedButton(
                      written: _isLogin ? 'LogIn' : 'SignUp',
                      colour: Colors.pink[50],
                      onPressed: _trySubmit,
                    ),
                  if (!widget._isLoading)
                    FlatButton(
                      textColor: Colors.deepPurple,
                      child: Text(
                        _isLogin
                            ? 'Create new account'
                            : 'Already have an account',
                      ),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
