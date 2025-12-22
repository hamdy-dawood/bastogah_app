import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/routing/routes.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_states.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../core/caching/local_cart.dart';
import '../../../../../../core/components/components.dart';
import '../../../../../../core/helpers/dialog_helper.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/constance.dart';
import '../../../../../../core/utils/image_manager.dart';
import '../../../../client_version/home/domain/entities/product.dart';
import '../../../../client_version/home/domain/entities/product_details_object.dart';
import '../../../../client_version/home/presentation/widgets/selecting_quantity_buttons.dart';
import '../cubit/products_cubit.dart';

class MerchantProductCardView extends StatelessWidget {
  final Product product;
  final BuildContext blocContext;
  final int index;

  const MerchantProductCardView({
    super.key,
    required this.product,
    required this.blocContext,
    required this.index,
  });

  bool isProductInCart() {
    final List<Product> result = cart.where((p) => p.id == product.id).toList();
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  double productPrice({required Product product}) {
    if (isProductInCart()) {
      return product.mySellPrice =
          cart.firstWhere((element) => element.id == product.id).mySellPrice.toDouble();
    } else {
      return product.mySellPrice.toDouble();
    }
  }

  int productQuantity({required Product product}) {
    if (isProductInCart()) {
      return product.quantity = cart.firstWhere((element) => element.id == product.id).quantity;
    } else {
      return product.quantity;
    }
  }

  void showRemoveProductAlert(BuildContext context) {
    DialogHelper.showCustomDialog(
      context: context,
      alertDialog: WarningAlertPopUp(
        description: 'هل أنت متأكد من حذف المنتج من السلة',
        btnContent: 'حذف',
        image: ImageManager.warningIcon,
        onPress: () {
          context.read<MerchantProductsCubit>().decreaseProductFromCartCubit(product);
          context.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          Routes.productDetailsScreen,
          arguments: ProductDetailsObject(
            product: product,
            isMerchant: true,
            merchantBlocContext: context,
          ),
        );
      },
      child: Opacity(
        opacity: product.isActive ? 1 : 0.5,
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.grey5Color),
            boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(3),
                    height: 70,
                    width: 70,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child:
                        product.images.isNotEmpty
                            ? CachedNetworkImage(
                              imageUrl: '${AppConstance.imagePathApi}${product.images.first}',
                              width: context.screenWidth,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              errorWidget: (context, error, stackTrace) => const SizedBox(),
                            )
                            : Image.asset(ImageManager.noImage),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 14,
                            color: AppColors.grey3Color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (product.isPopular) ...[
                    const SizedBox(width: 8),
                    SvgPicture.asset(ImageManager.trendIcon),
                  ],
                  PopupMenuButton(
                    position: PopupMenuPosition.under,
                    onSelected: (value) {
                      if (value == 0) {
                        DialogHelper.showCustomDialog(
                          context: context,
                          alertDialog: WarningAlertPopUp(
                            description: 'هل أنت متأكد من حذف المنتج',
                            btnContent: 'حذف',
                            image: ImageManager.warningIcon,
                            onPress: () {
                              context.pop();
                              blocContext.read<MerchantProductsCubit>().deleteProduct(
                                id: product.id,
                              );
                            },
                          ),
                        );
                      }
                    },
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(
                            value: 0,
                            child: Text("حذف", style: Theme.of(context).textTheme.bodyMedium),
                          ),
                        ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              BlocProvider.value(
                value: blocContext.read<MerchantProductsCubit>(),
                child: BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
                  builder: (context, state) {
                    return SelectingQuantityButtons(
                      totalPrice: productPrice(product: product),
                      minusButtonColor: AppColors.greyColor.withValues(alpha: 0.5),
                      increaseFunction:
                          () => context.read<MerchantProductsCubit>().increaseProductInCartCubit(
                            product,
                          ),
                      decreaseFunction:
                          () =>
                              product.quantity == 1 && isProductInCart()
                                  ? showRemoveProductAlert(context)
                                  : context
                                      .read<MerchantProductsCubit>()
                                      .decreaseProductFromCartCubit(product),
                      quantity: productQuantity(product: product),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              BlocProvider.value(
                value: blocContext.read<MerchantProductsCubit>(),
                child: BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
                  builder: (context, state) {
                    if (!isProductInCart()) {
                      return SizedBox(
                        height: 35,
                        child: CustomElevated(
                          text: 'أضف للسلة',
                          press: () {
                            if (cart.isEmpty ||
                                cart
                                    .where((element) => element.merchant.id == product.merchant.id)
                                    .toList()
                                    .isNotEmpty) {
                              context.read<MerchantProductsCubit>().addProductInCartCubit(product);

                              showDefaultFlushBar(
                                context: context,
                                color: AppColors.greenColor.withValues(alpha: 0.6),
                                messageText: 'تم إضافة المنتج فى السلة بنجاح',
                                notificationType: ToastificationType.success,
                              );
                            } else {
                              DialogHelper.showCustomDialog(
                                context: context,
                                alertDialog: WarningAlertPopUp(
                                  description:
                                      'هل أنت متأكد من حذف السلة واضافة منتجات من تاجر آخر؟',
                                  btnContent: 'تأكيد',
                                  image: ImageManager.warningIcon,
                                  onPress: () {
                                    cart.clear();
                                    context.read<MerchantProductsCubit>().addProductInCartCubit(
                                      product,
                                    );
                                    context.pop();
                                  },
                                ),
                              );
                            }
                          },
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
