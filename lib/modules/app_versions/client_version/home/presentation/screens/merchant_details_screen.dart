import 'package:bastoga/core/components/components.dart';
import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/components/default_emit_loading.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/components/slider_images.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/constance.dart';
import '../../domain/entities/merchant.dart';
import '../../domain/entities/merchant_details_object.dart';
import '../cubit/client_home_cubit.dart';
import '../widgets/default_client_app_bar.dart';
import '../widgets/product_card_view.dart';

class MerchantDetailsScreen extends StatefulWidget {
  final MerchantDetailsObject merchantDetailsObject;

  const MerchantDetailsScreen({super.key, required this.merchantDetailsObject});

  @override
  State<MerchantDetailsScreen> createState() => _MerchantDetailsScreenState();
}

class _MerchantDetailsScreenState extends State<MerchantDetailsScreen> {
  int _page = 0;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    productCategory = '';
    context.read<ClientHomeCubit>().productCategories = null;

    context.read<ClientHomeCubit>().getProductCategories(
      merchantId: widget.merchantDetailsObject.merchant.id,
    );
    super.initState();
  }

  // List<String> tabs = [
  //   // 'عن المتجر',
  //   'المنتجات' /*, 'التقييمات'*/
  // ];

  String productCategory = '';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientHomeCubit, ClientHomeStates>(
      listener: (context, state) {
        if (state is GetProductCategoriesSuccessState) {
          context.read<ClientHomeCubit>().getProducts(
            search: searchController.text,
            productCategory: productCategory,
            merchantId: widget.merchantDetailsObject.merchant.id,
            page: 0,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: defaultClientAppBar(context: context, leading: true),
          body: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                SizedBox(
                  height: context.screenHeight,
                  // child: Image.asset(ImageManager.zaitonaBgArt,fit: BoxFit.cover,),
                ),
                DefaultTabController(
                  length: (context.read<ClientHomeCubit>().productCategories?.length ?? 0) + 1,
                  child: NestedScrollView(
                    // controller: _controller,
                    headerSliverBuilder: (BuildContext _, bool innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          expandedHeight: context.screenHeight * 0.22,
                          leading: const SizedBox(),
                          backgroundColor: Colors.transparent,
                          flexibleSpace: FlexibleSpaceBar(
                            background: SliderImages(
                              sliderImages:
                                  widget.merchantDetailsObject.merchant.coverImages
                                      .map((e) => '${AppConstance.imagePathApi}$e')
                                      .toList(),
                            ),
                          ),
                        ),
                        if (context.read<ClientHomeCubit>().productCategories != null)
                          SliverPersistentHeader(
                            delegate: _SliverAppBarDelegate(
                              TabBar(
                                isScrollable: true,
                                indicator: BoxDecoration(
                                  color: AppColors.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                labelPadding: EdgeInsets.zero,
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                indicatorPadding: const EdgeInsets.symmetric(horizontal: 6),
                                unselectedLabelColor: AppColors.black.withValues(alpha: 0.6),
                                unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium,
                                labelColor: Colors.white,
                                labelStyle: Theme.of(context).textTheme.bodyMedium,
                                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                                onTap: (index) {
                                  // tabIndex = index;
                                  // print('TAB INDEX ======= $tabIndex');
                                  _page = 0;
                                  searchController.clear();
                                  if (index == 0) {
                                    productCategory = '';
                                    context.read<ClientHomeCubit>().getProducts(
                                      search: searchController.text,
                                      productCategory: productCategory,
                                      merchantId: widget.merchantDetailsObject.merchant.id,
                                      page: _page,
                                    );
                                  } else {
                                    productCategory =
                                        context
                                            .read<ClientHomeCubit>()
                                            .productCategories?[index - 1]
                                            .id ??
                                        '';
                                    if (productCategory.isNotEmpty) {
                                      context.read<ClientHomeCubit>().getProducts(
                                        search: searchController.text,
                                        productCategory: productCategory,
                                        merchantId: widget.merchantDetailsObject.merchant.id,
                                        page: _page,
                                      );
                                    }
                                  }
                                },
                                tabs:
                                    [
                                      Tab(
                                        child: Container(
                                          height: double.infinity,
                                          margin: const EdgeInsets.symmetric(horizontal: 6),
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          decoration: BoxDecoration(
                                            color: AppColors.greyColor.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: Center(child: Text('الكل')),
                                          ),
                                        ),
                                      ),
                                    ] +
                                    context
                                        .read<ClientHomeCubit>()
                                        .productCategories!
                                        .map(
                                          (e) => Tab(
                                            child: Container(
                                              height: double.infinity,
                                              margin: const EdgeInsets.symmetric(horizontal: 6),
                                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                              decoration: BoxDecoration(
                                                color: AppColors.greyColor.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: Center(child: Text(e.name)),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                              widget.merchantDetailsObject.merchant,
                            ),
                            pinned: true,
                          ),
                      ];
                    },
                    body: BlocBuilder<ClientHomeCubit, ClientHomeStates>(
                      builder: (context, state) {
                        if (context.read<ClientHomeCubit>().productCategories != null &&
                            context.read<ClientHomeCubit>().productCategories!.isNotEmpty) {
                          return BlocBuilder<ClientHomeCubit, ClientHomeStates>(
                            builder: (context, state) {
                              return Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: CustomTextFormField(
                                      controller: searchController,
                                      keyboardType: TextInputType.text,
                                      hint: "ابحث عن منتج",
                                      onFieldSubmitted:
                                          (v) => context.read<ClientHomeCubit>().getProducts(
                                            search: searchController.text,
                                            productCategory: productCategory,
                                            merchantId: widget.merchantDetailsObject.merchant.id,
                                            page: _page,
                                          ),
                                      validator: (v) {
                                        return null;
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      physics: const NeverScrollableScrollPhysics(),
                                      children:
                                          [
                                            if (state is LoadingState)
                                              const DefaultCircleProgressIndicator()
                                            else if (context.read<ClientHomeCubit>().products !=
                                                    null &&
                                                context
                                                    .read<ClientHomeCubit>()
                                                    .products!
                                                    .isNotEmpty)
                                              RefreshIndicator(
                                                color: AppColors.defaultColor,
                                                onRefresh: () async {
                                                  _page = 0;
                                                  context.read<ClientHomeCubit>().getProducts(
                                                    search: searchController.text,
                                                    productCategory: productCategory,
                                                    merchantId:
                                                        widget.merchantDetailsObject.merchant.id,
                                                    page: _page,
                                                  );
                                                },
                                                child: NotificationListener<ScrollNotification>(
                                                  onNotification: (
                                                    ScrollNotification notification,
                                                  ) {
                                                    if (notification.metrics.pixels >=
                                                        notification.metrics.maxScrollExtent) {
                                                      if (!context
                                                          .read<ClientHomeCubit>()
                                                          .isProductPagination) {
                                                        // Avoid triggering multiple times
                                                        _page += 20;
                                                        context.read<ClientHomeCubit>().getProducts(
                                                          search: searchController.text,
                                                          productCategory: productCategory,
                                                          merchantId:
                                                              widget
                                                                  .merchantDetailsObject
                                                                  .merchant
                                                                  .id,
                                                          page: _page,
                                                        );
                                                      }
                                                    }
                                                    return false;
                                                  },
                                                  child: GridView.builder(
                                                    padding: const EdgeInsets.all(16),
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          crossAxisSpacing: 8,
                                                          mainAxisSpacing: 8,
                                                        ),
                                                    shrinkWrap: true,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (_, index) => ProductCardView(
                                                          product:
                                                              context
                                                                  .read<ClientHomeCubit>()
                                                                  .products![index],
                                                          blocContext: context,
                                                        ),
                                                    itemCount:
                                                        context
                                                            .read<ClientHomeCubit>()
                                                            .products!
                                                            .length,
                                                  ),
                                                ),
                                              )
                                            else
                                              NoData(
                                                refresh:
                                                    () =>
                                                        context.read<ClientHomeCubit>().getProducts(
                                                          search: searchController.text,
                                                          productCategory: productCategory,
                                                          merchantId:
                                                              widget
                                                                  .merchantDetailsObject
                                                                  .merchant
                                                                  .id,
                                                          page: 0,
                                                        ),
                                              ),
                                          ] +
                                          context.read<ClientHomeCubit>().productCategories!.map((
                                            e,
                                          ) {
                                            if (state is LoadingState) {
                                              return const DefaultCircleProgressIndicator();
                                            } else if (context.read<ClientHomeCubit>().products !=
                                                    null &&
                                                context
                                                    .read<ClientHomeCubit>()
                                                    .products!
                                                    .isNotEmpty) {
                                              return RefreshIndicator(
                                                color: AppColors.defaultColor,
                                                onRefresh: () async {
                                                  _page = 0;
                                                  context.read<ClientHomeCubit>().getProducts(
                                                    search: searchController.text,
                                                    productCategory: productCategory,
                                                    merchantId:
                                                        widget.merchantDetailsObject.merchant.id,
                                                    page: _page,
                                                  );
                                                },
                                                child: NotificationListener<ScrollNotification>(
                                                  onNotification: (
                                                    ScrollNotification notification,
                                                  ) {
                                                    if (notification.metrics.pixels >=
                                                        notification.metrics.maxScrollExtent) {
                                                      if (!context
                                                          .read<ClientHomeCubit>()
                                                          .isProductPagination) {
                                                        // Avoid triggering multiple times
                                                        _page += 20;
                                                        context.read<ClientHomeCubit>().getProducts(
                                                          search: searchController.text,
                                                          productCategory: productCategory,
                                                          merchantId:
                                                              widget
                                                                  .merchantDetailsObject
                                                                  .merchant
                                                                  .id,
                                                          page: _page,
                                                        );
                                                      }
                                                    }
                                                    return false;
                                                  },
                                                  child: GridView.builder(
                                                    padding: const EdgeInsets.all(16),
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          crossAxisSpacing: 8,
                                                          mainAxisSpacing: 8,
                                                        ),
                                                    shrinkWrap: true,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (_, index) => ProductCardView(
                                                          product:
                                                              context
                                                                  .read<ClientHomeCubit>()
                                                                  .products![index],
                                                          blocContext: context,
                                                        ),
                                                    itemCount:
                                                        context
                                                            .read<ClientHomeCubit>()
                                                            .products!
                                                            .length,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return NoData(
                                                refresh:
                                                    () =>
                                                        context.read<ClientHomeCubit>().getProducts(
                                                          search: searchController.text,
                                                          productCategory: productCategory,
                                                          merchantId:
                                                              widget
                                                                  .merchantDetailsObject
                                                                  .merchant
                                                                  .id,
                                                          page: 0,
                                                        ),
                                              );
                                            }
                                          }).toList(),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (context.read<ClientHomeCubit>().productCategories != null &&
                            context.read<ClientHomeCubit>().productCategories!.isEmpty) {
                          return NoData(
                            refresh:
                                () => context.read<ClientHomeCubit>().getProductCategories(
                                  merchantId: widget.merchantDetailsObject.merchant.id,
                                ),
                          );
                        }
                        return const DefaultCircleProgressIndicator();
                      },
                    ),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Merchant merchant;

  _SliverAppBarDelegate(this.tabBar, this.merchant);

  @override
  double get minExtent =>
      merchant.discount != null &&
              merchant.discount!.discountPercent > 0 &&
              merchant.discount!.active == true
          ? tabBar.preferredSize.height + merchant.about.length > 100
              ? 200
              : 140
          : tabBar.preferredSize.height + merchant.about.length > 100
          ? 140
          : 90;

  @override
  double get maxExtent =>
      merchant.discount != null &&
              merchant.discount!.discountPercent > 0 &&
              merchant.discount!.active == true
          ? tabBar.preferredSize.height + merchant.about.length > 100
              ? 200
              : 140
          : tabBar.preferredSize.height + merchant.about.length > 100
          ? 140
          : 90;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          if (merchant.discount != null &&
              merchant.discount!.discountPercent > 0 &&
              merchant.discount!.active == true)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.redE7.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            ImageManager.offersIcon,
                            height: 20,
                            colorFilter: const ColorFilter.mode(AppColors.redE7, BlendMode.srcIn),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: CustomText(
                              text:
                                  "خصم ${merchant.discount?.discountPercent} % لغاية ${AppConstance.currencyFormat.format(merchant.maxDiscount)} د.ع  ",
                              color: AppColors.redE7,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.redE7.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                ImageManager.calenderIcon,
                                height: 20,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.redE7,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: CustomText(
                                  text:
                                      "من ${merchant.discount?.startDate.toLocal().toIso8601String().substring(0, 10)} الى ${merchant.discount?.endDate.toLocal().toIso8601String().substring(0, 10)}",
                                  color: AppColors.redE7,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (merchant.discount != null && merchant.discount!.discountPercent > 0)
            const SizedBox(height: 10),

          /// grid view for overall look
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              merchant.about,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: AppConstance.appFomFamily,
                fontSize: 16,
                color: AppColors.grey6Color,
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(height: 38, child: Row(children: [Expanded(child: tabBar)])),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
