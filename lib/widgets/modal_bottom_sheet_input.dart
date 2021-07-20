import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ModalBottomSheetInput extends StatefulWidget {
  const ModalBottomSheetInput({
    Key? key,
    required this.labelText,
    required this.onSaved,
    required this.type,
    this.initialValue,
  }) : super(key: key);

  final String labelText;
  final void Function(String? value) onSaved;
  final String type;
  final String? initialValue;

  @override
  _ModalBottomSheetInputState createState() => _ModalBottomSheetInputState();
}

class _ModalBottomSheetInputState extends State<ModalBottomSheetInput> {
  TextInputType _getKeyBoardType() {
    switch (widget.type) {
      case "text":
        return TextInputType.text;
      case "number":
        return TextInputType.numberWithOptions(decimal: true);
      default:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter>? _getFormatters() {
    switch (widget.type) {
      case "text":
        return null;
      case "number":
        return [
          FilteringTextInputFormatter(
            RegExp('[0-9]{1,}\.?[0-9]{0,2}'),
            allow: true,
          )
        ];
      default:
    }
  }

  void _onSaved(String? value) {
    var output = value;
    if (widget.type == 'number' && value != null) {
      output = value.replaceAll(RegExp(r','), ".");
    }
    widget.onSaved(output);
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field required';
    } else if (widget.type == 'number') {
      var numberOfDecimalSeparators = 0;
      for (var i = 0; i < value.length; i++) {
        var char = value[i];
        if (char == '.' || char == ',') {
          numberOfDecimalSeparators++;
        }
      }
      if (numberOfDecimalSeparators > 1) {
        return 'Invalid number';
      }
    }

    return null;
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
      validator: _validator,
      onSaved: _onSaved,
      keyboardType: _getKeyBoardType(),
      inputFormatters: _getFormatters(),
    );
  }
}
