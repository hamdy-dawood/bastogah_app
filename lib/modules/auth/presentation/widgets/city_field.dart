import 'package:bastoga/core/components/default_emit_loading.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/helpers/sheet_helper.dart';
import 'package:bastoga/modules/auth/presentation/cubit/auth_cubit.dart';
import 'package:bastoga/modules/auth/presentation/widgets/region_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/components.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/image_manager.dart';

class CityField extends StatefulWidget {
  final BuildContext blocContext;

  const CityField({super.key, required this.blocContext});

  static TextEditingController cityController = TextEditingController();
  static String cityId = '';

  @override
  State<CityField> createState() => _CityFieldState();
}

class _CityFieldState extends State<CityField> {
  @override
  void initState() {
    CityField.cityController.clear();
    CityField.cityId = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('المدينة', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: CityField.cityController,
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
                title: 'المدينة',
                bottomSheetContent: BlocProvider.value(
                  value:
                      widget.blocContext.read<AuthCubit>()..getCities(region: RegionField.regionId),
                  child: const _CityBottomSheetSelection(),
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

class _CityBottomSheetSelection extends StatelessWidget {
  const _CityBottomSheetSelection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: (context, state) {
        if (state is LoadingState) return const DefaultCircleProgressIndicator();
        if (context.read<AuthCubit>().cities != null &&
            context.read<AuthCubit>().cities!.isNotEmpty) {
          return ListView(
            children:
                context
                    .read<AuthCubit>()
                    .cities!
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
                                    CityField.cityId == e.id
                                        ? AppColors.defaultColor
                                        : Colors.transparent,
                              ),
                            ),
                            title: Text(e.name, style: Theme.of(context).textTheme.bodyMedium),
                            onTap: () {
                              context.pop();
                              CityField.cityController.text = e.name;
                              CityField.cityId = e.id;
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
            onRefresh: () => context.read<AuthCubit>().getCities(region: RegionField.regionId),
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
