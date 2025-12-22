import 'package:bastoga/core/components/default_emit_loading.dart';
import 'package:bastoga/core/components/grid_view_pagination.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/modules/app_versions/client_version/home/presentation/cubit/client_home_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/constance.dart';
import '../../domain/entities/merchant.dart';
import '../../domain/entities/merchant_details_object.dart';

class DiscountMerchantsScreen extends StatelessWidget {
  const DiscountMerchantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ClientHomeCubit>()..resetDiscountMerchants(),
      child: const DiscountMerchantsBody(),
    );
  }
}

class DiscountMerchantsBody extends StatelessWidget {
  const DiscountMerchantsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ClientHomeCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(surfaceTintColor: Colors.transparent, title: const Text("خصومات المتاجر")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Expanded(child: DiscountMerchantsTable(cubit: cubit)),
          ],
        ),
      ),
    );
  }
}

class DiscountMerchantsTable extends StatelessWidget {
  const DiscountMerchantsTable({super.key, required this.cubit});

  final ClientHomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientHomeCubit, ClientHomeStates>(
      builder: (context, state) {
        if (state is DiscountMerchantLoadingState) {
          return const DefaultCircleProgressIndicator();
        } else if (state is DiscountMerchantFailState) {
          return Text(state.message, style: const TextStyle(color: Colors.red));
        } else if (cubit.discountMerchantList.isEmpty) {
          return const SizedBox();
        }

        return GridViewPagination(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            cubit.resetDiscountMerchants();
          },
          addEvent: () {
            cubit.getDiscountMerchants();
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 150,
          ),
          itemCount:
              cubit.hasReachedMax
                  ? cubit.discountMerchantList.length
                  : cubit.discountMerchantList.length + 1,
          itemBuilder: (context, index) {
            if (cubit.discountMerchantList.isEmpty) {
              return const SizedBox();
            }

            if (index == cubit.discountMerchantList.length) {
              return const DefaultSmallCircleIndicator();
            }

            final listData = cubit.discountMerchantList[index];

            return _SubCategoryMerchantCardView(blocContext: context, merchant: listData);
          },
        );
      },
    );
  }
}

class _SubCategoryMerchantCardView extends StatelessWidget {
  final Merchant merchant;
  final BuildContext blocContext;

  const _SubCategoryMerchantCardView({required this.blocContext, required this.merchant});

  bool isMerchantOpen() {
    // Parse opening time
    List<String> openParts = merchant.openTime.split(':');
    int openH = int.parse(openParts[0]);
    int openM = int.parse(openParts[1]);
    int openMinutes = (openH * 60) + openM;

    // Parse closing time
    List<String> closeParts = merchant.closeTime.split(':');
    int closeH = int.parse(closeParts[0]);
    int closeM = int.parse(closeParts[1]);
    int closeMinutes = (closeH * 60) + closeM;

    // // Get current time in the specified time zone
    final now = TimeOfDay.fromDateTime(DateTime.now());
    int currentTime = (now.hour * 60) + now.minute;

    // Adjust closing time if it extends past midnight
    if (closeMinutes <= openMinutes) {
      closeMinutes += (24 * 60);
      if (currentTime < openMinutes) {
        currentTime += (24 * 60);
      }
    }

    return currentTime >= openMinutes && currentTime <= closeMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          Routes.merchantDetailsScreen,
          arguments: MerchantDetailsObject(merchant: merchant),
        );
      },
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.grey5Color),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: '${AppConstance.imagePathApi}${merchant.image}',
                    height: 100,
                    width: context.screenWidth,
                    filterQuality: FilterQuality.high,
                    errorWidget: (context, error, stackTrace) => const SizedBox(),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  merchant.displayName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                // if (merchant.discount != null && merchant.discount!.discountPercent > 0)
                //   Container(
                //     decoration: BoxDecoration(
                //       color: AppColors.redColor.withValues(alpha:0.1),
                //       borderRadius: BorderRadius.circular(6),
                //     ),
                //     padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         SvgPicture.asset(
                //           ImageManager.offersColorIcon,
                //           height: 20,
                //           colorFilter: const ColorFilter.mode(AppColors.redColor, BlendMode.srcIn),
                //         ),
                //         const SizedBox(width: 5),
                //         Flexible(
                //           child: CustomText(
                //             text: "خصم ${merchant.discount?.discountPercent} % لغاية ${AppConstance.currencyFormat.format(merchant.maxDiscount)} د.ع  ",
                //             color: AppColors.redColor,
                //             fontWeight: FontWeight.w600,
                //             fontSize: 13,
                //             maxLines: 2,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
              ],
            ),
          ),
          if (!isMerchantOpen())
            Positioned(
              top: 0,
              right: -1,
              child: Banner(
                message: 'مغلق',
                location: BannerLocation.topStart,
                color: AppColors.redE7,
                textStyle: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }
}
