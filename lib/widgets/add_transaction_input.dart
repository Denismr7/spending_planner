import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTransactionInput extends StatefulWidget {
  // TODO: Change name to ModalBottomSheetInput
  const AddTransactionInput({
    Key? key,
    required this.labelText,
    required this.validator,
    required this.onSaved,
    required this.type,
    this.initialValue,
  }) : super(key: key);

  final String labelText;
  final String? Function(String? value) validator;
  final void Function(String? value) onSaved;
  final String type;
  final String? initialValue;

  @override
  _AddTransactionInputState createState() => _AddTransactionInputState();
}

class _AddTransactionInputState extends State<AddTransactionInput> {
  TextInputType _getKeyBoardType() {
    switch (widget.type) {
      case "text":
        return TextInputType.text;
      case "number":
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter>? _getFormatters() {
    switch (widget.type) {
      case "text":
        return null;
      case "number":
        return [FilteringTextInputFormatter.digitsOnly];
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue ?? null,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      validator: widget.validator,
      onSaved: widget.onSaved,
      keyboardType: _getKeyBoardType(),
      inputFormatters: _getFormatters(),
    );
  }
}
