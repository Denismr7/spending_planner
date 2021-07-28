import 'package:flutter/material.dart';

class IconOption extends StatelessWidget {
  const IconOption(
      {Key? key, required this.icon, required this.text, this.onPressed})
      : super(key: key);

  final Icon icon;
  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.normal,
            color: Color.fromRGBO(54, 54, 54, 1),
          ),
        ),
      ),
    );
  }
}
