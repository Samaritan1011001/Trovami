import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback? onTap;
  final double height;
  final double width;
  final double bottomMargin;
  final double borderWidth;
  final Color buttonColor;
  final Color? splashcolor;
  final Color? highlightColor;

  final TextStyle textStyle = const TextStyle(
      color: Color.fromRGBO(255, 255, 255, 0.4),
      fontSize: 16.0,
      fontWeight: FontWeight.bold);

  const RoundedButton(
      {super.key,
      required this.buttonName,
      this.onTap,
      this.height = 50.0,
      this.bottomMargin = 0.0,
      this.borderWidth = 0.0,
      this.width = double.infinity,
      this.buttonColor = Colors.transparent,
      this.splashcolor,
      this.highlightColor});

  @override
  Widget build(BuildContext context) {
    if (borderWidth != 0.0) {
      return InkWell(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          margin: EdgeInsets.only(bottom: bottomMargin),
          alignment: FractionalOffset.center,
          decoration: BoxDecoration(
              color: buttonColor,
              borderRadius:
                  const BorderRadius.all(Radius.circular(30.0)),
              border: Border.all(
                  color: const Color.fromRGBO(221, 221, 221, 1.0),
                  width: borderWidth)),
          child: Text(buttonName, style: textStyle),
        ),
        splashColor: splashcolor,
        highlightColor: highlightColor,
      );
    } else {
      return InkWell(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          margin: EdgeInsets.only(bottom: bottomMargin),
          alignment: FractionalOffset.center,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(30.0)),
            border: Border.all(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          child: Text(buttonName, style: textStyle),
        ),
      );
    }
  }
}
