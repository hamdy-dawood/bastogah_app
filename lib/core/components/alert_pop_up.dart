import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertPopUp extends StatelessWidget {
  final String alertTitle;
  final String? confirmText;
  final Widget content;
  final void Function()? onButtonClick;
  final void Function()? onButtonCancel;

  const AlertPopUp({
    super.key,
    required this.alertTitle,
    this.confirmText,
    required this.content,
    required this.onButtonClick,
    required this.onButtonCancel,
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
              color: Colors.black12.withValues(alpha: 0.1),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onButtonCancel,
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: AppColors.greyColor.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "لا",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: onButtonClick,
                      child: Container(
                        // height: 40,
                        width: MediaQuery.sizeOf(context).width,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.defaultColor,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: AppColors.defaultColor.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            confirmText ?? "نعم",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
