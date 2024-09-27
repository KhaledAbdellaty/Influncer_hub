import 'package:blog_hub_app/shared/utils/theme_helper.dart';
import 'package:flutter/material.dart';

class InputButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool disabled;

  final String text;
  final bool isOutlined;
  const InputButton({
    Key? key,
    required this.text,
    this.isOutlined = false,
    this.disabled = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (!disabled) ? onPressed : null,
      style: ButtonStyle(
        shape: isOutlined
            ? MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(
                    width: 2,
                    color: AppColors.primaryColor,
                  ),
                ),
              )
            : MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
        backgroundColor: MaterialStateProperty.all(
          isOutlined ? Colors.white : AppColors.primaryColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: isOutlined
              ? const TextStyle(
                  color: AppColors.primaryColor,
                )
              : null,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
