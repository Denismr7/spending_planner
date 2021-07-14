import 'package:flutter/material.dart';

import '../models/auth_field.dart';

class RoundedFormField extends StatefulWidget {
  const RoundedFormField({
    Key? key,
    required this.validator,
    required this.onSave,
    required this.prefixIcon,
    required this.field,
    required this.labelText,
  }) : super(key: key);

  final String labelText;
  final Icon prefixIcon;
  final AuthField field;
  final Function(AuthField field, String? value) validator;
  final Function(AuthField field, String? value) onSave;

  @override
  _RoundedFormFieldState createState() => _RoundedFormFieldState();
}

class _RoundedFormFieldState extends State<RoundedFormField> {
  var _hideText = true;

  TextInputType? _getKeyboardType() {
    if (widget.field == AuthField.Email) {
      return TextInputType.emailAddress;
    } else if (widget.field == AuthField.Password ||
        widget.field == AuthField.RepeatPassword) {
      return TextInputType.visiblePassword;
    }
  }

  _toggleVisiblity() {
    setState(() {
      _hideText = !_hideText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: _getKeyboardType(),
      obscureText: widget.field == AuthField.Password ||
              widget.field == AuthField.RepeatPassword
          ? _hideText
          : false,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.field == AuthField.Password ||
                widget.field == AuthField.RepeatPassword
            ? IconButton(
                onPressed: _toggleVisiblity,
                icon: Icon(
                  _hideText ? Icons.visibility : Icons.visibility_off,
                ),
              )
            : null,
        labelText: widget.labelText,
        labelStyle: const TextStyle(
          color: const Color.fromARGB(200, 28, 28, 28),
          fontSize: 20,
        ),
        border: const OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          borderSide: const BorderSide(
            width: 2.0,
            color: const Color.fromARGB(50, 28, 28, 28),
          ),
        ),
      ),
      validator: (value) => widget.validator(widget.field, value),
      onSaved: (value) => widget.onSave(widget.field, value!),
    );
  }
}
