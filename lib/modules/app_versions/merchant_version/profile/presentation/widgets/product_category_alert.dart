import 'package:bastoga/core/components/default_emit_loading.dart';
import 'package:bastoga/core/components/default_flushbar.dart';
import 'package:bastoga/core/components/default_text_form_field.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/presentation/cubit/merchant_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCategoryAlert extends StatelessWidget {
  const ProductCategoryAlert({
    super.key,
    required this.cubit,
    this.isEdit = false,
    this.productCategoryId = "",
    this.editName = "",
  });

  final MerchantProfileCubit cubit;
  final bool isEdit;
  final String productCategoryId, editName;

  @override
  Widget build(BuildContext context) {
    isEdit ? cubit.nameController.text = editName : cubit.nameController.clear();

    return BlocProvider.value(
      value: cubit,
      child: AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(isEdit ? "تعديل قسم" : "إضافة قسم", style: Theme.of(context).textTheme.bodyLarge),
            IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.close, color: AppColors.black),
            ),
          ],
        ),
        content: Form(
          key: cubit.formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("قسم المنتج", style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 5),
                BlocBuilder<MerchantProfileCubit, MerchantProfileStates>(
                  builder: (context, state) {
                    return CustomTextFormField(
                      controller: cubit.nameController,
                      hint: 'اسم قسم المنتج',
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '';
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        actions: [
          BlocConsumer<MerchantProfileCubit, MerchantProfileStates>(
            listener: (context, state) {
              if (state is AddProductCategoryFailedState) {
                showDefaultFlushBar(
                  context: context,
                  color: AppColors.redE7,
                  messageText: state.message,
                );
              } else if (state is AddProductCategorySuccessState) {
                context.pop();
                cubit.getProductCategories();
                showDefaultFlushBar(
                  context: context,
                  color: AppColors.green2Color.withValues(alpha: 0.6),
                  messageText: isEdit ? "تم تعديل القسم بنجاح" : "تم اضافة القسم بنجاح",
                );
              }
            },
            builder: (context, state) {
              if (state is AddProductCategoryLoadingState) {
                return const SizedBox(width: 60, child: DefaultSmallCircleIndicator());
              }
              return TextButton(
                onPressed: () {
                  isEdit
                      ? cubit.editProductCategory(productCategoryId: productCategoryId)
                      : cubit.addProductCategory();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    isEdit ? "تعديل" : "إضافة",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.blue2Color, fontSize: 16),
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
