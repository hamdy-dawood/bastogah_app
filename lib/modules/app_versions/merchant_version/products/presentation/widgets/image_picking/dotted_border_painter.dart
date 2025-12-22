import 'package:flutter/material.dart';

import '../../../../../../../core/utils/colors.dart';

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.black.withValues(alpha: 0.2) // Border color
          ..style =
              PaintingStyle
                  .stroke // Solid border style
          ..strokeWidth = 1.0; // Border width

    // Define the pattern for the dotted line (alternating gaps and dots)
    const dashLength = 5;
    const gapLength = 5;

    // Define the border radius
    const borderRadius = 10.0;

    final path = Path();

    // Draw the top border
    for (double x = borderRadius; x < size.width - borderRadius; x += dashLength + gapLength) {
      // path.lineTo(x + dashLength, 0);
      canvas.drawLine(Offset(x, 0), Offset(x + dashLength, 0), paint);
    }

    // Draw the top-right rounded corner
    path.arcTo(
      Rect.fromCircle(
        center: Offset(size.width - borderRadius, borderRadius),
        radius: borderRadius,
      ),
      -1.5708,
      1.5708,
      false,
    );

    // Draw the right border with rounded corners
    for (double y = borderRadius; y < size.height - borderRadius; y += dashLength + gapLength) {
      // path.lineTo(size.width, y + dashLength);
      canvas.drawLine(Offset(size.width, y), Offset(size.width, y + dashLength), paint);
    }

    // Move to the right-bottom point with rounded corner
    path.moveTo(size.width, size.height - borderRadius);

    // Draw the bottom-right rounded corner
    path.arcTo(
      Rect.fromCircle(
        center: Offset(size.width - borderRadius, size.height - borderRadius),
        radius: borderRadius,
      ),
      0,
      1.5708,
      false,
    );
    // Draw the bottom border with rounded corners
    for (double x = size.width - borderRadius - 8; x > borderRadius; x -= dashLength + gapLength) {
      // path.lineTo(x - dashLength, size.height);
      canvas.drawLine(Offset(x, size.height), Offset(x + dashLength, size.height), paint);
    }

    // Move to the left-bottom point with rounded corner
    path.moveTo(borderRadius, size.height);

    // Draw the bottom-left rounded corner
    path.arcTo(
      Rect.fromCircle(
        center: Offset(borderRadius, size.height - borderRadius),
        radius: borderRadius,
      ),
      1.5708,
      1.5708,
      false,
    );
    // Draw the left border with rounded corners
    for (double y = size.height - borderRadius - 5; y > borderRadius; y -= dashLength + gapLength) {
      // path.lineTo(0, y - dashLength);
      canvas.drawLine(Offset(0, y), Offset(0, y + dashLength), paint);
    }

    // Move to the left-top point with rounded corner
    path.moveTo(0, borderRadius);

    // Draw the top-left rounded corner
    path.arcTo(
      Rect.fromCircle(center: const Offset(borderRadius, borderRadius), radius: borderRadius),
      3.1416,
      1.5708,
      false,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
