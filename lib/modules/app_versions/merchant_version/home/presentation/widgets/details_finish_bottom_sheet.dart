import 'package:bastoga/core/utils/colors.dart';
import 'package:flutter/material.dart';

import 'row_icon_text.dart';

class DetailsFinishBottomSheet extends StatelessWidget {
  const DetailsFinishBottomSheet({super.key, required this.onTapFinish, required this.onTapCancel});

  final VoidCallback onTapFinish, onTapCancel;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: onTapCancel,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.white,
                  border: Border.all(color: AppColors.redE7),
                ),
                child: const RowIconText(
                  icon: Icons.close,
                  text: "إلغاء الطلب",
                  fontColor: AppColors.redE7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
