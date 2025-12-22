import 'package:flutter/material.dart';

import '../../../../../../../core/utils/colors.dart';
import 'dotted_border_painter.dart';

class DottedImagesContainerView extends StatelessWidget {
  final void Function()? onTap;

  const DottedImagesContainerView({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedBorderPainter(),
      child: Container(
        height: 250,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.black.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 32, color: AppColors.black.withValues(alpha: 0.3)),
            const SizedBox(width: 8),
            InkWell(
              highlightColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              onTap: onTap,
              child: RichText(
                text: TextSpan(
                  text: 'اضغط هنا',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.defaultColor),
                  children: [
                    TextSpan(
                      text: '  لتحميل الصورة',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
