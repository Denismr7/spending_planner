import 'package:flutter/material.dart';

import '../models/user.dart';

class SettingOption extends StatefulWidget {
  const SettingOption({
    required this.label,
    required this.icon,
    required this.simpleInput,
    required this.onChanged,
    required this.initialValue,
    required this.setting,
    this.inputType,
  });

  final String label;
  final IconData icon;
  final bool simpleInput;
  final Function(String? value) onChanged;
  final String initialValue;
  final TextInputType? inputType;
  final Setting setting;

  @override
  _SettingOptionState createState() => _SettingOptionState();
}

class _SettingOptionState extends State<SettingOption> {
  var _controller = TextEditingController();
  String? _errorMessage;

  void _onChanged(String? value) {
    if (!isValid(value)) {
      // Send null to remove value from the map
      widget.onChanged(null);
      return;
    }

    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }

    widget.onChanged(value);
  }

  bool isValid(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        _errorMessage = "Field required";
      });
      return false;
    } else if (widget.setting == Setting.Currency && value.length > 3) {
      setState(() {
        _errorMessage = "Invalid value";
      });
      return false;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              widget.icon,
              size: 35,
              color: Theme.of(context).accentColor,
            ),
            const SizedBox(width: 15),
            Text(
              widget.label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        widget.simpleInput
            ? Container(
                width: 80,
                child: TextField(
                  controller: _controller,
                  onChanged: _onChanged,
                  keyboardType: widget.inputType,
                  decoration: InputDecoration(
                    errorText: _errorMessage,
                  ),
                ),
              )
            : IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward),
              ),
      ],
    );
  }
}
