import 'package:bastoga/core/components/default_emit_loading.dart';
import 'package:bastoga/core/components/default_flushbar.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/presentation/cubit/merchant_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        title: Text("حذف", style: Theme.of(context).textTheme.titleLarge),
        content: Text(
          "هل انت متأكد من حذف قسم  $productCategoryName ؟",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "إلغاء",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.defaultColor),
              ),
            ),
          ),
          const SizedBox(width: 10),
          BlocConsumer<MerchantProfileCubit, MerchantProfileStates>(
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
                  messageText: "تم حذف القسم بنجاح",
                );
              }
            },
            builder: (context, state) {
              if (state is DeleteProductCategoryLoadingState) {
                return const SizedBox(width: 60, child: DefaultSmallCircleIndicator());
              }
              return TextButton(
                onPressed: () {
                  cubit.deleteProductCategory(productCategoryId: productCategoryId);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.defaultColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "حذف",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.white, fontSize: 16),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
