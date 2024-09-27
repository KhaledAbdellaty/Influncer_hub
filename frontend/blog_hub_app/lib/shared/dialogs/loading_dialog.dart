import 'package:blog_hub_app/shared/utils/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingDialog extends StatelessWidget {
  final BuildContext context;
  final double? size;
  LoadingDialog.show(this.context, {super.key, this.size}) {
    showDialog(context: context, barrierDismissible: false, builder: (context) => this);
  }

  LoadingDialog.dismiss(this.context, {super.key, this.size}) {
    Navigator.of(context).pop();
  }

  const LoadingDialog(this.context, {super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: size ?? 100,
        child: const LoadingIndicator(
          indicatorType: Indicator.ballScale,
          colors: AppColors.colorShades,
        ),
      ),
    );
  }
}
