import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/utils/colors.dart';
import '../../../../merchant_version/reports/domain/entities/report.dart';

class MonthlyBarChartView extends StatefulWidget {
  MonthlyBarChartView({super.key, required this.data});

  final List<Report> data;

  final Color barBackgroundColor = AppColors.black.withValues(alpha: 0.1);

  // final Color touchedBarColor = AppColors.greenColor;

  @override
  State<StatefulWidget> createState() => MonthlyBarChartViewState();
}

class MonthlyBarChartViewState extends State<MonthlyBarChartView> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

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
    barColor ??= AppColors.defaultColor;
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

  List<BarChartGroupData> showingGroups() => List.generate(1, (i) {
    switch (i) {
      case 0:
        return makeGroupData(0, widget.data.first.orderNo, isTouched: i == touchedIndex);
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
              // '$weekDay\n',
              '',
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
        text = Text(
          widget.data.first.id!.length > 2
              ? '${widget.data.first.id}'
              : '${widget.data.first.id}  / ${DateTime.now().year}',
          style: style,
        );
        break;
      default:
        text = Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      // space: 16,
      child: text,
    );
  }
}
