import 'package:blog_hub_app/shared/animated_icon.dart';
import 'package:blog_hub_app/shared/inputs/input_button.dart';
import 'package:flutter/material.dart' hide AnimatedIcon;


class CustomAlertDialog extends Dialog {
  final String title;
  final String message;
  final Color color;
  final IconData icon;
  final String? buttonText;
  final void Function()? onPressed;
  final bool hasCancelButton;
  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.color,
    required this.icon,
    this.hasCancelButton = true,
    this.buttonText,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Row(
        children: [
          AnimatedIcon(
            color: color,
            icon: icon,
            iconSize: 32,
            iconColor: color,
            enableAnimation: true,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      actions: <Widget>[
        if (hasCancelButton)
          InputButton(
            text: "CANCEL",
            onPressed: Navigator.of(context).pop,
            isOutlined: true,
          ),
        InputButton(
          onPressed: () {
            onPressed?.call();
            Navigator.of(context).pop();
          },
          text: buttonText ?? 'OK',
        ),
      ],
    );
  }
}
