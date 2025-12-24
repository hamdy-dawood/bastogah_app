import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import 'custom_elevated.dart';

class WarningAlertPopUp extends StatelessWidget {
  final String? image;
  final String description;
  final String? btnContent;
  final Color? btnColor;

  // final bool showCloseButton;
  final void Function()? onPress;

  const WarningAlertPopUp({
    super.key,
    this.image,
    required this.description,
    // this.showCloseButton = false,
    this.btnContent,
    this.btnColor,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
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
                offset: const Offset(3, 3), // Shadow offset from right and bottom
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (btnContent != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: IconButton(
                          onPressed: () => context.pop(),
                          color: Colors.black,
                          icon: const Icon(Icons.close, size: 21.0),
                        ),
                      ),
                    ],
                  ),
                if (image != null)
                  SizedBox(
                    height: context.screenHeight / 4,
                    width: context.screenWidth,
                    child: Image.asset(image!),
                  ),
                // const SizedBox(
                //   height: 25.0,
                // ),
                // Text(
                //   'Alert',
                //   textAlign: TextAlign.center,
                //   style: Theme.of(context).textTheme.displaySmall?.copyWith(
                //         fontSize: 28.0,
                //         color: AppColors.redColor,
                //         fontWeight: FontWeight.bold,
                //       ),
                // ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      height: 1.8,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: CustomElevated(
                    text: btnContent ?? 'حسنا',
                    btnColor: btnColor ?? AppColors.redE7,
                    press:
                        onPress ??
                        () {
                          context.pop();
                        },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
