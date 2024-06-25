import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  Function()? onPressed;
  Color? backgroundColor;
  Color? foregroundColor;
  Widget? child;
  CustomButton(
      {super.key,
      this.onPressed,
      this.child,
      this.backgroundColor,
      this.foregroundColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.95,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor),
          onPressed: onPressed,
          child: child),
    );
  }
}
