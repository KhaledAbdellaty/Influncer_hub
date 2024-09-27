import 'package:blog_hub_app/shared/animated_icon.dart';
import 'package:blog_hub_app/shared/dialogs/alert_dialog.dart';
import 'package:blog_hub_app/shared/utils/snackbar.dart';
import 'package:flutter/material.dart' hide AnimatedIcon;


enum AlertType {
  success,
  error,
  info,
  warning,
}

enum ToastPosition {
  top,
  bottom,
}

class Alerts {
  final BuildContext context;
  late final Color _color;
  late final IconData _icon;

  Alerts.showDialog(
    this.context, {
    required String title,
    required String message,
    required AlertType alertType,
    bool? hasCancelButton,
    bool dismissable = true,
    void Function()? onPressed,
  }) {
    _renderIcons(alertType);
    showDialog(
        barrierDismissible: dismissable,
        context: context,
        builder: (BuildContext context) => CustomAlertDialog(
              title: title,
              message: message,
              color: _color,
              icon: _icon,
              hasCancelButton: hasCancelButton ?? true,
              onPressed: onPressed,
            ));
  }

  Alerts.dismissDialog(this.context) {
    Navigator.of(context).pop();
  }

  /// Show a toast message at the bottom of the screen
  /// use [ToastPosition.top] or [ToastPosition.bottom] to change the position of the toast
  Alerts.showSnackBar(
    this.context, {
    required String title,
    required AlertType alertType,
    String? message,
    double edgeSpacing = 10.0,
    ToastPosition position = ToastPosition.bottom,
  }) {
    _renderIcons(alertType);

    ScaffoldMessenger.of(context).showSnackBar(
      LisSnackBar(
        //clipBehavior: Clip.antiAliasWithSaveLayer,
        dismissDirection: DismissDirection.up,
        margin: EdgeInsets.only(
          // screen freazing because this margin..
          bottom: position == ToastPosition.top
              ? (MediaQuery.of(context).size.height * 0.84) - edgeSpacing
              // scaffold messenger send a snackbar from bottom to top
              : edgeSpacing,
          right: MediaQuery.of(context).size.width * 0.2,
          left: MediaQuery.of(context).size.width * 0.2,
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: message == null
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              AnimatedIcon(
                color: _color,
                icon: _icon,
                iconSize: 20,
                iconColor: _color,
                enableAnimation: true,
              ),
              Expanded(
                child: _renderContent(title: title, message: message),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _renderIcons(AlertType alertType) {
    if (alertType == AlertType.success) {
      _color = Colors.green;
      _icon = Icons.check;
    }
    if (alertType == AlertType.error) {
      _color = Colors.red;
      _icon = Icons.error;
    }
    if (alertType == AlertType.info) {
      _color = Colors.blue;
      _icon = Icons.info;
    }
    if (alertType == AlertType.warning) {
      _color = Colors.orange;
      _icon = Icons.warning;
    }
  }

  Widget _renderContent({required String title, String? message}) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 5),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
