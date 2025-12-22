import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/components/components.dart';
import '../../../../../../core/controllers/navigator_bloc/navigator_cubit.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/image_manager.dart';
import '../../../home/presentation/widgets/row_icon_text.dart';
import '../../domain/entities/add_product_request_body.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_states.dart';
import '../screens/add_edit_product_screen.dart';
import 'is_product_active.dart';
import 'is_product_new.dart';
import 'is_product_popular.dart';
import 'product_description_field.dart';
import 'product_name_field.dart';
import 'product_price_field.dart';
import 'product_type.dart';

class EditProductButton extends StatelessWidget {
  final String productId;

  const EditProductButton({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocConsumer<MerchantProductsCubit, MerchantProductsStates>(
        listener: (context, state) {
          if (state is AddProductLoadingState) {
            showDialog(context: context, builder: (context) => Loader());
          }
          if (state is AddProductFailState) {
            context.pop();
            showDefaultFlushBar(
              context: context,
              color: AppColors.redE7,
              messageText: state.message,
            );
          }

          if (state is AddProductSuccessState) {
            context.pop();
            ProductNameField.productNameController.clear();
            ProductPriceField.productPriceController.clear();
            ProductType.productTypeController.clear();
            ProductType.productCategory = '';
            ProductDescriptionField.productDescriptionController.clear();
            // context.read<MerchantProductsCubit>().getProducts(
            //       page: 0,
            //       search: '',
            //     );
            context.read<NavigatorCubit>().merchantGoTo(
              index: 1,
              context: context,
              screen: context.read<NavigatorCubit>().merchantScreens[1],
            );
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              if (AddEditProductScreen.formKey.currentState!.validate() &&
                  (context.read<MerchantProductsCubit>().productImages.isNotEmpty ||
                      context.read<MerchantProductsCubit>().myProductImages.isNotEmpty)) {
                context.read<MerchantProductsCubit>().editProduct(
                  addProductRequestBody: AddProductRequestBody(
                    productId: productId,
                    images: context.read<MerchantProductsCubit>().myProductImages,
                    name: ProductNameField.productNameController.text,
                    price: double.parse(ProductPriceField.productPriceController.text),
                    finalPrice: context.read<MerchantProductsCubit>().finalPrice,
                    categoryId: ProductType.productCategory,
                    description: ProductDescriptionField.productDescriptionController.text,
                    isNew: IsProductNewView.isSelected,
                    isPopular: IsProductPopularView.isSelected,
                    isActive: IsProductActiveView.isSelected,
                  ),
                );
              }
            },
            child: const RowIconText(
              svgIcon: ImageManager.correctIcon,
              text: "حفظ",
              // fontColor: AppColors.defaultColor,
            ),
          );
        },
      ),
    );
  }
}
