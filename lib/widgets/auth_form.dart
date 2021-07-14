import 'package:flutter/material.dart';
import 'package:spending_planner/widgets/rounded_form_field.dart';

import '../models/rounded_buttons.dart';
import 'rounded_button.dart';
import '../models/auth_field.dart';

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
  // Properties
  final _formKey = GlobalKey<FormState>();
  final Map<AuthField, String> _authData = Map();

  // Methods
  Widget _buildSizedBox() {
    return SizedBox(height: widget.isLogin ? 40 : 20);
  }

  String? _validateFormField(AuthField formField, String? value) {
    if (widget.isLogin && formField == AuthField.RepeatPassword) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    switch (formField) {
      case AuthField.Email:
        return _validateEmail(value);
      case AuthField.Password:
        return _validatePassword(value);
      case AuthField.RepeatPassword:
        return _validatePassword(value);
    }
  }

  String? _validateEmail(String value) {
    if (!value.contains("@") || value.length < 4) {
      return 'Invalid email';
    }

    return null;
  }

  String? _validatePassword(String value) {
    if (value.length < 6) {
      return 'Password is too short!';
    }

    return null;
  }

  _saveField(AuthField field, String? value) {
    _authData[field] = value!;
  }

  void _validateAndSubmitForm() {
    print('Validating...');
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    print('Email: ${_authData[AuthField.Email]}');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              RoundedFormField(
                validator: _validateFormField,
                onSave: _saveField,
                prefixIcon: Icon(Icons.person),
                field: AuthField.Email,
                labelText: 'Email',
                key: UniqueKey(),
              ),
              _buildSizedBox(),
              RoundedFormField(
                validator: _validateFormField,
                onSave: _saveField,
                prefixIcon: Icon(Icons.lock),
                field: AuthField.Password,
                labelText: 'Password',
              ),
              if (!widget.isLogin)
                Column(
                  children: [
                    _buildSizedBox(),
                    RoundedFormField(
                      validator: _validateFormField,
                      onSave: _saveField,
                      prefixIcon: Icon(Icons.lock),
                      field: AuthField.RepeatPassword,
                      labelText: 'Repeat password',
                    ),
                  ],
                ),
              _buildSizedBox(),
              RoundedButton(
                type: RoundedButtons.Elevated,
                buttonText: widget.isLogin ? 'Log in' : 'Sign up',
                onPressed: _validateAndSubmitForm,
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
                buttonText:
                    widget.isLogin ? 'Create account' : 'I have an account',
                onPressed: widget.handleToggleLogin,
              ),
            ],
          ),
        ));
  }
}
