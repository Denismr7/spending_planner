import 'package:flutter/material.dart';

class SelectField extends StatefulWidget {
  const SelectField({
    Key? key,
    required this.items,
    required this.onChanged,
    required this.initialValue,
  }) : super(key: key);

  final String initialValue;
  final Map<String, String> items;
  final Function(String newValue) onChanged;

  @override
  _SelectFieldState createState() => _SelectFieldState();
}

class _SelectFieldState extends State<SelectField> {
  String _selectedValue = "";

  List<DropdownMenuItem> _buildDropdownItems(Map<String, String> items) {
    List<DropdownMenuItem> options = [];
    items.forEach((key, value) {
      options.add(DropdownMenuItem(
        child: Text(key.trim()),
        value: value.trim(),
      ));
    });

    return options;
  }

  void _onChangeValue(dynamic newValue) {
    final valueAsString = newValue.toString();
    setState(() {
      _selectedValue = valueAsString;
    });
    widget.onChanged(valueAsString);
  }

  @override
  Widget build(BuildContext context) {
    _selectedValue =
        _selectedValue.isEmpty ? widget.initialValue : _selectedValue;
    return Container(
      height: 55,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: DropdownButton(
        items: _buildDropdownItems(widget.items),
        onChanged: _onChangeValue,
        icon: const Icon(Icons.arrow_drop_down),
        underline: Container(height: 0),
        isExpanded: true,
        value: _selectedValue,
      ),
    );
  }
}
