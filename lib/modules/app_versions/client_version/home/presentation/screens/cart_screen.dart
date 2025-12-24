import 'package:bastoga/core/caching/local_cart.dart';
import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:bastoga/modules/app_versions/client_version/home/presentation/cubit/client_home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/caching/shared_prefs.dart';
import '../../../../../../core/components/components.dart';
import '../../../../../../core/helpers/dialog_helper.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../merchant_version/home/domain/entities/new_order_object.dart';
import '../../domain/entities/product.dart';
import '../widgets/cart_product_card_view.dart';
import '../widgets/max_discount_applier.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double totalItemsPrice() {
    double total = 0;
    for (var item in cart) {
      final applied = _appliedDiscounts.firstWhere(
        (e) => e.item.id == item.id,
        orElse: () => AppliedDiscountResult(item: item, appliedDiscount: 0, unAppliedDiscount: 0),
      );

      item.mySellPrice = (item.price * item.quantity) - applied.appliedDiscount;
      total += item.mySellPrice;
    }
    return total;
  }

  double totalDiscountPrice() {
    double total = 0;
    for (var item in _appliedDiscounts) {
      total += item.appliedDiscount;
    }
    return total;
  }

  double remainDiscountPrice() {
    double total = 0;
    for (var item in _appliedDiscounts) {
      if (item.appliedDiscount > 0) {
        total += item.unAppliedDiscount;
      }
    }
    return total;
  }

  bool isMerchantOpen(Product product) {
    // Parse opening time
    List<String> openParts = product.merchant.openTime.split(':');
    int openH = int.parse(openParts[0]);
    int openM = int.parse(openParts[1]);
    int openMinutes = (openH * 60) + openM;

    // Parse closing time
    List<String> closeParts = product.merchant.closeTime.split(':');
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

  List<AppliedDiscountResult> _appliedDiscounts = [];

  @override
  void initState() {
    if (cart.isNotEmpty) {
      _appliedDiscounts = DiscountApplier.applyMaxDiscounts(
        cartItems: cart,
        maxDiscountPerOrder: cart[0].merchant.maxDiscount,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leadingWidth: 50,
      leading: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: const Icon(Icons.arrow_back_ios_new_outlined),
      ),
      title: RichText(
        text: TextSpan(
          text: 'السلة ',
          style: const TextStyle(
            fontFamily: AppConstance.appFomFamily,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          children: <TextSpan>[
            TextSpan(
              text: ' (${cart.length}) منتجات',
              style: const TextStyle(
                fontFamily: AppConstance.appFomFamily,
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      actions: [_buildDeleteAction(context)],
    );
  }

  Widget _buildDeleteAction(BuildContext context) {
    return BlocBuilder<ClientHomeCubit, ClientHomeStates>(
      builder: (context, state) {
        if (context.read<ClientHomeCubit>().cubitCartCount.isNotEmpty) {
          return GestureDetector(
            onTap: () {
              DialogHelper.showCustomDialog(
                context: context,
                alertDialog: WarningAlertPopUp(
                  image: ImageManager.warningIcon,
                  description: 'هل أنت متأكد من حذف جميع المنتجات في السله ؟',
                  btnContent: 'حذف',
                  onPress: () {
                    context.pop();
                    context.read<ClientHomeCubit>().clearAllCart();
                    Future.delayed(const Duration(milliseconds: 200)).whenComplete(() {
                      setState(() {});
                    });
                  },
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: SvgPicture.asset(
                  ImageManager.deleteIcon,
                  height: 22,
                  colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                ),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SizedBox(height: context.screenHeight),
        cart.isNotEmpty ? _buildCartContent(context) : _buildNoData(context),
      ],
    );
  }

  Widget _buildCartContent(BuildContext context) {
    return BlocBuilder<ClientHomeCubit, ClientHomeStates>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: DefaultListView(
                refresh: (page) async {},
                itemBuilder:
                    (_, index) => CartProductCardView(
                      product: cart[index],
                      appliedDiscountResult:
                          _appliedDiscounts.any((e) => e.item.id == cart[index].id)
                              ? _appliedDiscounts.firstWhere((e) => e.item.id == cart[index].id)
                              : null,
                      blocContext: context,
                      isMerchant: false,
                      increase: () {
                        context.read<ClientHomeCubit>().increaseProductInCartCubit(cart[index]);
                        setState(() {
                          _appliedDiscounts = DiscountApplier.applyMaxDiscounts(
                            cartItems: cart,
                            maxDiscountPerOrder: cart[0].merchant.maxDiscount,
                          );
                        });
                      },
                      decrease: () {
                        context.read<ClientHomeCubit>().decreaseProductFromCartCubit(cart[index]);
                        setState(() {
                          _appliedDiscounts = DiscountApplier.applyMaxDiscounts(
                            cartItems: cart,
                            maxDiscountPerOrder: cart[0].merchant.maxDiscount,
                          );
                        });
                      },
                      remove: () {
                        context.pop();
                        setState(() {
                          context.read<ClientHomeCubit>().removeProductFromCartCubit(cart[index]);
                          _appliedDiscounts = DiscountApplier.applyMaxDiscounts(
                            cartItems: cart,
                            maxDiscountPerOrder: cart[0].merchant.maxDiscount,
                          );
                        });
                      },
                    ),
                length: cart.length,
                hasMore: false,
                onRefreshCall: () async {
                  setState(() {
                    _appliedDiscounts = DiscountApplier.applyMaxDiscounts(
                      cartItems: cart,
                      maxDiscountPerOrder: cart[0].merchant.maxDiscount,
                    );
                  });
                },
              ),
            ),
            _buildCartSummary(context),
          ],
        );
      },
    );
  }

  Widget _buildCartSummary(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey9A.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          SizedBox(
            child:
                cart.isNotEmpty && totalDiscountPrice() > 0
                    ? Container(
                      decoration: BoxDecoration(
                        color: AppColors.redE7,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            ImageManager.offersIcon,
                            height: 20,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: FittedBox(
                              child: CustomText(
                                text:
                                    "خصم لغاية ${AppConstance.currencyFormat.format(cart[0].merchant.maxDiscount)} د.ع  ",
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    : null,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (totalDiscountPrice() > 0)
                  _buildSummaryItem(context: context, label: 'توفير', value: totalDiscountPrice())
                else
                  const SizedBox(),
                // if (remainDiscountPrice() > 0)
                //   _buildSummaryItem(
                //     context: context,
                //     label: 'فرق الخصم',
                //     value: remainDiscountPrice(),
                //   ),
                _buildSummaryItem(
                  context: context,
                  label: 'الإجمالي',
                  value: totalItemsPrice(),
                  value1: totalItemsPrice() + totalDiscountPrice(),
                  highlight: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CustomElevated(text: 'الطلب الآن', press: () => _handleOrderNow(context)),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required BuildContext context,
    required String label,
    required double value,
    double? value1,
    bool highlight = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: label, color: AppColors.black, fontSize: 12, fontWeight: FontWeight.w600),
        const SizedBox(height: 2),
        if (value1 != null && value1 > 0 && value1 != value)
          CustomText(
            text: "${AppConstance.currencyFormat.format(value1)} د.ع",
            color: AppColors.redE7,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            textDecoration: TextDecoration.lineThrough,
          ),
        CustomText(
          text: "${AppConstance.currencyFormat.format(value)} د.ع",
          color: highlight ? AppColors.defaultColor : AppColors.black,
          fontSize: highlight ? 15 : 14,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  Widget _buildNoData(BuildContext context) {
    return NoData(
      refresh: () async {
        setState(() {});
      },
    );
  }

  void _handleOrderNow(BuildContext context) {
    if (Caching.getData(key: AppConstance.guestCachedKey) != null) {
      DialogHelper.showCustomDialog(
        context: context,
        alertDialog: WarningAlertPopUp(
          image: ImageManager.warningIcon,
          description: 'قم بتسجيل الدخول أولا!',
          btnContent: 'تسجيل الدخول',
          onPress: () {
            context.pushNamedAndRemoveUntil(Routes.loginScreen, predicate: (route) => false);
          },
        ),
      );
    } else {
      if (isMerchantOpen(cart[0])) {
        context.pushNamed(
          Routes.newOrderScreen,
          arguments: NewOrderObject(
            blocContext: context,
            itemsPrice: totalItemsPrice(),
            merchantId: cart[0].merchant.id,
            maxDiscount: cart[0].merchant.maxDiscount,
            totalAppliedDiscount: totalDiscountPrice(),
          ),
        );
      } else {
        DialogHelper.showCustomDialog(
          context: context,
          alertDialog: WarningAlertPopUp(
            description: 'من فضلك قم بالطلب في مواعيد العمل لهذا المتجر',
            btnContent: 'حسنا',
            onPress: () {
              context.pop();
            },
          ),
        );
      }
    }
  }
}
