import 'package:flutter/material.dart';

import '../../models/user.dart';

class SettingOption extends StatefulWidget {
  const SettingOption({
    required this.label,
    required this.icon,
    required this.simpleInput,
    required this.initialValue,
    this.onChanged,
    this.setting,
    this.inputType,
    this.onTapDetail,
    this.detailIcon,
  });

  final String label;
  final IconData icon;
  final bool simpleInput;
  final Function(String? value)? onChanged;
  final dynamic initialValue;
  final TextInputType? inputType;
  final Setting? setting;
  final VoidCallback? onTapDetail;
  final IconData? detailIcon;

  @override
  _SettingOptionState createState() => _SettingOptionState();
}

class _SettingOptionState extends State<SettingOption> {
  var _controller = TextEditingController();
  String? _errorMessage;

  void _onChanged(String? value) {
    if (!isValid(value)) {
      // Send null to remove value from the map
      widget.onChanged!(null);
      return;
    }

    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }

    widget.onChanged!(value);
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
    } else if (widget.inputType == TextInputType.number ||
        widget.inputType == TextInputType.numberWithOptions(decimal: true)) {
      var numberOfDecimalSeparators = 0;
      for (var i = 0; i < value.length; i++) {
        var char = value[i];
        if (char == '.' || char == ',') {
          numberOfDecimalSeparators++;
        }
      }
      if (numberOfDecimalSeparators > 1) {
        setState(() {
          _errorMessage = 'Invalid';
        });
        return false;
      }
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null && widget.simpleInput) {
      _controller.text = widget.initialValue.toString();
    }
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
                onPressed: widget.onTapDetail,
                icon: Icon(widget.detailIcon),
              ),
      ],
    );
  }
}
