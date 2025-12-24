import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/components/svg_icons.dart';
import 'package:bastoga/core/external/url_launcher.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:bastoga/modules/app_versions/merchant_version/home/presentation/widgets/text_container.dart';
import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

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
          text: "المساعدة والدعم",
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
              const SizedBox(height: 10),
              CustomText(
                text: "تواصل معنا",
                color: AppColors.black1A,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.greyF5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey9A.withValues(alpha: 0.2),
                      blurRadius: 3,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: SvgIcon(
                              icon: ImageManager.phoneIcon,
                              color: AppColors.defaultColor,
                              height: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Column(
                              children: [
                                CustomText(
                                  text: "الاتصال المباشر",
                                  color: AppColors.black1A,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                                CustomText(
                                  text: "+966594614210",
                                  color: AppColors.black4B,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  textDirection: TextDirection.ltr,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        UrlLaunchers().phoneCallLauncher(phoneNumber: "+966594614210");
                      },
                      child: TextContainer(
                        text: "اتصل الآن",
                        buttonColor: AppColors.greyF5,
                        borderColor: AppColors.greyE0,
                        fontColor: AppColors.black4B,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
