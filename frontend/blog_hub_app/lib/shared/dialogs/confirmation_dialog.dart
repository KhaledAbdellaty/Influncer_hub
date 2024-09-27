import 'package:flutter/material.dart';

class ConfiramtionDialog {
  ConfiramtionDialog.show(BuildContext context, Widget child) {
    showGeneralDialog(
      context: context,
      transitionBuilder: (_, animation, secondaryAnimation, child) {
        var curve = Curves.easeInOut.transform(animation.value);
        return Transform.scale(scale: curve, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, animation, secondaryAnimation) {
        return child;
      },
    );
  }
}
