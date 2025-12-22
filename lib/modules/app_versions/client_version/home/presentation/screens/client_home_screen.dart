import 'dart:convert';
import 'dart:developer';

import 'package:bastoga/core/components/components.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/helpers/dialog_helper.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/caching/local_cart.dart';
import '../../../../../../core/caching/local_favorite.dart';
import '../../../../../../core/caching/shared_prefs.dart';
import '../../../../../../core/components/default_emit_loading.dart';
import '../../../../../../core/components/slider_images.dart';
import '../../../../../../core/controllers/navigator_bloc/navigator_cubit.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/utils/constance.dart';
import '../../../../../../firebase_notifications.dart';
import '../../data/models/product_model.dart';
import '../cubit/client_home_cubit.dart';
import '../widgets/categories_section_view.dart';
import '../widgets/default_client_app_bar.dart';
import '../widgets/trendy_products_view.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  @override
  void initState() {
    context.read<ClientHomeCubit>().getSliders();
    if (Caching.getData(key: AppConstance.guestCachedKey) == null) {
      context.read<ClientHomeCubit>().getProfile();
      FirebaseNotifications.getFCM();
    }
    getCachedFavorites();
    getCachedCart();
    super.initState();
  }

  void getCachedFavorites() {
    List<String>? cachedFavorites = Caching.getListString(key: AppConstance.favoriteCachedKey);
    log('========fav $cachedFavorites');
    if (cachedFavorites != null) {
      favorite = cachedFavorites.map((e) => ProductModel.fromJson(jsonDecode(e))).toList();
      log('----------$favorite');
    }
  }

  void getCachedCart() {
    List<String>? cachedCart = Caching.getListString(key: AppConstance.cartCachedKey);
    log('========cart $cachedCart');
    if (cachedCart != null) {
      cart = cachedCart.map((e) => ProductModel.fromJson(jsonDecode(e))).toList();
      context.read<ClientHomeCubit>().cubitCartCount =
          cachedCart.map((e) => ProductModel.fromJson(jsonDecode(e))).toList();
      log('----------$cart');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.settings.name == Routes.clientHomeScreen) {
      context.read<NavigatorCubit>().clientCurrentIndex = 0;
    }
    return Scaffold(
      appBar: defaultClientAppBar(context: context, leading: false),
      bottomNavigationBar: const ClientDefaultBottomNav(),
      body: BlocListener<ClientHomeCubit, ClientHomeStates>(
        listener: (context, state) {
          void handleFailureState(String message) {
            showDefaultFlushBar(
              context: context,
              color: AppColors.redE7.withValues(alpha: 0.6),
              messageText: message,
            );
          }

          if (state is SlidersSuccessState) {
            context.read<ClientHomeCubit>().getCategories();
          }
          if (state is SlidersFailState) {
            handleFailureState(state.message);
          }
          if (state is CategoriesSuccessState) {
            context.read<ClientHomeCubit>().getPopularMerchants(page: 0);
          }
          if (state is CategoriesFailState) {
            handleFailureState(state.message);
          }
          if (state is PopularMerchantFailState) {
            handleFailureState(state.message);
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            SizedBox(height: context.screenHeight),
            RefreshIndicator(
              color: AppColors.defaultColor,
              onRefresh: () => context.read<ClientHomeCubit>().getSliders(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (Caching.getData(key: AppConstance.guestCachedKey) == null)
                      BlocListener<ClientHomeCubit, ClientHomeStates>(
                        listener: (context, state) {
                          if (state is ClientProfileSuccessState &&
                              context.read<ClientHomeCubit>().profile!.active == false) {
                            DialogHelper.showCustomDialog(
                              context: context,
                              alertDialog: WarningAlertPopUp(
                                image: ImageManager.warningIcon,
                                description: 'تم ايقاف حسابك من قبل الادارة',
                                onPress: () {
                                  FirebaseUnsubscribe.unsubscribeFromTopics();
                                  context.pushNamedAndRemoveUntil(
                                    Routes.loginScreen,
                                    predicate: (route) => false,
                                  );
                                  Caching.clearAllData();
                                },
                              ),
                            );
                          }
                        },
                        child: const SizedBox(),
                      ),
                    const SizedBox(height: 10),
                    BlocBuilder<ClientHomeCubit, ClientHomeStates>(
                      builder: (context, state) {
                        if (state is! LoadingState &&
                            context.read<ClientHomeCubit>().homeSliders != null &&
                            context.read<ClientHomeCubit>().homeSliders!.isNotEmpty) {
                          return SliderImages(
                            sliderImages:
                                context
                                    .read<ClientHomeCubit>()
                                    .homeSliders!
                                    .map(
                                      (e) =>
                                          e.videoLink.isNotEmpty
                                              ? "fromVideo${e.videoLink}"
                                              : '${AppConstance.imagePathApi}${e.image}',
                                    )
                                    .toList(),
                            sliders: context.read<ClientHomeCubit>().homeSliders!,
                          );
                        } else if (context.read<ClientHomeCubit>().homeSliders != null &&
                            context.read<ClientHomeCubit>().homeSliders!.isEmpty) {
                          return AspectRatio(
                            aspectRatio: 2.2,
                            child: Center(
                              child: Text(
                                'لا يوجد بيانات في الوقت الحالي',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        } else {
                          final shimmerWidth = context.screenWidth * 0.8;
                          final shimmerHeight = shimmerWidth / 2.5;

                          return Column(
                            children: [
                              Center(
                                child: Row(
                                  children: [
                                    ShimmerWidget.circular(
                                      height: shimmerHeight,
                                      width: 20,
                                      radius: 10,
                                      border: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: ShimmerWidget.circular(
                                        height: shimmerHeight,
                                        width: shimmerWidth,
                                        radius: 10,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    ShimmerWidget.circular(
                                      height: shimmerHeight,
                                      width: 20,
                                      radius: 10,
                                      border: const BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Center(
                                child: SizedBox(
                                  height: 10,
                                  width: 50,
                                  child: EmitLoadingHorizontalListView(
                                    height: 8,
                                    width: 8,
                                    radius: 50,
                                    count: 3,
                                    padding: 8,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8, right: 16, left: 16),
                      child: Text(
                        'الأقسام',
                        style: TextStyle(fontFamily: AppConstance.appFomFamily, fontSize: 18),
                      ),
                    ),
                    const CategoriesSectionView(),
                    const Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 4, right: 16, left: 16),
                      child: Text(
                        'متاجر رائجة',
                        style: TextStyle(fontFamily: AppConstance.appFomFamily, fontSize: 18),
                      ),
                    ),
                    const TrendyMerchantsView(),
                    SizedBox(height: 0.3 * context.screenWidth),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
