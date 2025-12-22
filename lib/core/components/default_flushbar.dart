import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'custom_text.dart';

void showDefaultFlushBar({
  required BuildContext context,
  required Color color,
  required String messageText,
  ToastificationType notificationType = ToastificationType.error,
  int duration = 3,
}) {
  toastification.show(
    context: context,
    title: CustomText(
      text: messageText,
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 16,
      maxLines: 3,
    ),
    type: notificationType,
    style: ToastificationStyle.flat,
    alignment: Alignment.topCenter,
    direction: TextDirection.rtl,
    autoCloseDuration: Duration(seconds: duration),
    borderSide: const BorderSide(color: Colors.transparent, width: 0),
  );
}
