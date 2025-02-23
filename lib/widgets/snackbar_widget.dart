import 'package:flutter/material.dart';

class SnackbarService {
  static void showDetails(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(message), 
        backgroundColor: color,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating, 
        margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
      ),
    );
  }
}
