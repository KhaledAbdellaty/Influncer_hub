import 'package:flutter/material.dart';


class CustomDropDownButton extends StatefulWidget {
  String value;
  final String hintText;
  final void Function(String?) onChanged;
  final bool isFilter;
  // final double width;
  CustomDropDownButton({
    super.key,
    required this.value,
    required this.hintText,
    required this.onChanged,
    this.isFilter = false,
    // required this.width,
  });

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: widget.isFilter ? null : widget.width,
      // width: MediaQuery.of(context).size.width * 0.1,
      height: 50,

      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey)),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            focusColor: Colors.white,
            value: widget.value,
            hint: Text(
              widget.hintText,
            ),
            alignment: Alignment.center,
            borderRadius: BorderRadius.circular(8.0),
            items: widget.isFilter
                ? const [
                    DropdownMenuItem(
                      value: '3',
                      child: Text('All'),
                    ),
                    DropdownMenuItem(
                      value: '0',
                      child: Text('Yes/No'),
                    ),
                    DropdownMenuItem(
                      value: '1',
                      child: Text('Text Box'),
                    ),
                    DropdownMenuItem(
                      value: '2',
                      child: Text('Star Rating'),
                    ),
                  ]
                : const [
                    DropdownMenuItem(
                      value: '0',
                      child: Text('Yes/No'),
                    ),
                    DropdownMenuItem(
                      value: '1',
                      child: Text('Text Box'),
                    ),
                    DropdownMenuItem(
                      value: '2',
                      child: Text('Star Rating'),
                    ),
                  ],
            onChanged: (value) {
              setState(() {
                widget.value = value.toString();
                widget.onChanged(value);
              });
            },
          ),
        ),
      ),
    );
  }
}
