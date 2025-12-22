import 'package:bastoga/core/components/components.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/helpers/sheet_helper.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/presentation/cubit/merchant_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/components/default_emit_loading.dart';

class ProductType extends StatelessWidget {
  const ProductType({super.key});

  static TextEditingController productTypeController = TextEditingController();
  static String productCategory = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('النوع', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          BlocBuilder<MerchantProfileCubit, MerchantProfileStates>(
            builder: (context, state) {
              return CustomTextFormField(
                readOnly: true,
                controller: productTypeController,
                hint: 'اختر',
                keyboardType: TextInputType.none,
                suffixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.keyboard_arrow_down, size: 25),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return '';
                  }
                  return null;
                },
                onTap: () async {
                  SheetHelper.showCustomSheet(
                    context: context,
                    title: 'نوع المنتج',
                    bottomSheetContent: BlocProvider.value(
                      value: context.read<MerchantProfileCubit>(),
                      child: BlocBuilder<MerchantProfileCubit, MerchantProfileStates>(
                        builder: (context, state) {
                          if (state is GetProductCategoriesLoadingState) {
                            return const DefaultCircleProgressIndicator();
                          }

                          if (context.read<MerchantProfileCubit>().productCategories != null &&
                              context.read<MerchantProfileCubit>().productCategories!.isNotEmpty) {
                            return Column(
                              children: [
                                Expanded(
                                  child: Material(
                                    color: AppColors.white,
                                    child: DefaultListView(
                                      noPadding: true,
                                      refresh:
                                          (page) =>
                                              context
                                                  .read<MerchantProfileCubit>()
                                                  .getProductCategories(),
                                      itemBuilder:
                                          (_, index) => Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: Theme(
                                              data: ThemeData(
                                                highlightColor: Colors.transparent,
                                                splashFactory: NoSplash.splashFactory,
                                              ),
                                              child: ListTile(
                                                tileColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  side: BorderSide(
                                                    color:
                                                        productCategory ==
                                                                context
                                                                    .read<MerchantProfileCubit>()
                                                                    .productCategories![index]
                                                                    .id
                                                            ? AppColors.defaultColor
                                                            : Colors.transparent,
                                                  ),
                                                ),
                                                title: Text(
                                                  context
                                                      .read<MerchantProfileCubit>()
                                                      .productCategories![index]
                                                      .name,
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                ),
                                                onTap: () {
                                                  context.pop();
                                                  productTypeController.text =
                                                      context
                                                          .read<MerchantProfileCubit>()
                                                          .productCategories![index]
                                                          .name;
                                                  productCategory =
                                                      context
                                                          .read<MerchantProfileCubit>()
                                                          .productCategories![index]
                                                          .id;
                                                },
                                              ),
                                            ),
                                          ),
                                      length:
                                          context
                                              .read<MerchantProfileCubit>()
                                              .productCategories!
                                              .length,
                                      hasMore: false,
                                      onRefreshCall:
                                          () =>
                                              context
                                                  .read<MerchantProfileCubit>()
                                                  .getProductCategories(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: CustomElevated(text: 'اختر', press: () {}),
                                ),
                              ],
                            );
                          } else {
                            return NoData(
                              refresh:
                                  () => context.read<MerchantProfileCubit>().getProductCategories(),
                            );
                          }
                        },
                      ),
                    ),
                    isForm: true,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProductTypeTabItem extends StatelessWidget {
  const ProductTypeTabItem({super.key, required this.text, required this.index});

  final String text;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // cubit.onSelectedItem(
        //   index: index,
        //   name: text,
        // );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            // color: cubit.tabSelectedItem == index
            //     ? Colors.black
            //     : Colors.transparent,
          ),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            // color: cubit.tabSelectedItem == index
            //     ? Colors.black
            //     : AppColors.grey2Color,
          ),
        ),
      ),
    );
  }
}
