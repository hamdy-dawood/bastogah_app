import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:bastoga/modules/app_versions/client_version/my_orders/domain/entities/driver_order_details_object.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/constance.dart';
import '../../../../merchant_version/home/presentation/widgets/text_container.dart';
import '../widgets/order_details_row_item.dart';
import '../widgets/order_items_widget.dart';
import '../widgets/time_date_box.dart';

class ClientOrderDetailsScreen extends StatelessWidget {
  const ClientOrderDetailsScreen({super.key, required this.driverOrderDetailsObject});

  final ClientOrderDetailsObject driverOrderDetailsObject;

  num calculateTotalOrder() {
    return driverOrderDetailsObject.order.itemsPrice + driverOrderDetailsObject.order.shippingPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      leading: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: CircleAvatar(
            backgroundColor: AppColors.defaultColor.withValues(alpha: 0.15),
            child: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: AppColors.defaultColor,
              size: 20,
            ),
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomText(
              text: "تفاصيل طلب #${driverOrderDetailsObject.order.billNo}",
              color: AppColors.black1A,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              maxLines: 3,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // if (driverOrderDetailsObject.isDriver)
              //   GestureDetector(
              //     onTap: () {
              //       showDialog(
              //         context: context,
              //         builder: (context) => AppBills(order: driverOrderDetailsObject.order),
              //       );
              //     },
              //     child: Container(
              //       padding: const EdgeInsets.all(6),
              //       decoration: BoxDecoration(
              //         color: Colors.white.withValues(alpha: 0.9),
              //         shape: BoxShape.circle,
              //       ),
              //       child: SvgPicture.asset(
              //         ImageManager.print,
              //         height: 22,
              //         colorFilter: const ColorFilter.mode(AppColors.defaultColor, BlendMode.srcIn),
              //       ),
              //     ),
              //   ),
              // const SizedBox(width: 10),
              _buildOrderStatusContainer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusContainer() {
    return TextContainer(
      text: _getOrderStatusText(driverOrderDetailsObject.order.status),
      fontColor: _getOrderStatusColor(driverOrderDetailsObject.order.status),
      borderColor: _getOrderStatusColor(driverOrderDetailsObject.order.status),
      buttonColor: Colors.white,
    );
  }

  String _getOrderStatusText(num status) {
    switch (status) {
      case 0:
        return 'انتظار';
      case 1:
        return 'بدون سائق';
      case 2:
        return 'قيد التنفيذ';
      case 3:
        return 'مكتمل';
      case 4:
        return 'ملغي';
      default:
        return 'غير معروف';
    }
  }

  Color _getOrderStatusColor(num status) {
    switch (status) {
      case 0:
      case 1:
        return AppColors.yellowColor;
      case 2:
        return AppColors.blue2Color;
      case 3:
        return AppColors.green2Color;
      case 4:
        return AppColors.redE7;
      default:
        return Colors.grey;
    }
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SizedBox(height: context.screenHeight),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildTimeAndDateSection(context),
              const SizedBox(height: 16),
              _buildPriceSection(context),
              PriceDetailsSection(driverOrderDetailsObject: driverOrderDetailsObject),
              _buildMerchantSection(context),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 1),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      driverOrderDetailsObject.order.merchantName,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 4, right: 16, left: 16),
                child: Text('المنتجات', style: Theme.of(context).textTheme.titleMedium),
              ),
              _buildProductsSection(context),
              if (driverOrderDetailsObject.order.status == 4 &&
                  driverOrderDetailsObject.order.canceledReason.isNotEmpty)
                _buildCancellationReasonSection(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeAndDateSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TimeAndDateBox(
              icon: ImageManager.calenderIcon,
              value: AppConstance.dateFormat.format(
                DateTime.parse(driverOrderDetailsObject.order.createdAt).toLocal(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TimeAndDateBox(
              icon: ImageManager.clockIcon,
              value: AppConstance.timeFormat.format(
                DateTime.parse(driverOrderDetailsObject.order.createdAt).toLocal(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4, right: 16, left: 16),
      child: Text('تفاصيل الطلبية', style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _buildMerchantSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 4, right: 16, left: 16),
      child: Text('المتجر', style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _buildProductsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: driverOrderDetailsObject.order.items.map((e) => OrderItems(item: e)).toList(),
      ),
    );
  }

  Widget _buildCancellationReasonSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
          child: Text('سبب الالغاء', style: Theme.of(context).textTheme.titleMedium),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            driverOrderDetailsObject.order.canceledReason,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.black.withValues(alpha: 0.5)),
          ),
        ),
      ],
    );
  }
}

class PriceDetailsSection extends StatelessWidget {
  final ClientOrderDetailsObject driverOrderDetailsObject;

  const PriceDetailsSection({super.key, required this.driverOrderDetailsObject});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 1)],
      ),
      child: Column(
        children: [
          if (driverOrderDetailsObject.order.totalAppliedDiscount > 0) ...[
            OrderDetailsRowItem(
              title: "إجمالي الخصم",
              value: AppConstance.currencyFormat.format(
                driverOrderDetailsObject.order.totalAppliedDiscount,
              ),
            ),
            const SizedBox(height: 16),
          ],
          OrderDetailsRowItem(
            title: 'مبلغ الطلب',
            value: AppConstance.currencyFormat.format(
              driverOrderDetailsObject.order.itemsPrice +
                  driverOrderDetailsObject.order.discountDiff,
            ),
          ),
          const SizedBox(height: 16),
          OrderDetailsRowItem(
            title: 'التوصيل',
            value: AppConstance.currencyFormat.format(driverOrderDetailsObject.order.shippingPrice),
          ),
          const SizedBox(height: 16),
          OrderDetailsRowItem(
            title: 'الإجمالي',
            value: AppConstance.currencyFormat.format(driverOrderDetailsObject.order.clientPrice),
            valueColored: true,
          ),
        ],
      ),
    );
  }
}
