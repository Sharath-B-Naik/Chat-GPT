import 'package:chat_gpt/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AppUtils {
  static void snackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText(
          message,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );
  }
}
