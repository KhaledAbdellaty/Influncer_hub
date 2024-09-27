import 'package:blog_hub_app/shared/utils/theme_helper.dart';
import 'package:flutter/material.dart';

class LoadingButton<T> extends StatelessWidget {
  final void Function() onPressed;
  final bool isLoading;
  final bool isValid;
  final String title;
  final Size buttonSize;
  const LoadingButton({
    Key? key,
    required this.isLoading,
    required this.isValid,
    required this.title,
    required this.buttonSize,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      width: isLoading ? 80 : null,
      curve: Curves.easeIn,
      child: Center(
        child: ElevatedButton(
          onPressed: isValid ? onPressed : null,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
            fixedSize: MaterialStateProperty.all(buttonSize),
          ),
          child: isLoading
              ? const Padding(  
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : const Text('continue'),
        ),
      ),
    );
  }
}
