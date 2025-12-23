import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/utils/colors.dart';
import '../../../../merchant_version/reports/domain/entities/report.dart';

class WeeklyBarChartView extends StatefulWidget {
  WeeklyBarChartView({super.key, required this.data});

  final List<Report> data;

  final Color barBackgroundColor = AppColors.black.withValues(alpha: 0.1);

  @override
  State<StatefulWidget> createState() => WeeklyBarChartViewState();
}

class WeeklyBarChartViewState extends State<WeeklyBarChartView> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  Color getBarColor(int day) {
    String weekDay;
    switch (day) {
      case 0:
        weekDay = 'الأحد';
        break;
      case 1:
        weekDay = 'الاثنين';
        break;
      case 2:
        weekDay = 'الثلاثاء';
        break;
      case 3:
        weekDay = 'الأربعاء';
        break;
      case 4:
        weekDay = 'الخميس';
        break;
      case 5:
        weekDay = 'الجمعة';
        break;
      case 6:
        weekDay = 'السبت';
        break;
      default:
        throw Error();
    }
    final String currentDay = DateFormat('EEEE').format(DateTime.now());
    if (weekDay == currentDay) {
      return AppColors.defaultColor;
    } else {
      return AppColors.defaultColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(mainBarData());
  }

  double getMaxBackHeight() {
    num highestNumber =
        widget.data.isNotEmpty
            ? widget.data.map((obj) => obj.orderNo).reduce((a, b) => a > b ? a : b)
            : 0;
    return highestNumber.toDouble() * 1.5;
  }

  BarChartGroupData makeGroupData(
    int x,
    num y, {
    bool isTouched = false,
    Color? barColor,
    double width = 40,
  }) {
    barColor ??= getBarColor(x);
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y.toDouble() + 1 : y.toDouble(),
          color: barColor,
          width: width,
          borderSide:
              isTouched
                  ? BorderSide(color: barColor)
                  : const BorderSide(color: Colors.white, width: 0),
          borderRadius: BorderRadius.circular(5),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: getMaxBackHeight(),
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: [0],
    );
  }

  String getDayFromBackend(String day) {
    for (var d in widget.data) {
      if (d.id == day) return day;
    }
    return '';
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
    switch (i) {
      case 0:
        return makeGroupData(
          0,
          getDayFromBackend('1').isNotEmpty
              ? widget.data.firstWhere((element) => element.id == '1').orderNo
              : 0,
          isTouched: i == touchedIndex,
        );
      case 1:
        return makeGroupData(
          1,
          getDayFromBackend('2').isNotEmpty
              ? widget.data.firstWhere((element) => element.id == '2').orderNo
              : 0,
          isTouched: i == touchedIndex,
        );
      case 2:
        return makeGroupData(
          2,
          getDayFromBackend('3').isNotEmpty
              ? widget.data.firstWhere((element) => element.id == '3').orderNo
              : 0,
          isTouched: i == touchedIndex,
        );
      case 3:
        return makeGroupData(
          3,
          getDayFromBackend('4').isNotEmpty
              ? widget.data.firstWhere((element) => element.id == '4').orderNo
              : 0,
          isTouched: i == touchedIndex,
        );
      case 4:
        return makeGroupData(
          4,
          getDayFromBackend('5').isNotEmpty
              ? widget.data.firstWhere((element) => element.id == '5').orderNo
              : 0,
          isTouched: i == touchedIndex,
        );
      case 5:
        return makeGroupData(
          5,
          getDayFromBackend('6').isNotEmpty
              ? widget.data.firstWhere((element) => element.id == '6').orderNo
              : 0,
          isTouched: i == touchedIndex,
        );
      case 6:
        return makeGroupData(
          6,
          getDayFromBackend('7').isNotEmpty
              ? widget.data.firstWhere((element) => element.id == '7').orderNo
              : 0,
          isTouched: i == touchedIndex,
        );
      default:
        return throw Error();
    }
  });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.transparent,
          tooltipHorizontalAlignment: FLHorizontalAlignment.center,
          tooltipMargin: 0,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              "",
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              children: <TextSpan>[
                TextSpan(
                  text: group.x == touchedIndex ? (rod.toY - 1).toString() : (rod.toY).toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, getTitlesWidget: getTitles, reservedSize: 38),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    TextStyle style = Theme.of(context).textTheme.bodySmall!;
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text('الأحد', style: style);
        break;
      case 1:
        text = Text('الإثنين', style: style);
        break;
      case 2:
        text = Text('الثلاثاء', style: style);
        break;
      case 3:
        text = Text('الأربعاء', style: style);
        break;
      case 4:
        text = Text('الخميس', style: style);
        break;
      case 5:
        text = Text('الجمعة', style: style);
        break;
      case 6:
        text = Text('السبت', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }
}
