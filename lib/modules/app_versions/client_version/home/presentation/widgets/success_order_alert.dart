import 'package:bastoga/core/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/constance.dart';
import '../../../../../../core/utils/image_manager.dart';

class SuccessOrderAlert extends StatelessWidget {
  final void Function()? onTap;

  const SuccessOrderAlert({super.key, required this.onTap});

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
                color: Colors.black12.withValues(alpha: 0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(3, 3), // Shadow offset from right and bottom
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: onTap,
                      child: const Icon(
                        CupertinoIcons.clear_circled,
                        size: 21.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(
              //   height: 16.0,
              // ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(ImageManager.successIcon),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('تم إرسال طلبك بنجاح!', style: Theme.of(context).textTheme.bodyLarge),
              ),
              AppConstance.horizontalDivider,
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomElevated(text: 'الرئيسية', press: onTap!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
