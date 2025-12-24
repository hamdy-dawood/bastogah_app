import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:bastoga/modules/app_versions/client_version/my_profile/presentation/widgets/profile_info_row_item.dart';
import 'package:flutter/material.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: CircleAvatar(
              backgroundColor: AppColors.defaultColor.withValues(alpha: 0.15),
              child: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: AppColors.defaultColor,
                size: 20,
              ),
            ),
          ),
        ),
        title: CustomText(
          text: "الخصوصية والأمان",
          color: AppColors.black1A,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              ProfileInfoRowItem(
                iconPath: ImageManager.security,
                value: "تغيير كلمة المرور",
                onTap: () {},
              ),
              ProfileInfoRowItem(
                iconPath: ImageManager.security,
                value: "التحقق بخطوتين",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
