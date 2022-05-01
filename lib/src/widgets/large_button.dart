import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  final void Function() onPressed;
  final Color color;
  final String text;

  LargeButton({this.color, this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        textColor: Colors.white,
        elevation: 5.0,
        onPressed: onPressed,
        child: Text(text),
        color: color,
      ),
    );
  }
}
