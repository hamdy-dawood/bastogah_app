import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/image_manager.dart';

class NoData extends StatelessWidget {
  final Future<void> Function()? refresh;

  const NoData({super.key, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.defaultColor,
      onRefresh: refresh!,
      displacement: 0,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageManager.noDataImage,
              // scale: 6,
            ),
            Center(
              child: Text(
                'لا يوجد بيانات في الوقت الحالي',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            // Text(
            //   'قم بإضافة بعض البيانات لعرضها هنا...',
            //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
            //     fontSize: 14,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
          ],
        ),
      ),
    );
  }
}
