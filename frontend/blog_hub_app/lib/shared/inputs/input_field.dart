import 'package:blog_hub_app/shared/utils/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSaved;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final String? hintText;
  final double? width;
  final TextDirection? textDirection;
  final bool obscureText;
  final bool? isValid;
  final bool? enabled;
  final String? labelText;
  final bool expands;
  final bool inTable;
  final Widget? prefixIcon;
  final bool numbersOnly;
  final EdgeInsets? margin;
  bool? readonly;
  InputField({
    Key? key,
    this.textDirection = TextDirection.ltr,
    this.controller,
    this.onChanged,
    this.validator,
    this.obscureText = false,
    this.isValid,
    this.prefixIcon,
    this.onSaved,
    this.labelText,
    this.expands = false,
    this.inTable = false,
    this.width,
    this.margin = const EdgeInsets.only(bottom: 20.0, top: 10),
    this.onTap,
    this.hintText,
    this.enabled,
    this.readonly = false,
    this.numbersOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = 50.0;
    if (inTable) h = 32.0;
    if (expands) h = 100.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null) Text(labelText!),
        Container(
          width: width,
          height: (isValid != null) ? (h + (!isValid! ? 20 : 0)) : h,
          margin: margin,
          child: TextFormField(
            inputFormatters: numbersOnly
                ? [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2)
                  ]
                : null,
            enabled: enabled ?? true,
            readOnly: readonly!,
            textDirection: textDirection,
            onTap: onTap,
            expands: expands,
            maxLines: !expands ? 1 : null,
            controller: controller,
            onChanged: onChanged,
            onSaved: onSaved,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            obscureText: obscureText,
            textAlignVertical:
                expands ? TextAlignVertical.top : TextAlignVertical.bottom,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              hintText: hintText,
              errorStyle: const TextStyle(fontSize: 12, color: Colors.red),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
