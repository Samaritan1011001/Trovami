import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final IconData? icon;
  final String? hintText;
  final TextInputType? textInputType;
  final Color? textFieldColor;
  final Color? iconColor;
  final bool obscureText;
  final double bottomMargin;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final FormFieldValidator<String>? validateFunction;
  final FormFieldSetter<String>? onSaved;

  const InputField({
    super.key,
    this.hintText,
    this.obscureText = false,
    this.textInputType,
    this.textFieldColor,
    this.icon,
    this.iconColor,
    this.bottomMargin = 0.0,
    this.textStyle,
    this.validateFunction,
    this.onSaved,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: bottomMargin),
        child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              color: textFieldColor),
          child: TextFormField(
            style: textStyle,
            obscureText: obscureText,
            keyboardType: textInputType,
            validator: validateFunction,
            onSaved: onSaved,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: hintStyle,
              icon: Icon(
                icon,
                color: Colors.brown[200],
              ),
            ),
          ),
        ));
  }
}
