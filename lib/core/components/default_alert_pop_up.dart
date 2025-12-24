import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/constance.dart';

class DefaultAlertPopUp extends StatelessWidget {
  final String alertTitle;
  final Widget content;
  final Widget buttonContent;
  final void Function()? onButtonClick;

  const DefaultAlertPopUp({
    super.key,
    required this.alertTitle,
    required this.content,
    required this.buttonContent,
    required this.onButtonClick,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(),
      content: Container(
        decoration: BoxDecoration(
          color: const Color(0xfffcfcff),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey9A.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(3, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alertTitle,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => context.pop(),
                    child: const Icon(CupertinoIcons.clear_circled, size: 21.0, color: Colors.grey),
                  ),
                ],
              ),
            ),
            AppConstance.horizontalDivider,
            const SizedBox(height: 16.0),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: content),
            GestureDetector(
              onTap: onButtonClick,
              child: Container(
                // height: 40,
                width: MediaQuery.sizeOf(context).width,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.defaultColor,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: AppColors.defaultColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: buttonContent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
