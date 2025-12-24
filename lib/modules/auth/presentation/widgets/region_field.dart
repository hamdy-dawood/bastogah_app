import 'package:bastoga/core/components/default_emit_loading.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/helpers/sheet_helper.dart';
import 'package:bastoga/modules/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/components.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/image_manager.dart';
import 'city_field.dart';

class RegionField extends StatefulWidget {
  final BuildContext blocContext;

  const RegionField({super.key, required this.blocContext});

  static TextEditingController regionController = TextEditingController();
  static String regionId = '';

  @override
  State<RegionField> createState() => _RegionFieldState();
}

class _RegionFieldState extends State<RegionField> {
  @override
  void initState() {
    RegionField.regionController.clear();
    RegionField.regionId = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('المحافظة', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: RegionField.regionController,
            hint: 'اختر',
            keyboardType: TextInputType.none,
            validator: (v) {
              if (v!.isEmpty) {
                return '';
              }
              return null;
            },
            suffixIcon: const Icon(Icons.arrow_drop_down),
            onTap: () {
              SheetHelper.showCustomSheet(
                context: context,
                title: 'المحافظة',
                bottomSheetContent: BlocProvider.value(
                  value: widget.blocContext.read<AuthCubit>()..getRegions(),
                  child: const _RegionBottomSheetSelection(),
                ),
                isForm: true,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RegionBottomSheetSelection extends StatelessWidget {
  const _RegionBottomSheetSelection();

  void clearCityValue() {
    CityField.cityController.clear();
    CityField.cityId = '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: (context, state) {
        if (state is LoadingState) return const DefaultCircleProgressIndicator();
        if (context.read<AuthCubit>().regions != null &&
            context.read<AuthCubit>().regions!.isNotEmpty) {
          return ListView(
            children:
                context
                    .read<AuthCubit>()
                    .regions!
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Theme(
                          data: ThemeData(
                            highlightColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                          ),
                          child: ListTile(
                            tileColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color:
                                    RegionField.regionId == e.id
                                        ? AppColors.defaultColor
                                        : Colors.transparent,
                              ),
                            ),
                            title: Text(e.name, style: Theme.of(context).textTheme.bodyMedium),
                            onTap: () {
                              context.pop();
                              RegionField.regionController.text = e.name;
                              RegionField.regionId = e.id;
                              clearCityValue();
                            },
                          ),
                        ),
                      ),
                    )
                    .toList(),
          );
        } else {
          return RefreshIndicator(
            color: AppColors.defaultColor,
            onRefresh: () => context.read<AuthCubit>().getRegions(),
            displacement: 0,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(ImageManager.noDataImage, scale: 6),
                  Center(
                    child: Text(
                      'لا يوجد بيانات في الوقت الحالي',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
