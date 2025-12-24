import 'package:bastoga/core/utils/colors.dart';
import 'package:flutter/material.dart';

import 'row_icon_text.dart';

class DetailsPendingBottomSheet extends StatelessWidget {
  const DetailsPendingBottomSheet({
    super.key,
    required this.onTapAccept,
    required this.onTapReject,
  });

  final VoidCallback onTapAccept, onTapReject;

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
              onTap: onTapAccept,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.defaultColor,
                ),
                child: const RowIconText(icon: Icons.check, text: "قبول الطلب"),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: onTapReject,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.white,
                  border: Border.all(color: AppColors.redE7),
                ),
                child: const RowIconText(
                  icon: Icons.close,
                  text: "رفض",
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
