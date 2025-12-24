import 'package:bastoga/core/components/custom_elevated.dart';
import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/components/default_emit_loading.dart';
import 'package:bastoga/core/components/default_flushbar.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/presentation/cubit/merchant_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

class DeleteProductCategoryAlert extends StatelessWidget {
  const DeleteProductCategoryAlert({
    super.key,
    required this.cubit,
    required this.productCategoryId,
    required this.productCategoryName,
  });

  final String productCategoryId;
  final String productCategoryName;
  final MerchantProfileCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: CustomText(
          text: "حذف",
          color: AppColors.black1A,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          maxLines: 2,
        ),
        content: SizedBox(
          width: 0.3 * context.screenWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "هل انت متأكد من حذف قسم  $productCategoryName ؟",
                color: AppColors.black1A,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                maxLines: 5,
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child:  BlocConsumer<MerchantProfileCubit, MerchantProfileStates>(
                      listener: (context, state) {
                        if (state is DeleteProductCategoryFailedState) {
                          showDefaultFlushBar(
                            context: context,
                            color: Colors.red,
                            messageText: state.message,
                          );
                        } else if (state is DeleteProductCategorySuccessState) {
                          context.pop();
                          cubit.getProductCategories();

                          showDefaultFlushBar(
                            context: context,
                            color: AppColors.green2Color.withValues(alpha: 0.6),
                            messageText: "تم الحذف بنجاح",
                            notificationType: ToastificationType.success,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is DeleteProductCategoryLoadingState) {
                          return const SizedBox(width: 60, child: DefaultSmallCircleIndicator());
                        }
                        return CustomElevated(
                          press: () {
                            cubit.deleteProductCategory(productCategoryId: productCategoryId);
                          },
                          text:  "حذف",
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomElevated(
                      text: "إلغاء",
                      textColor: AppColors.black1A,
                      btnColor: AppColors.white,
                      press: () {
                        context.pop();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
