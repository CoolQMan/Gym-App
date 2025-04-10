// lib/widgets/common/custom_button.dart
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool outline;
  final double? width;
  final double height;
  final bool isLoading;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.outline = false,
    this.width,
    this.height = 50.0,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              outline ? Colors.transparent : (backgroundColor ?? Colors.white),
          foregroundColor: outline ? Colors.white : (textColor ?? Colors.black),
          side: outline ? const BorderSide(color: Colors.white) : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child:
            isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: outline ? Colors.white : (textColor ?? Colors.black),
                  ),
                ),
      ),
    );
  }
}
