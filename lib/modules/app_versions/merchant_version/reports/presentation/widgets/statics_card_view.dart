import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/components/svg_icons.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/image_manager.dart';
import '../../domain/entities/report.dart';

class StaticsCardView extends StatefulWidget {
  final Report summaryReport;
  final int index;
  final int month;
  final bool isMerchant;

  const StaticsCardView({
    super.key,
    required this.summaryReport,
    required this.index,
    required this.month,
    required this.isMerchant,
  });

  @override
  State<StaticsCardView> createState() => _StaticsCardViewState();
}

class _StaticsCardViewState extends State<StaticsCardView> {
  List<String> values = [];

  @override
  void initState() {
    int getDaysInMonth(int monthNumber) {
      if (monthNumber != DateTime.now().month) {
        int year = DateTime.now().year;
        DateTime firstDayOfNextMonth = DateTime(year, monthNumber + 1, 1);
        DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(const Duration(days: 1));
        // Return the day part of the last day of the month
        return lastDayOfMonth.day;
      } else {
        int dayOfMonth = DateTime.now().day;
        return dayOfMonth;
      }
    }

    values = [
      widget.summaryReport.orderNo.toString(),
      widget.isMerchant
          ? AppConstance.currencyFormat.format(widget.summaryReport.shippingPrice)
          : AppConstance.currencyFormat.format(widget.summaryReport.driverDues),
      '${(widget.summaryReport.orderNo / getDaysInMonth(widget.month)).round()} / يوم',
      '4.8',
    ];
    super.initState();
  }

  List<String> icons = [
    ImageManager.driverOrdersIcon,
    ImageManager.driverMoneyIcon,
    ImageManager.driverSpeedIcon,
    ImageManager.driverStarIcon,
  ];

  List<String> merchantTitles = ['طلبات', 'مدفوعات توصيل', 'معدل الطلبات لليوم', 'تقييم العملاء'];

  List<String> driverTitles = ['طلبات', 'مستحقات', 'معدل التوصيل', 'تقييم العملاء'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greyF5),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey9A.withValues(alpha: 0.2),
            blurRadius: 3,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text:
                      widget.isMerchant ? merchantTitles[widget.index] : driverTitles[widget.index],
                  color: AppColors.black4B,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  maxLines: 2,
                ),
                CustomText(
                  text: values[widget.index],
                  color: AppColors.black4B,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ],
            ),
          ),
          SvgIcon(icon: icons[widget.index], color: AppColors.defaultColor, height: 24),
        ],
      ),
    );
  }
}
