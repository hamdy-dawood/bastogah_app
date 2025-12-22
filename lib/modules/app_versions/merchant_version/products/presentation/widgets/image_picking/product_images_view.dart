import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_cubit.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../../../core/utils/colors.dart';
import '../../../../../../../core/utils/constance.dart';

class ProductImagesView extends StatelessWidget {
  const ProductImagesView({super.key});

  static final PageController pageControl = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                color: AppColors.black.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 250,
              width: double.infinity,
              child: PageView.builder(
                controller: pageControl,
                itemCount:
                    context.read<MerchantProductsCubit>().productImages.length +
                    context.read<MerchantProductsCubit>().myProductImages.length,
                itemBuilder: (context, index) {
                  if (index < context.read<MerchantProductsCubit>().myProductImages.length) {
                    return Image.network(
                      '${AppConstance.imagePathApi}${context.read<MerchantProductsCubit>().myProductImages[index]}',
                      // fit: BoxFit.fill,
                    );
                  } else {
                    return Image.file(
                      context.read<MerchantProductsCubit>().productImages[index -
                          context.read<MerchantProductsCubit>().myProductImages.length],
                      fit: BoxFit.fill,
                    );
                  }
                },
              ),
            ),
            if (context.read<MerchantProductsCubit>().productImages.length +
                    context.read<MerchantProductsCubit>().myProductImages.length >
                0)
              Positioned(
                top: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.redE7.withValues(alpha: 0.3),
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      onTap: () {
                        /// CLICK TO Remove GROUP IMAGES
                        context.read<MerchantProductsCubit>().removeProductImages(
                          imageIndex: pageControl.page!.toInt(),
                        );
                        pageControl.jumpToPage(
                          (context.read<MerchantProductsCubit>().productImages.length +
                                  context.read<MerchantProductsCubit>().myProductImages.length) -
                              1,
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 14.0),
                        child: Icon(Icons.maximize, size: 24, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.blueColor.withValues(alpha: 0.3),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                    onTap: () {
                      /// CLICK TO UPLOAD GROUP IMAGES
                      context.read<MerchantProductsCubit>().pickProductImages();
                    },
                    child: const Icon(Icons.add, size: 24, color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SmoothPageIndicator(
                controller: pageControl,
                count:
                    context.read<MerchantProductsCubit>().productImages.length +
                    context.read<MerchantProductsCubit>().myProductImages.length,
                effect: const WormEffect(
                  dotWidth: 8,
                  dotHeight: 8,
                  dotColor: Colors.white,
                  activeDotColor: AppColors.yellowColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
