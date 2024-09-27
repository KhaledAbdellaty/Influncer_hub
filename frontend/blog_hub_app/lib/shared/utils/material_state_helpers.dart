import 'package:blog_hub_app/shared/utils/theme_helper.dart';
import 'package:flutter/material.dart';

abstract class MaterialStateHelpers {
  static MaterialStateProperty<Color?> color({
    Color? hovered,
    Color? focused,
    Color? pressed,
    Color? dragged,
    Color? selected,
    Color? scrolledUnder,
    Color? disabled,
    Color? error,
  }) {
    return MaterialStateProperty.resolveWith(
      (states) {
        for (final state in states) {
          switch (state) {
            case MaterialState.hovered:
              return hovered ?? AppColors.primaryColor.withOpacity(0.75);
            default:
              return AppColors.primaryColor;
          }
        }
        return null;
      },
    );
  }
}
