import 'package:flutter/material.dart';

import '../models/rounded_buttons.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.buttonText,
    required this.onPressed,
    required this.type,
  });
  final String buttonText;
  final VoidCallback onPressed;
  final RoundedButtons type;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: type == RoundedButtons.Elevated
          ? ElevatedButton(
              onPressed: onPressed,
              child: Text(buttonText),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              child: Text(buttonText),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                side: BorderSide(
                  color: Colors.black26,
                ),
              ),
            ),
    );
  }
}
