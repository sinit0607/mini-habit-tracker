import 'package:flutter/material.dart';

class SnackbarUtil {
  static void showInstagramStyle(
      BuildContext context,
      String message, {
        Color backgroundColor = Colors.black87,
        Duration duration = const Duration(seconds: 2),
        SnackBarPosition position = SnackBarPosition.bottom,
      }) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: position == SnackBarPosition.bottom ? 16 : 0.0,
        top: position == SnackBarPosition.top ? 64 : 0.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      backgroundColor: backgroundColor,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
      duration: duration,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

enum SnackBarPosition {
  top,
  bottom,
}
