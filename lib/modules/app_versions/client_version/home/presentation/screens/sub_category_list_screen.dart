import 'dart:developer';

import 'package:bastoga/core/components/components.dart';
import 'package:bastoga/core/components/default_emit_loading.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/modules/app_versions/client_version/home/presentation/cubit/client_home_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/constance.dart';
import '../../domain/entities/merchant.dart';
import '../../domain/entities/merchant_details_object.dart';
import '../../domain/entities/sub_category_object.dart';
import '../widgets/default_client_app_bar.dart';

class SubCategoryListScreen extends StatefulWidget {
  final SubCategoryObject categoryObject;

  const SubCategoryListScreen({super.key, required this.categoryObject});

  @override
  State<SubCategoryListScreen> createState() => _SubCategoryListScreenState();
}

class _SubCategoryListScreenState extends State<SubCategoryListScreen> {
  String subCategory = '';
  int _page = 0;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    context.read<ClientHomeCubit>().subCategoriesList = null;
    context.read<ClientHomeCubit>().merchantList = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value:
          context.read<ClientHomeCubit>()
            ..getSubCategories(category: widget.categoryObject.categoryId),
      child: BlocConsumer<ClientHomeCubit, ClientHomeStates>(
        listener: (context, state) {
          if (state is SubCategoriesSuccessState) {
            if (context.read<ClientHomeCubit>().subCategoriesList!.isNotEmpty) {
              subCategory = context.read<ClientHomeCubit>().subCategoriesList!.first.id;
            }
            if (subCategory.isNotEmpty) {
              context.read<ClientHomeCubit>().getMerchants(
                search: searchController.text,
                category: widget.categoryObject.categoryId,
                subCategory: subCategory,
                page: 0,
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: defaultClientAppBar(context: context, leading: true),
            body: Stack(
              fit: StackFit.expand,
              children: [
                SizedBox(
                  height: context.screenHeight,
                  // child: Image.asset(
                  //   ImageManager.zaitonaBgArt,
                  //   fit: BoxFit.cover,
                  // ),
                ),
                DefaultTabController(
                  length: context.read<ClientHomeCubit>().subCategoriesList?.length ?? 0,
                  child: NestedScrollView(
                    // controller: _controller,
                    headerSliverBuilder: (BuildContext _, bool innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          expandedHeight: 175.0,
                          leading: const SizedBox(),
                          flexibleSpace: FlexibleSpaceBar(
                            background: Image.network(
                              '${AppConstance.imagePathApi}${widget.categoryObject.coverImage}',
                              width: context.screenWidth,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              errorBuilder: (context, error, stackTrace) => const SizedBox(),
                            ),
                          ),
                        ),
                        if (context.read<ClientHomeCubit>().subCategoriesList != null)
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
                                  // HomeCubit.of(context).getDashboard(
                                  //   orderType: index == 0 ? null : ApartmentsCubit.of(context).orderTypes![index - 1].id,
                                  // );
                                  subCategory =
                                      context
                                          .read<ClientHomeCubit>()
                                          .subCategoriesList?[index]
                                          .id ??
                                      '';
                                  if (subCategory.isNotEmpty) {
                                    _page = 0;
                                    searchController.clear();
                                    context.read<ClientHomeCubit>().getMerchants(
                                      search: searchController.text,
                                      category: widget.categoryObject.categoryId,
                                      subCategory: subCategory,
                                      page: _page,
                                    );
                                  }
                                },
                                tabs:
                                    context
                                        .read<ClientHomeCubit>()
                                        .subCategoriesList!
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
                              widget.categoryObject.categoryName,
                            ),
                            pinned: true,
                          ),
                      ];
                    },
                    body:
                        state is MerchantLoadingState ||
                                context.read<ClientHomeCubit>().subCategoriesList == null
                            ? const DefaultCircleProgressIndicator()
                            : Column(
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
                                    hint: "ابحث عن متجر",
                                    validator: (v) {
                                      return null;
                                    },
                                    onFieldSubmitted:
                                        (v) => context.read<ClientHomeCubit>().getMerchants(
                                          search: searchController.text,
                                          category: widget.categoryObject.categoryId,
                                          subCategory: subCategory,
                                          page: _page,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                    physics: const NeverScrollableScrollPhysics(),
                                    children:
                                        context.read<ClientHomeCubit>().subCategoriesList!.map((e) {
                                          if (context.read<ClientHomeCubit>().merchantList !=
                                                  null &&
                                              context
                                                  .read<ClientHomeCubit>()
                                                  .merchantList!
                                                  .isNotEmpty) {
                                            return RefreshIndicator(
                                              color: AppColors.defaultColor,
                                              onRefresh: () async {
                                                _page = 0;
                                                context.read<ClientHomeCubit>().getMerchants(
                                                  search: searchController.text,
                                                  category: widget.categoryObject.categoryId,
                                                  subCategory: subCategory,
                                                  page: _page,
                                                );
                                              },
                                              child: NotificationListener<ScrollNotification>(
                                                onNotification: (ScrollNotification notification) {
                                                  if (notification.metrics.pixels >=
                                                      notification.metrics.maxScrollExtent) {
                                                    if (!context
                                                        .read<ClientHomeCubit>()
                                                        .isLoadingPagination) {
                                                      // Avoid triggering multiple times
                                                      _page += 20;
                                                      log("$_page");
                                                      context.read<ClientHomeCubit>().getMerchants(
                                                        search: searchController.text,
                                                        category: widget.categoryObject.categoryId,
                                                        subCategory: subCategory,
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
                                                        mainAxisExtent: 190,
                                                      ),
                                                  itemBuilder: (_, index) {
                                                    if (index ==
                                                        context
                                                            .read<ClientHomeCubit>()
                                                            .merchantList!
                                                            .length) {
                                                      if (context
                                                          .read<ClientHomeCubit>()
                                                          .merchantHasMore) {
                                                        return const DefaultCircleProgressIndicator();
                                                      } else {
                                                        return const SizedBox();
                                                      }
                                                    }
                                                    return SubCategoryMerchantCardView(
                                                      blocContext: context,
                                                      merchant:
                                                          context
                                                              .read<ClientHomeCubit>()
                                                              .merchantList![index],
                                                    );
                                                  },
                                                  itemCount:
                                                      context
                                                              .read<ClientHomeCubit>()
                                                              .merchantHasMore
                                                          ? context
                                                                  .read<ClientHomeCubit>()
                                                                  .merchantList!
                                                                  .length +
                                                              1
                                                          : context
                                                              .read<ClientHomeCubit>()
                                                              .merchantList!
                                                              .length,
                                                ),
                                              ),
                                            );
                                          } else if (context.read<ClientHomeCubit>().merchantList !=
                                                  null &&
                                              context
                                                  .read<ClientHomeCubit>()
                                                  .merchantList!
                                                  .isEmpty) {
                                            return NoData(
                                              refresh:
                                                  () =>
                                                      context.read<ClientHomeCubit>().getMerchants(
                                                        search: searchController.text,
                                                        category: widget.categoryObject.categoryId,
                                                        subCategory: subCategory,
                                                        page: 0,
                                                      ),
                                            );
                                          } else {
                                            return const DefaultCircleProgressIndicator();
                                          }
                                        }).toList(),
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SubCategoryMerchantCardView extends StatelessWidget {
  final Merchant merchant;
  final BuildContext blocContext;

  const SubCategoryMerchantCardView({super.key, required this.blocContext, required this.merchant});

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
          arguments: MerchantDetailsObject(
            merchant: merchant,
            // blocContext: blocContext,
          ),
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
                  flex: 2,
                  child: CachedNetworkImage(
                    imageUrl: '${AppConstance.imagePathApi}${merchant.image}',
                    width: context.screenWidth,
                    // fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    errorWidget: (context, error, stackTrace) => const SizedBox(),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        merchant.displayName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 4),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final String categoryName;

  _SliverAppBarDelegate(this.tabBar, this.categoryName);

  @override
  double get minExtent => tabBar.preferredSize.height + 60;

  @override
  double get maxExtent => tabBar.preferredSize.height + 60;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: AppColors.white,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// grid view for overall look
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                categoryName,
                // style: Theme.of(context).textTheme.bodyLarge,
                style: const TextStyle(fontFamily: AppConstance.appFomFamily, fontSize: 18),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(height: 38, child: Row(children: [Expanded(child: tabBar)])),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
