import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    Key key,
    @required this.label,
    @required this.onPressed,
  }) : super(key: key);

  final String label;
  final ValueChanged<BuildContext> onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 8)),
        foregroundColor:
        MaterialStateProperty.all(Colors.white),
        overlayColor: MaterialStateProperty.all(
            Color(0x66FFFFFF)),
        backgroundColor:
        MaterialStateProperty.all( Colors.black),
      ),
      onPressed: () => onPressed(context),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }
}
