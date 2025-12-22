import 'package:flutter/material.dart';

import '../utils/colors.dart';

class DialogHelper {
  static Future<void> showCustomDialog({
    required BuildContext context,
    void Function()? onDismiss,
    required Widget alertDialog,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alertDialog;
      },
    ).then((value) => onDismiss);
  }

  static Future<void> showCustomDropDown({
    required BuildContext context,
    required double arrowTop,
    required double? arrowRight,
    required double? arrowLeft,
    required double containerTop,
    required double? containerRight,
    required double? containerLeft,
    required List<Widget> list,
  }) {
    return showDialog(
      context: context,
      barrierColor: AppColors.black.withValues(alpha: 0.1),
      builder:
          (context) => Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                Positioned(
                  top: arrowTop,
                  right: arrowRight,
                  left: arrowLeft,
                  child: ClipPath(
                    clipper: ArrowClipper(),
                    child: Container(width: 30, height: 15, color: Colors.white),
                  ),
                ),
                Positioned(
                  top: containerTop,
                  right: containerRight,
                  left: containerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: list),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
