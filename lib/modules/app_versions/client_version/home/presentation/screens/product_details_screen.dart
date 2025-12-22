import 'package:bastoga/core/components/components.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:bastoga/modules/app_versions/client_version/home/presentation/cubit/client_home_cubit.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_cubit.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../core/caching/local_cart.dart';
import '../../../../../../core/components/slider_images.dart';
import '../../../../../../core/helpers/dialog_helper.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/utils/constance.dart';
import '../../../../merchant_version/products/domain/entities/product_object.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_details_object.dart';
import '../widgets/default_client_app_bar.dart';
import '../widgets/selecting_quantity_buttons.dart';
import '../widgets/store_name_section.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductDetailsObject productDetailsObject;

  const ProductDetailsScreen({super.key, required this.productDetailsObject});

  bool isProductInCart() {
    final List<Product> result =
        cart.where((product) => product.id == productDetailsObject.product.id).toList();
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  double productPrice({required Product product}) {
    if (isProductInCart()) {
      return product.mySellPrice =
          cart
              .firstWhere((element) => element.id == productDetailsObject.product.id)
              .mySellPrice
              .toDouble();
    } else {
      return productDetailsObject.product.mySellPrice.toDouble();
    }
  }

  int productQuantity({required Product product}) {
    if (isProductInCart()) {
      return product.quantity =
          cart.firstWhere((element) => element.id == productDetailsObject.product.id).quantity;
    } else {
      return productDetailsObject.product.quantity;
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
          context.read<ClientHomeCubit>().decreaseProductFromCartCubit(
            productDetailsObject.product,
          );
          context.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(!productDetailsObject.isMerchant ? 'التفاصيل' : 'تفاصيل المنتج'),
        actions: [if (!productDetailsObject.isMerchant) const CartIconWidget()],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            height: context.screenHeight,
            // child: Image.asset(ImageManager.zaitonaBgArt,fit: BoxFit.cover,),
          ),
          Column(
            children: [
              _ProductDetailsBody(productDetailsObject: productDetailsObject),
              const Divider(thickness: 1),
              Container(
                padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 5),
                color: Colors.white,
                child: Column(
                  children: [
                    if (!productDetailsObject.isMerchant)
                      BlocBuilder<ClientHomeCubit, ClientHomeStates>(
                        builder: (context, state) {
                          return SelectingQuantityButtons(
                            totalPrice: productPrice(product: productDetailsObject.product),
                            minusButtonColor: AppColors.greyColor.withValues(alpha: 0.5),
                            increaseFunction:
                                () => context.read<ClientHomeCubit>().increaseProductInCartCubit(
                                  productDetailsObject.product,
                                ),
                            decreaseFunction:
                                () =>
                                    productDetailsObject.product.quantity == 1 && isProductInCart()
                                        ? showRemoveProductAlert(context)
                                        : context
                                            .read<ClientHomeCubit>()
                                            .decreaseProductFromCartCubit(
                                              productDetailsObject.product,
                                            ),
                            quantity: productQuantity(product: productDetailsObject.product),
                          );
                        },
                      ),
                    const SizedBox(height: 16),
                    if (!productDetailsObject.isMerchant)
                      BlocBuilder<ClientHomeCubit, ClientHomeStates>(
                        builder: (context, state) {
                          if (!isProductInCart()) {
                            return Row(
                              children: [
                                Expanded(
                                  child: CustomElevated(
                                    text: 'أضف للسلة',
                                    press: () {
                                      if (cart.isEmpty ||
                                          cart
                                              .where(
                                                (element) =>
                                                    element.merchant.id ==
                                                    productDetailsObject.product.merchant.id,
                                              )
                                              .toList()
                                              .isNotEmpty) {
                                        context.read<ClientHomeCubit>().addProductInCartCubit(
                                          productDetailsObject.product,
                                        );

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
                                              context.read<ClientHomeCubit>().clearAllCart();
                                              context.read<ClientHomeCubit>().addProductInCartCubit(
                                                productDetailsObject.product,
                                              );
                                              context.pop();
                                            },
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                // const SizedBox(
                                //   width: 8,
                                // ),
                                // FavoriteIconView(product: productDetailsObject.product),
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      )
                    else
                      BlocProvider.value(
                        value:
                            productDetailsObject.merchantBlocContext!.read<MerchantProductsCubit>(),
                        child: BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
                          builder: (context, state) {
                            return CustomElevated(
                              text: 'تعديل',
                              press: () {
                                context.pushNamed(
                                  Routes.addProductScreen,
                                  arguments: ProductObject(
                                    isEdit: true,
                                    blocContext: context,
                                    product: productDetailsObject.product,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductDetailsBody extends StatelessWidget {
  const _ProductDetailsBody({required this.productDetailsObject});

  final ProductDetailsObject productDetailsObject;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SliderImages(
              sliderImages:
                  productDetailsObject.product.images
                      .map((e) => '${AppConstance.imagePathApi}$e')
                      .toList(),
              largeHeight: true,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                productDetailsObject.product.name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.grey6Color),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  if (productDetailsObject.product.isNew) ...[
                    SvgPicture.asset(ImageManager.newTagIcon),
                    const SizedBox(width: 8),
                  ],
                  if (productDetailsObject.product.isPopular)
                    SvgPicture.asset(ImageManager.popularTagIcon),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (productDetailsObject.product.finalPrice != productDetailsObject.product.price)
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        '${AppConstance.currencyFormat.format(productDetailsObject.product.price)} د.ع',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.redE7,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 20,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  Text(
                    '${AppConstance.currencyFormat.format(productDetailsObject.product.finalPrice)} د.ع',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppColors.defaultColor, fontSize: 20),
                  ),
                ],
              ),
            ),
            if (!productDetailsObject.isMerchant)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('المتجر', style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: StoreNameSection(
                      merchant: productDetailsObject.product.merchant,
                      onTap: () {
                        context.pop();
                        // context.pushNamed(
                        //   Routes.merchantDetailsScreen,
                        //   arguments: MerchantDetailsObject(
                        //     merchant: productDetailsObject.product.merchant,
                        //     blocContext: productDetailsObject.blocContext,
                        //   ),
                        // );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
              child: Text('وصف المنتج', style: Theme.of(context).textTheme.titleMedium),
            ),
            _ProductDescriptionSection(productDetailsObject: productDetailsObject),
          ],
        ),
      ),
    );
  }
}

class _ProductDescriptionSection extends StatelessWidget {
  final ProductDetailsObject productDetailsObject;

  const _ProductDescriptionSection({required this.productDetailsObject});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        productDetailsObject.product.desc,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(height: 1.5, color: Colors.black.withValues(alpha: 0.6)),
      ),
    );
  }
}
