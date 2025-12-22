import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MerchantClientRow extends StatelessWidget {
  const MerchantClientRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  final String icon, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(icon, height: 50),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 16),
            ),
            subTitle.isNotEmpty
                ? Column(
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      subTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                )
                : const SizedBox(),
          ],
        ),
      ],
    );
  }
}
