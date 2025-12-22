import 'package:bastoga/core/components/components.dart';
import 'package:bastoga/core/components/default_emit_loading.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/presentation/cubit/merchant_profile_cubit.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/presentation/widgets/delete_product_category_alert.dart';
import 'package:bastoga/modules/app_versions/merchant_version/profile/presentation/widgets/product_category_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCategoriesScreen extends StatefulWidget {
  const ProductCategoriesScreen({super.key});

  @override
  State<ProductCategoriesScreen> createState() => _ProductCategoriesScreenState();
}

class _ProductCategoriesScreenState extends State<ProductCategoriesScreen> {
  @override
  void initState() {
    context.read<MerchantProfileCubit>().getProductCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("اقسام المنتجات", style: Theme.of(context).textTheme.bodyMedium)),
      body: BlocBuilder<MerchantProfileCubit, MerchantProfileStates>(
        builder: (context, state) {
          final cubit = context.read<MerchantProfileCubit>();
          if (state is GetProductCategoriesLoadingState) {
            return const Center(child: DefaultCircleProgressIndicator());
          }
          if (state is GetProductCategoriesFailedState) {
            return Text(
              state.message,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontSize: 30, color: Colors.red),
            );
          }
          if (cubit.productCategories != null && cubit.productCategories!.isNotEmpty) {
            return DefaultListView(
              refresh: (page) async {},
              itemBuilder:
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: AppColors.black.withValues(alpha: 0.2)),
                      ),
                      title: Text(
                        cubit.productCategories![index].name,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return ProductCategoryAlert(
                                    cubit: context.read<MerchantProfileCubit>(),
                                    isEdit: true,
                                    productCategoryId: cubit.productCategories![index].id,
                                    editName: cubit.productCategories![index].name,
                                  );
                                },
                              );
                            },
                            child: const Icon(Icons.edit, size: 20, color: Colors.black54),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return DeleteProductCategoryAlert(
                                    cubit: cubit,
                                    productCategoryId: cubit.productCategories![index].id,
                                    productCategoryName: cubit.productCategories![index].name,
                                  );
                                },
                              );
                            },
                            child: const Icon(CupertinoIcons.delete, size: 20, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
              length: cubit.productCategories!.length,
              hasMore: false,
              onRefreshCall: () => cubit.getProductCategories(),
            );
          } else {
            return NoData(refresh: () => cubit.getProductCategories());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.defaultColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return ProductCategoryAlert(cubit: context.read<MerchantProfileCubit>());
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
