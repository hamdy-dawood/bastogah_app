import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/image_manager.dart';

class NoWifi extends StatelessWidget {
  final Future<void> Function() refresh;

  const NoWifi({Key? key, required this.refresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overScroll) {
        overScroll.disallowIndicator();
        return false;
      },
      child: RefreshIndicator(
        color: AppColors.defaultColor,
        onRefresh: refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 140),
              Image.asset(ImageManager.noWifiImage, scale: 6),
              Center(
                child: Text(
                  'لا يوجد اتصال بالإنترنت',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'من فضلك قم بتوصيل الشبكة والمحاولة مرة أخري',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
