import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../mock.dart';
import '../models/budget.dart';
import '../models/category.dart';
import '../widgets/auth/auth_form.dart';
import '../models/auth_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen();

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var isLogin = true;

  Future<void> _handleSave(Map<AuthField, String> form) async {
    // Guard
    if (form.isEmpty) return;

    if (isLogin) {
      await _tryLogin(
        form[AuthField.Email]!,
        form[AuthField.Password]!,
      );
    } else {
      await _tryCreateAccount(
        form[AuthField.Email]!,
        form[AuthField.Password]!,
      );
    }
  }

  Future<UserCredential?> _tryCreateAccount(
      String email, String password) async {
    try {
      var authInstance = FirebaseAuth.instance;
      UserCredential userCredential =
          await authInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set default values
      var firebase = FirebaseFirestore.instance;
      Budget defaultBudget = Budget(smartBudget: false, limit: 100);
      List<Category> categories = categoriesMock;
      var currency = "€";

      await firebase.collection('users').doc(userCredential.user!.uid).set({
        'budget': jsonEncode(defaultBudget),
        'categories': jsonEncode(categories),
        'currency': currency,
        'email': email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      var message = "An error ocurred";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<UserCredential?> _tryLogin(String email, String password) async {
    try {
      var authInstance = FirebaseAuth.instance;
      UserCredential userCredential =
          await authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      var message = "An error ocurred";
      if (e.code == 'user-not-found') {
        message = 'Email not found.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
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
