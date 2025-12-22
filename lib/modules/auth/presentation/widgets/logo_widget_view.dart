import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/image_manager.dart';

class LogoWidgetView extends StatelessWidget {
  const LogoWidgetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 5),
      child: SizedBox(
        height: context.screenHeight * 0.15,
        width: context.screenWidth,
        child: Image.asset(ImageManager.logo, scale: 3, alignment: Alignment.center),
      ),
    );
  }
}
