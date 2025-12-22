import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/image_manager.dart';

class TrendIconView extends StatelessWidget {
  const TrendIconView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 25,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: SvgPicture.asset(ImageManager.trendIcon),
    );
  }
}
