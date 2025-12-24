import 'dart:convert';

import 'package:bastoga/core/components/bottom_nav_bar/merchant_default_bottom_nav.dart';
import 'package:bastoga/core/components/default_emit_loading.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_cubit.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_states.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/widgets/product_card_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/caching/local_cart.dart';
import '../../../../../../core/caching/shared_prefs.dart';
import '../../../../../../core/components/components.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/constance.dart';
import '../../../../client_version/home/data/models/product_model.dart';
import '../../domain/entities/product_object.dart';
import 'merchant_cart_screen.dart';

class MerchantProductsScreen extends StatefulWidget {
  const MerchantProductsScreen({super.key});

  @override
  State<MerchantProductsScreen> createState() => _MerchantProductsScreenState();
}

class _MerchantProductsScreenState extends State<MerchantProductsScreen> {
  final TextEditingController searchProductController = TextEditingController();

  @override
  void initState() {
    productCategory = '';
    context.read<MerchantProductsCubit>().getProductCategories();
    getCachedCart();
    super.initState();
  }

  String productCategory = '';

  void getCachedCart() {
    List<String>? cachedCart = Caching.getListString(key: AppConstance.cartCachedKey);
    print('========cart $cachedCart');
    if (cachedCart != null) {
      cart = cachedCart.map((e) => ProductModel.fromJson(jsonDecode(e))).toList();
      context.read<MerchantProductsCubit>().cubitCartCount =
          cachedCart.map((e) => ProductModel.fromJson(jsonDecode(e))).toList();
      print('----------$cart');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Image.asset(ImageManager.logo),
        ),
        title: const Text('المنتجات'),
        actions: [
          BlocProvider.value(
            value: context.read<MerchantProductsCubit>(),
            child: const MerchantCartIconWidget(),
          ),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: CustomTextFormField(
                  controller: searchProductController,
                  hint: 'ابحث...',
                  keyboardType: TextInputType.text,
                  prefixIcon: SvgPicture.asset(ImageManager.search),
                  onFieldSubmitted: (v) {
                    context.read<MerchantProductsCubit>().getProducts(
                      page: 0,
                      productCategory: productCategory,
                      search: searchProductController.text,
                    );
                  },
                ),
              );
            },
          ),
          BlocConsumer<MerchantProductsCubit, MerchantProductsStates>(
            listener: (context, state) {
              if (state is DeleteProductLoadingState) {
                showDialog(context: context, builder: (context) => Loader());
              }

              if (state is DeleteProductFailState) {
                context.pop();
                showDefaultFlushBar(
                  context: context,
                  color: AppColors.redE7.withValues(alpha: 0.6),
                  messageText: state.message,
                );
              }

              if (state is DeleteProductSuccessState) {
                context.pop();
                context.read<MerchantProductsCubit>().getProducts(
                  productCategory: productCategory,
                  page: 0,
                  search: searchProductController.text,
                );
              }

              if (state is ProductCategoriesSuccessState) {
                if (context.read<MerchantProductsCubit>().productCategories!.isNotEmpty) {
                  productCategory =
                      context.read<MerchantProductsCubit>().productCategories!.first.id;
                }
                if (productCategory.isNotEmpty) {
                  context.read<MerchantProductsCubit>().getProducts(
                    productCategory: productCategory,
                    page: 0,
                    search: searchProductController.text,
                  );
                }
              }
            },
            builder: (context, state) {
              if (context.read<MerchantProductsCubit>().productCategories != null &&
                  context.read<MerchantProductsCubit>().productCategories!.isNotEmpty) {
                return DefaultTabController(
                  length: context.read<MerchantProductsCubit>().productCategories!.length,
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: SizedBox(
                            height: 38,
                            child: TabBar(
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
                                productCategory =
                                    context
                                        .read<MerchantProductsCubit>()
                                        .productCategories?[index]
                                        .id ??
                                    '';
                                if (productCategory.isNotEmpty) {
                                  context.read<MerchantProductsCubit>().getProducts(
                                    productCategory: productCategory,
                                    page: 0,
                                    search: searchProductController.text,
                                  );
                                }
                              },
                              tabs:
                                  context
                                      .read<MerchantProductsCubit>()
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
                          ),
                        ),
                        state is ProductCategoriesLoadingState || state is GetProductsLoadingState
                            ? const Expanded(child: DefaultCircleProgressIndicator())
                            : Expanded(
                              child: TabBarView(
                                physics: const NeverScrollableScrollPhysics(),
                                children:
                                    context.read<MerchantProductsCubit>().productCategories!.map((
                                      e,
                                    ) {
                                      if (context.read<MerchantProductsCubit>().products != null &&
                                          context
                                              .read<MerchantProductsCubit>()
                                              .products!
                                              .isNotEmpty) {
                                        return DefaultListView(
                                          refresh:
                                              (page) =>
                                                  context.read<MerchantProductsCubit>().getProducts(
                                                    productCategory: productCategory,
                                                    page: page,
                                                    search: searchProductController.text,
                                                  ),
                                          itemBuilder:
                                              (_, index) => MerchantProductCardView(
                                                product:
                                                    context
                                                        .read<MerchantProductsCubit>()
                                                        .products![index],
                                                blocContext: context,
                                                index: index,
                                              ),
                                          length:
                                              context
                                                  .read<MerchantProductsCubit>()
                                                  .products!
                                                  .length,
                                          hasMore: false,
                                          onRefreshCall:
                                              () =>
                                                  context.read<MerchantProductsCubit>().getProducts(
                                                    productCategory: productCategory,
                                                    page: 0,
                                                    search: searchProductController.text,
                                                  ),
                                        );
                                      } else {
                                        return NoData(
                                          refresh:
                                              () =>
                                                  context.read<MerchantProductsCubit>().getProducts(
                                                    productCategory: productCategory,
                                                    page: 0,
                                                    search: searchProductController.text,
                                                  ),
                                        );
                                      }
                                    }).toList(),
                              ),
                            ),
                      ],
                    ),
                  ),
                );
              } else if (context.read<MerchantProductsCubit>().productCategories != null &&
                  context.read<MerchantProductsCubit>().productCategories!.isEmpty) {
                return NoData(
                  refresh: () => context.read<MerchantProductsCubit>().getProductCategories(),
                );
              }
              return const Expanded(child: DefaultCircleProgressIndicator());
            },
          ),
        ],
      ),
      bottomNavigationBar: const MerchantDefaultBottomNav(),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'button1',
            elevation: 1,
            backgroundColor: AppColors.defaultColor,
            onPressed: () {
              context.pushNamed(Routes.merchantRequestDriver);
            },
            child: const Icon(Icons.drive_eta_outlined, size: 20),
          ),
          const SizedBox(height: 10),
          BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
            builder: (context, state) {
              return FloatingActionButton(
                heroTag: 'button2',
                backgroundColor: AppColors.defaultColor,
                onPressed: () {
                  context.pushNamed(
                    Routes.addProductScreen,
                    arguments: ProductObject(isEdit: false, blocContext: context),
                  );
                },
                child: const Icon(Icons.add),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MerchantCartIconWidget extends StatefulWidget {
  const MerchantCartIconWidget({super.key});

  @override
  State<MerchantCartIconWidget> createState() => _MerchantCartIconWidgetState();
}

class _MerchantCartIconWidgetState extends State<MerchantCartIconWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
      builder: (context, state) {
        return Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder:
                        (_, animation, secondaryAnimation) => BlocProvider.value(
                          value: context.read<MerchantProductsCubit>(),
                          child: const MerchantCartScreen(),
                        ),
                  ),
                );
              },
              icon: SvgPicture.asset(ImageManager.shoppingCartIcon),
            ),
            if (context.read<MerchantProductsCubit>().cubitCartCount.isNotEmpty)
              Positioned(
                top: 5,
                right: 5,
                child: CircleAvatar(
                  radius: 9,
                  backgroundColor: AppColors.redE7,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text(
                      '${context.read<MerchantProductsCubit>().cubitCartCount.length}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 13, color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
