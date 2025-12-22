import 'package:flutter/material.dart';

import 'otp.dart';

class OTPWithContext {
  final String phone;
  final OTP otp;
  final BuildContext context;

  OTPWithContext({required this.phone, required this.otp, required this.context});
}
