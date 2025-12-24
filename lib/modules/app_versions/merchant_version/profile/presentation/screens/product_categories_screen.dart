import 'package:bastoga/core/components/components.dart';
import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/components/default_emit_loading.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/presentation/cubit/merchant_profile_cubit.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/presentation/widgets/delete_product_category_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

class CategoryItem {
  String? id;
  String originalName;
  TextEditingController controller;

  CategoryItem({this.id, required this.controller, this.originalName = ""});
}

class ProductCategoriesScreen extends StatefulWidget {
  const ProductCategoriesScreen({super.key});

  @override
  State<ProductCategoriesScreen> createState() => _ProductCategoriesScreenState();
}

class _ProductCategoriesScreenState extends State<ProductCategoriesScreen> {
  List<CategoryItem> _uiCategories = [];

  @override
  void initState() {
    context.read<MerchantProfileCubit>().getProductCategories();
    super.initState();
  }

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
          text: "إضافة الاقسام الفرعية",
          color: AppColors.black1A,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
      body: BlocConsumer<MerchantProfileCubit, MerchantProfileStates>(
        listener: (context, state) {
          if (state is GetProductCategoriesSuccessState) {
            final categories = context.read<MerchantProfileCubit>().productCategories ?? [];
            _uiCategories =
                categories
                    .map(
                      (e) => CategoryItem(
                        id: e.id,
                        controller: TextEditingController(text: e.name),
                        originalName: e.name, // Store original name
                      ),
                    )
                    .toList();
          } else if (state is AddProductCategorySuccessState) {
            showDefaultFlushBar(
              context: context,
              color: AppColors.green2Color.withValues(alpha: 0.6),
              messageText: "تم الحفظ بنجاح",
              notificationType: ToastificationType.success,
            );
            context.read<MerchantProfileCubit>().getProductCategories();
          } else if (state is AddProductCategoryFailedState) {
            showDefaultFlushBar(
              context: context,
              color: AppColors.redE7,
              messageText: state.message,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<MerchantProfileCubit>();

          if (state is GetProductCategoriesLoadingState && _uiCategories.isEmpty) {
            return const Center(child: DefaultCircleProgressIndicator());
          }

          if (state is GetProductCategoriesFailedState && _uiCategories.isEmpty) {
            return Center(
              child: CustomText(
                text: state.message,
                color: AppColors.redE7,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: CustomText(
                          text: "تصنيف المتجر",
                          fontSize: 14,
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _uiCategories.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  controller: _uiCategories[index].controller,
                                  hint: "اسم التصنيف",
                                ),
                              ),
                              if (_uiCategories[index].id == null)
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _uiCategories.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                                ),
                              if (_uiCategories[index].id != null)
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return DeleteProductCategoryAlert(
                                          cubit: cubit,
                                          productCategoryId: _uiCategories[index].id!,
                                          productCategoryName: _uiCategories[index].controller.text,
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _uiCategories.add(CategoryItem(controller: TextEditingController()));
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.greyF5,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add, color: AppColors.black1A, size: 20),
                              const SizedBox(width: 8),
                              CustomText(
                                text: "إضافة تصنيف اخر",
                                color: AppColors.black1A,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom Confirm Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    state is AddProductCategoryLoadingState
                        ? const Center(child: DefaultCircleProgressIndicator())
                        : CustomElevated(
                          text: "حفظ",
                          press: () {
                            List<String> namesToAdd = [];
                            Map<String, String> namesToEdit = {};

                            for (var item in _uiCategories) {
                              String currentName = item.controller.text.trim();
                              if (currentName.isEmpty) continue;

                              if (item.id == null) {
                                namesToAdd.add(currentName);
                              } else {
                                if (currentName != item.originalName) {
                                  namesToEdit[item.id!] = currentName;
                                }
                              }
                            }

                            if (namesToAdd.isEmpty && namesToEdit.isEmpty) {
                              return;
                            }

                            cubit.saveCategories(namesToAdd: namesToAdd, namesToEdit: namesToEdit);
                          },
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}
