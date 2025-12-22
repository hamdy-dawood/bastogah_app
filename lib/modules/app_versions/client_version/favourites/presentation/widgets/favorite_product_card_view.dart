import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/modules/app_versions/client_version/home/presentation/cubit/client_home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/constance.dart';
import '../../../../../../core/utils/image_manager.dart';
import '../../../home/domain/entities/product.dart';
import '../../../home/domain/entities/product_details_object.dart';

class FavoriteProductCardView extends StatelessWidget {
  final Product product;
  final void Function()? onFavTap;

  const FavoriteProductCardView({super.key, required this.product, required this.onFavTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientHomeCubit, ClientHomeStates>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.pushNamed(
              Routes.productDetailsScreen,
              arguments: ProductDetailsObject(
                product: product,
                isMerchant: false,
                merchantBlocContext: context,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.grey5Color),
              boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 70,
                  width: 70,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child:
                      product.images.isNotEmpty
                          ? Image.network(
                            '${AppConstance.imagePathApi}${product.images.first}',
                            width: context.screenWidth,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            errorBuilder: (context, error, stackTrace) => const SizedBox(),
                          )
                          : Image.asset(ImageManager.noImage),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        product.name,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(fontSize: 14, color: AppColors.grey3Color),
                      ),
                      const SizedBox(height: 8),
                      Text('${product.finalPrice} د', style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onFavTap,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(Icons.favorite, color: AppColors.defaultColor),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
