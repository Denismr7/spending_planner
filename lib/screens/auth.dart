import 'package:flutter/material.dart';

import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen();

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var isLogin = true;

  void _handleSave() {
    print('Handle Save!');
  }

  void _toggleLogin() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 70),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              child: Text(
                isLogin ? 'Log in' : 'Sign Up',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            AuthForm(
              isLogin: isLogin,
              handleSave: _handleSave,
              handleToggleLogin: _toggleLogin,
            )
          ],
        ),
      ),
    ));
  }
}
