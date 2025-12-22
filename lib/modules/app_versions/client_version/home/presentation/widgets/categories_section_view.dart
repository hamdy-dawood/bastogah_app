import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/core/utils/font_weight_helper.dart';
import 'package:bastoga/modules/app_versions/client_version/home/presentation/cubit/client_home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/components/default_emit_loading.dart';
import '../../../../../../core/routing/routes.dart';
import '../../domain/entities/sub_category_object.dart';

class CategoriesSectionView extends StatelessWidget {
  const CategoriesSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientHomeCubit, ClientHomeStates>(
      builder: (context, state) {
        if (context.read<ClientHomeCubit>().categoriesList != null &&
            context.read<ClientHomeCubit>().categoriesList!.isNotEmpty) {
          return SizedBox(
            height: 240,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 110,
                crossAxisSpacing: 0,
              ),
              itemCount: context.read<ClientHomeCubit>().categoriesList!.length,
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      Routes.subCategoryListScreen,
                      arguments: SubCategoryObject(
                        categoryName: context.read<ClientHomeCubit>().categoriesList![index].name,
                        categoryId: context.read<ClientHomeCubit>().categoriesList![index].id,
                        coverImage:
                            context.read<ClientHomeCubit>().categoriesList![index].coverImage,
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: 90,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.black.withValues(alpha: 0.1)),
                            ),
                            child: Image.network(
                              '${AppConstance.imagePathApi}${context.read<ClientHomeCubit>().categoriesList![index].image}',
                              width: context.screenWidth,
                              filterQuality: FilterQuality.high,
                              errorBuilder: (context, error, stackTrace) => const SizedBox(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.read<ClientHomeCubit>().categoriesList![index].name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: AppConstance.appFomFamily,
                            fontSize: 11,
                            fontWeight: FontWeightHelper.regular,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else if (context.read<ClientHomeCubit>().categoriesList != null &&
            context.read<ClientHomeCubit>().categoriesList!.isEmpty) {
          return SizedBox(
            height: 240,
            child: Center(
              child: Text(
                'لا يوجد بيانات في الوقت الحالي',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          return SizedBox(
            height: 240,
            child: SizedBox(
              child: GridView.builder(
                itemCount: 20,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 110,
                  crossAxisSpacing: 0,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return const Column(
                    children: [
                      Expanded(child: ShimmerWidget.circular(height: 100, width: 90, radius: 10)),
                      SizedBox(height: 8),
                      ShimmerWidget.circular(height: 10, width: 40, radius: 4),
                      SizedBox(height: 6),
                    ],
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
