import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/core/utils/font_weight_helper.dart';
import 'package:bastoga/modules/app_versions/client_version/home/domain/entities/product_details_object.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/components/favorite_icon_view.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/image_manager.dart';
import '../../domain/entities/product.dart';

class ProductCardView extends StatelessWidget {
  final Product product;
  final BuildContext blocContext;

  const ProductCardView({super.key, required this.product, required this.blocContext});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        product.isActive
            ? context.pushNamed(
              Routes.productDetailsScreen,
              arguments: ProductDetailsObject(
                product: product,
                isMerchant: false,
                merchantBlocContext: blocContext,
              ),
            )
            : null;
      },
      child: Opacity(
        opacity: product.isActive ? 1 : 0.5,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.grey5Color),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey9A.withValues(alpha: 0.2),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.passthrough,
                    children: [
                      product.images.isNotEmpty
                          ? Image.network(
                            '${AppConstance.imagePathApi}${product.images.first}',
                            width: context.screenWidth,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            errorBuilder: (context, error, stackTrace) => const SizedBox(),
                          )
                          : Image.asset(ImageManager.noImage),
                      Positioned(top: 5, right: 5, child: FavoriteIconView(product: product)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeightHelper.medium,
                      color: AppColors.grey7Color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (product.finalPrice != product.price)
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            '${product.price} د.ع',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.redE7,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                      Text(
                        '${product.finalPrice} د.ع',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: AppColors.defaultColor),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
