import 'package:flutter/material.dart';

class SettingOption extends StatefulWidget {
  const SettingOption({
    required this.label,
    required this.icon,
    required this.simpleInput,
    required this.onChanged,
    required this.initialValue,
    this.inputType,
  });

  final String label;
  final IconData icon;
  final bool simpleInput;
  final Function(String? value) onChanged;
  final String initialValue;
  final TextInputType? inputType;

  @override
  _SettingOptionState createState() => _SettingOptionState();
}

class _SettingOptionState extends State<SettingOption> {
  var _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue;
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
                  onChanged: widget.onChanged,
                  keyboardType: widget.inputType,
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
