import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/components/default_emit_loading.dart';
import '../../../../../../core/components/default_horizontal_list_view.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/utils/constance.dart';
import '../../domain/entities/merchant_details_object.dart';
import '../cubit/client_home_cubit.dart';

class TrendyMerchantsView extends StatelessWidget {
  const TrendyMerchantsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientHomeCubit, ClientHomeStates>(
      builder: (context, state) {
        if (context.read<ClientHomeCubit>().popularMerchantsList != null &&
            context.read<ClientHomeCubit>().popularMerchantsList!.isNotEmpty) {
          return SizedBox(
            height: 135,
            child: DefaultHorizontalListView(
              refresh: (page) => context.read<ClientHomeCubit>().getPopularMerchants(page: page),
              itemBuilder:
                  (_, index) => GestureDetector(
                    onTap: () {
                      context.pushNamed(
                        Routes.merchantDetailsScreen,
                        arguments: MerchantDetailsObject(
                          merchant: context.read<ClientHomeCubit>().popularMerchantsList![index],
                          // blocContext: context,
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
                      constraints: const BoxConstraints(minWidth: 150),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      foregroundDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.black.withValues(alpha: 0.1)),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            '${AppConstance.imagePathApi}${context.read<ClientHomeCubit>().popularMerchantsList![index].image}',
                        errorWidget:
                            (context, url, error) => const Icon(Icons.error, color: Colors.grey),
                      ),
                    ),
                  ),
              length: context.read<ClientHomeCubit>().popularMerchantsList!.length,
              hasMore: context.read<ClientHomeCubit>().popularHasMore,
              onRefreshCall: () => context.read<ClientHomeCubit>().getPopularMerchants(page: 0),
            ),
          );
        } else if (context.read<ClientHomeCubit>().popularMerchantsList != null &&
            context.read<ClientHomeCubit>().popularMerchantsList!.isEmpty) {
          return SizedBox(
            height: 100,
            child: Center(
              child: Text(
                'لا يوجد بيانات في الوقت الحالي',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          return const SizedBox(
            height: 135,
            child: EmitLoadingHorizontalListView(height: 135, width: 150, radius: 10, count: 10),
          );
        }
      },
    );
  }
}
