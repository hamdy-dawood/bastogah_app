import 'dart:async';

import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class SheetHelper {
  static Future showCustomSheet({
    required BuildContext context,
    String? title,
    double? bottomSheetHeight,
    required Widget bottomSheetContent,
    required bool isForm,
  }) {
    if (isForm) {
      return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.white,
        constraints: BoxConstraints.loose(
          Size(context.screenWidth, bottomSheetHeight ?? context.screenHeight * 0.6),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
              top: 16.0,
              left: 16.0,
              right: 16.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title ?? '',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(fontSize: 21.0, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      // backgroundColor: Colors.white,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        // border: Border.all(
                        //   color: AppConstance.isDark(context) ? Colors.black54 : Colors.grey.withValues(alpha:0.2),
                        //   width: 1,
                        // ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey9A.withValues(alpha: 0.2),
                            blurRadius: 5.0, // soften the shadow
                            spreadRadius: 0.0, //extend the shadow
                            offset: const Offset(
                              2.0, // Move to right 10  horizontally
                              2.0, // Move to bottom 10 Vertically
                            ),
                          ),
                        ],
                      ),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        onPressed: () => context.pop(),
                        color: Colors.black,
                        icon: const Icon(Icons.close, size: 21.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Expanded(child: bottomSheetContent),
              ],
            ),
          );
        },
      );
    } else {
      return showModalBottomSheet<void>(
        context: context,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints.loose(
          Size(context.screenWidth, bottomSheetHeight ?? context.screenHeight * 0.7),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // if (bottomSheetTitle != null) bottomSheetTitle,
                Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.2), width: 1),
                  ),
                  child: Column(
                    children: [
                      if (title != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontSize: 21.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 25.0),
                      bottomSheetContent,
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                Container(
                  // backgroundColor: Colors.white,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.2), width: 1),
                  ),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    onPressed: () => Navigator.of(context).pop(),
                    color: Colors.black,
                    icon: Text(
                      'إلغاء',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.redE7,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
