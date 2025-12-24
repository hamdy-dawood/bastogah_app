import 'package:bastoga/core/components/default_emit_loading.dart';
import 'package:bastoga/core/components/default_list_view.dart';
import 'package:bastoga/core/components/default_text_form_field.dart';
import 'package:bastoga/core/components/no_data.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/helpers/sheet_helper.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/modules/app_versions/client_version/home/presentation/cubit/client_home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'governorate_field.dart';

class CityField extends StatefulWidget {
  final void Function()? selectFromRequestDriver;
  final void Function()? onCitySelected;
  final String merchant;

  const CityField({
    super.key,
    this.selectFromRequestDriver,
    this.onCitySelected,
    required this.merchant,
  });

  static TextEditingController cityController = TextEditingController();
  static String cityId = '';
  static double? cityPrice;

  @override
  State<CityField> createState() => _CityFieldState();
}

class _CityFieldState extends State<CityField> {
  final TextEditingController searchCityController = TextEditingController();

  @override
  void initState() {
    CityField.cityController.clear();
    CityField.cityId = '';
    CityField.cityPrice = null;
    context.read<ClientHomeCubit>().searchCities = null;
    super.initState();
  }

  void _onCitySelected(String name, String id, double price) {
    CityField.cityController.text = name;
    CityField.cityId = id;
    CityField.cityPrice = price;

    if (widget.selectFromRequestDriver != null) {
      widget.selectFromRequestDriver!();
    }

    if (widget.onCitySelected != null) {
      widget.onCitySelected!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('المنطقة', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          CustomTextFormField(
            readOnly: true,
            controller: CityField.cityController,
            hint: 'ادخل المنطقة...',
            keyboardType: TextInputType.text,
            validator: (v) {
              if (v!.isEmpty) {
                return '';
              }
              return null;
            },
            onTap: () {
              SheetHelper.showCustomSheet(
                context: context,
                title: 'اختيار المنطقة',
                bottomSheetContent: BlocProvider.value(
                  value:
                      context.read<ClientHomeCubit>()
                        ..getCities(region: GovernorateField.regionId, merchant: widget.merchant),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: CustomTextFormField(
                          controller: searchCityController,
                          keyboardType: TextInputType.text,
                          hint: "ابحث عن المنطقة...",
                          onChanged: (v) {
                            context.read<ClientHomeCubit>().getSearchCities(v);
                          },
                        ),
                      ),
                      Expanded(
                        child: BlocBuilder<ClientHomeCubit, ClientHomeStates>(
                          builder: (context, state) {
                            if (state is GetCitiesLoadingState) {
                              return const DefaultCircleProgressIndicator();
                            }
                            if (context.read<ClientHomeCubit>().searchCities != null &&
                                context.read<ClientHomeCubit>().searchCities!.isNotEmpty) {
                              return Material(
                                color: AppColors.white,
                                child: DefaultListView(
                                  noPadding: true,
                                  refresh: (page) async {},
                                  itemBuilder:
                                      (_, index) => Padding(
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
                                            ),
                                            title: Text(
                                              context
                                                  .read<ClientHomeCubit>()
                                                  .searchCities![index]
                                                  .name,
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            ),
                                            onTap: () {
                                              final city =
                                                  context
                                                      .read<ClientHomeCubit>()
                                                      .searchCities![index];
                                              _onCitySelected(
                                                city.name,
                                                city.id,
                                                double.parse("${city.price!}"),
                                              );
                                              context.pop();
                                            },
                                          ),
                                        ),
                                      ),
                                  length: context.read<ClientHomeCubit>().searchCities!.length,
                                  hasMore: false,
                                  onRefreshCall: () async {},
                                ),
                              );
                            }
                            if (context.read<ClientHomeCubit>().cities != null &&
                                context.read<ClientHomeCubit>().cities!.isNotEmpty) {
                              return Material(
                                color: AppColors.white,
                                child: DefaultListView(
                                  noPadding: true,
                                  refresh: (page) async {},
                                  itemBuilder:
                                      (_, index) => Padding(
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
                                            ),
                                            title: Text(
                                              context.read<ClientHomeCubit>().cities![index].name,
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            ),
                                            onTap: () {
                                              final city =
                                                  context.read<ClientHomeCubit>().cities![index];
                                              _onCitySelected(
                                                city.name,
                                                city.id,
                                                double.parse("${city.price!}"),
                                              );
                                              context.pop();
                                            },
                                          ),
                                        ),
                                      ),
                                  length: context.read<ClientHomeCubit>().cities!.length,
                                  hasMore: false,
                                  onRefreshCall:
                                      () => context.read<ClientHomeCubit>().getCities(
                                        region: GovernorateField.regionId,
                                        merchant: widget.merchant,
                                      ),
                                ),
                              );
                            } else {
                              return NoData(
                                refresh:
                                    () => context.read<ClientHomeCubit>().getCities(
                                      region: GovernorateField.regionId,
                                      merchant: widget.merchant,
                                    ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
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
