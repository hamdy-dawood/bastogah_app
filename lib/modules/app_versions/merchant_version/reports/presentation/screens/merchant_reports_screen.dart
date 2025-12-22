import 'package:bastoga/core/components/bottom_nav_bar/merchant_default_bottom_nav.dart';
import 'package:bastoga/core/components/default_emit_loading.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../driver_version/reports/presentation/widgets/monthly_bar_chart_view.dart';
import '../../../../driver_version/reports/presentation/widgets/weekly_bar_chart_view.dart';
import '../cubit/merchant_reports_cubit.dart';
import '../widgets/statics_card_view.dart';

class MerchantReportsScreen extends StatefulWidget {
  const MerchantReportsScreen({super.key});

  @override
  State<MerchantReportsScreen> createState() => _MerchantReportsScreenState();
}

class _MerchantReportsScreenState extends State<MerchantReportsScreen> {
  List<String> tabs = ['الأسبوع', 'الشهر', 'العام'];

  @override
  void initState() {
    context.read<MerchantReportsCubit>().getChartReport(format: 1);
    context.read<MerchantReportsCubit>().getSummaryReport(month: DateTime.now().month);
    super.initState();
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
        title: const Text('تقارير'),
        // actions: [
        //   IconButton(
        //     pressed: () {},
        //     icon: SvgPicture.asset(
        //       ImageManager.notificationPinIcon,
        //     ),
        //   ),
        // ],
      ),
      bottomNavigationBar: const MerchantDefaultBottomNav(),
      body: DefaultTabController(
        length: tabs.length,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('الدخل', style: Theme.of(context).textTheme.titleMedium),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 12, right: 16, left: 16),
                decoration: BoxDecoration(
                  color: AppColors.greyColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 40,
                child: TabBar(
                  indicator: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelPadding: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  unselectedLabelColor: AppColors.black.withValues(alpha: 0.6),
                  unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium,
                  labelColor: Colors.white,
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                  onTap: (index) {
                    // tabIndex = index;
                    // print('TAB INDEX ======= $tabIndex');
                    context.read<MerchantReportsCubit>().getChartReport(format: index + 1);
                  },
                  tabs:
                      tabs
                          .map(
                            (e) => Tab(
                              child: Container(
                                height: double.infinity,
                                margin: const EdgeInsets.symmetric(horizontal: 0),
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                decoration: BoxDecoration(
                                  // color: AppColors.greyColor.withValues(alpha:0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(e),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
              BlocBuilder<MerchantReportsCubit, MerchantReportsStates>(
                builder: (context, state) {
                  return SizedBox(
                    height: 250,
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        if (state is ChartLoadingState)
                          const DefaultCircleProgressIndicator()
                        else if (context.read<MerchantReportsCubit>().chartReports != null &&
                            context.read<MerchantReportsCubit>().chartReports!.isNotEmpty)
                          WeeklyBarChartView(
                            data: context.read<MerchantReportsCubit>().chartReports!,
                          )
                        else
                          Center(
                            child: Text(
                              'لا يوجد بيانات فى الوقت الحالي',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        if (state is ChartLoadingState)
                          const DefaultCircleProgressIndicator()
                        else if (context.read<MerchantReportsCubit>().chartReports != null &&
                            context.read<MerchantReportsCubit>().chartReports!.isNotEmpty)
                          MonthlyBarChartView(
                            data: context.read<MerchantReportsCubit>().chartReports!,
                          )
                        else
                          Center(
                            child: Text(
                              'لا يوجد بيانات فى الوقت الحالي',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        if (state is ChartLoadingState)
                          const DefaultCircleProgressIndicator()
                        else if (context.read<MerchantReportsCubit>().chartReports != null &&
                            context.read<MerchantReportsCubit>().chartReports!.isNotEmpty)
                          MonthlyBarChartView(
                            data: context.read<MerchantReportsCubit>().chartReports!,
                          )
                        else
                          Center(
                            child: Text(
                              'لا يوجد بيانات فى الوقت الحالي',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('احصائيات الشهر', style: Theme.of(context).textTheme.titleMedium),
                    const MonthSelection(),
                    // TextContainer(
                    //   text: 'الشهر الحالي',
                    //   buttonColor: AppColors.greyColor.withValues(alpha:0.2),
                    //   fontColor: AppColors.defaultColor,
                    //   borderRadius: 5,
                    // ),
                  ],
                ),
              ),
              BlocBuilder<MerchantReportsCubit, MerchantReportsStates>(
                builder: (context, state) {
                  if (state is SummaryLoadingState) {
                    return const DefaultCircleProgressIndicator();
                  } else if (context.read<MerchantReportsCubit>().summaryReports != null &&
                      context.read<MerchantReportsCubit>().summaryReports!.isNotEmpty) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        mainAxisExtent: 90,
                      ),
                      itemCount: 3,
                      itemBuilder:
                          (context, index) => StaticsCardView(
                            summaryReport:
                                context.read<MerchantReportsCubit>().summaryReports!.first,
                            index: index,
                            month: DateTime.now().month,
                            isMerchant: true,
                          ),
                    );
                  } else {
                    return SizedBox(
                      height: 250,
                      child: Center(
                        child: Text(
                          'لا يوجد بيانات فى الوقت الحالي',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class MonthSelection extends StatefulWidget {
  const MonthSelection({super.key});

  @override
  State<MonthSelection> createState() => _MonthSelectionState();
}

class _MonthSelectionState extends State<MonthSelection> {
  List<String> months = <String>[
    DateTime.now().month == 1 ? 'الشهر الحالي' : 'يناير',
    DateTime.now().month == 2 ? 'الشهر الحالي' : 'فبراير',
    DateTime.now().month == 3 ? 'الشهر الحالي' : 'مارس',
    DateTime.now().month == 4 ? 'الشهر الحالي' : 'أبريل',
    DateTime.now().month == 5 ? 'الشهر الحالي' : 'مايو',
    DateTime.now().month == 6 ? 'الشهر الحالي' : 'يونيه',
    DateTime.now().month == 7 ? 'الشهر الحالي' : 'يوليو',
    DateTime.now().month == 8 ? 'الشهر الحالي' : 'أغسطس',
    DateTime.now().month == 9 ? 'الشهر الحالي' : 'سبتمبر',
    DateTime.now().month == 10 ? 'الشهر الحالي' : 'أكتوبر',
    DateTime.now().month == 11 ? 'الشهر الحالي' : 'نوفمبر',
    DateTime.now().month == 12 ? 'الشهر الحالي' : 'ديسمبر',
  ];
  String dropdownValue = '';

  @override
  void initState() {
    dropdownValue = months[DateTime.now().month - 1];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MerchantReportsCubit, MerchantReportsStates>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.black.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Theme(
            data: ThemeData(
              highlightColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
            ),
            child: DropdownButton<String>(
              value: dropdownValue,
              isDense: true,
              padding: EdgeInsets.zero,
              alignment: Alignment.center,
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.black),
              elevation: 2,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                // color: AppColors.defaultColor,
                color: AppColors.black,
                letterSpacing: 1.1,
              ),
              borderRadius: BorderRadius.circular(10),
              iconSize: 24,
              dropdownColor: Colors.white,
              underline: const SizedBox(),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
                context.read<MerchantReportsCubit>().getSummaryReport(
                  month: months.indexOf(dropdownValue) + 1,
                );
              },
              items:
                  months.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
            ),
          ),
        );
      },
    );
  }
}
