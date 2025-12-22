import 'package:bastoga/core/utils/constance.dart';
import 'package:flutter/material.dart';

class BillRow extends StatelessWidget {
  final String title;
  final String value;
  final double addFontSize;

  const BillRow({required this.title, required this.value, this.addFontSize = 0, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConstance.printer58Width,
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 30 + addFontSize,
              fontWeight: FontWeight.w600,
              fontFamily: AppConstance.appFomFamily,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 22 + addFontSize,
              fontWeight: FontWeight.w600,
              fontFamily: AppConstance.appFomFamily,
            ),
          ),
        ],
      ),
    );
  }
}
