import 'package:bastoga/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DefaultCircleProgressIndicator extends StatelessWidget {
  const DefaultCircleProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: AppColors.defaultColor));
  }
}

class DefaultSmallCircleIndicator extends StatelessWidget {
  const DefaultSmallCircleIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      heightFactor: 1,
      widthFactor: 1,
      child: SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(color: AppColors.defaultColor, strokeWidth: 3),
      ),
    );
  }
}

class EmitLoadingListView extends StatelessWidget {
  const EmitLoadingListView({
    super.key,
    required this.height,
    required this.width,
    required this.radius,
    required this.count,
  });

  final double height, width, radius;
  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ShimmerWidget.circular(height: height, width: width, radius: radius),
        );
      },
    );
  }
}

class EmitLoadingHorizontalListView extends StatelessWidget {
  const EmitLoadingHorizontalListView({
    super.key,
    required this.height,
    required this.width,
    required this.radius,
    required this.count,
    this.padding = 16,
  });

  final double height, width, radius, padding;
  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(right: padding),
          child: ShimmerWidget.circular(height: height, width: width, radius: radius),
        );
      },
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  final double height, width, radius;
  final BorderRadiusGeometry? border;

  const ShimmerWidget.circular({
    super.key,
    required this.width,
    required this.height,
    required this.radius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.greyColor.withValues(alpha: 0.2),
      highlightColor: Colors.white,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.4),
          borderRadius: border ?? BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
