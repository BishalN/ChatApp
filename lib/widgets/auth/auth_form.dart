import 'dart:io';

import 'package:flutter/material.dart';

import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  var isLoading;

  final void Function(String email, String password, String username,
      File imageFile, bool isLogin, BuildContext ctx) submitFn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userName = '';
  var _userPassword = '';
  var _userEmail = '';
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    //Close the soft keyboard
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please Pick an Image'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          _userImageFile, _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    key: ValueKey('Email'),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please Enter a valid Email Address';
                      }
                      return null;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      enableSuggestions: false,
                      key: ValueKey('Username'),
                      onSaved: (value) {
                        _userName = value;
                      },
                      decoration: InputDecoration(labelText: 'User name'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'username should be at least be 4 character long';
                        }
                        return null;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('Password'),
                    onSaved: (value) {
                      _userPassword = value;
                    },
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Please enter at least 7 characters long';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'SignUp'),
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create New Account'
                          : 'I already have an account'),
                      textColor: Theme.of(context).primaryColor,
                    )
                ],
              )),
        ),
      ),
    ));
  }
}
