import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class Snack {
  showFlushbar({
    required BuildContext context,
    required String message,
    required Widget? icon,
  }) {
    double deviceWidth = MediaQuery.of(context).size.width;
    Flushbar(
      messageText: Center(
          child: Text(message, style: const TextStyle(color: Colors.white))),
      shouldIconPulse: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: const Duration(seconds: 5),
      borderColor: Colors.white.withOpacity(0.04),
      borderWidth: 1,
      icon: icon,
      backgroundColor: Colors.black45,
      flushbarStyle: FlushbarStyle.FLOATING,
      isDismissible: true,
      barBlur: 18,
      margin: EdgeInsets.only(
          bottom: 20, left: deviceWidth / 7, right: deviceWidth / 7),
      borderRadius: BorderRadius.circular(15),
    ).show(context);
  }
}
