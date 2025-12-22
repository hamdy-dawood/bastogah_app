import 'package:bastoga/core/components/add_button_with_text.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/routing/routes.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/products_cubit.dart';
import '../cubit/products_states.dart';

class SelectLocationContainer extends StatelessWidget {
  const SelectLocationContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
      builder: (context, state) {
        final merchantProductsCubit = context.read<MerchantProductsCubit>();
        return AddButtonWithTextIcon(
          buttonText:
              merchantProductsCubit.latitude == 0
                  ? "تحديد موقع المستلم"
                  : "${merchantProductsCubit.latitude}, ${merchantProductsCubit.longitude}",
          icon: ImageManager.location,
          color: merchantProductsCubit.latitude == 0 ? AppColors.black : Colors.white,
          buttonColor:
              merchantProductsCubit.latitude == 0 ? AppColors.grey8Color : AppColors.blue2Color,
          onTap: () {
            context.pushNamed(Routes.routeTrackerAppMap, arguments: context);
          },
        );
      },
    );
  }
}
