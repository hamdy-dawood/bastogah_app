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
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onTapAccept,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.blue2Color,
                  ),
                  child: const RowIconText(icon: Icons.check, text: "قبول"),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: InkWell(
                onTap: onTapReject,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.redE7,
                  ),
                  child: const RowIconText(icon: Icons.close, text: "رفض"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
