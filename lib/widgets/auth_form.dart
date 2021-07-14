import 'package:flutter/material.dart';

import '../models/rounded_buttons.dart';
import 'RoundedElevatedButton.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final Function handleSave;
  final VoidCallback handleToggleLogin;
  const AuthForm({
    required this.isLogin,
    required this.handleSave,
    required this.handleToggleLogin,
  });

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  Widget _buildSizedBox() {
    return SizedBox(height: widget.isLogin ? 40 : 20);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: const Color.fromARGB(200, 28, 28, 28),
                  fontSize: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  borderSide: const BorderSide(
                    width: 2.0,
                    color: const Color.fromARGB(50, 28, 28, 28),
                  ),
                )),
          ),
          _buildSizedBox(),
          TextFormField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: const Color.fromARGB(200, 28, 28, 28),
                  fontSize: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  borderSide: const BorderSide(
                    width: 2.0,
                    color: const Color.fromARGB(50, 28, 28, 28),
                  ),
                )),
          ),
          if (!widget.isLogin)
            Column(
              children: [
                _buildSizedBox(),
                TextFormField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Repeat password',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(200, 28, 28, 28),
                        fontSize: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        borderSide: const BorderSide(
                          width: 2.0,
                          color: const Color.fromARGB(50, 28, 28, 28),
                        ),
                      )),
                ),
              ],
            ),
          _buildSizedBox(),
          RoundedButton(
            type: RoundedButtons.Elevated,
            buttonText: widget.isLogin ? 'Log in' : 'Sign up',
            onPressed: () {},
          ),
          _buildSizedBox(),
          const Text(
            'OR',
            style: TextStyle(
              fontSize: 16,
              color: const Color.fromARGB(200, 28, 28, 28),
            ),
          ),
          _buildSizedBox(),
          RoundedButton(
            type: RoundedButtons.Outlined,
            buttonText: widget.isLogin ? 'Create account' : 'I have an account',
            onPressed: widget.handleToggleLogin,
          ),
        ],
      ),
    ));
  }
}
