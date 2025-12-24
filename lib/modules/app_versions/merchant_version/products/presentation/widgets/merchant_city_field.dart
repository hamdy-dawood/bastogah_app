import 'package:bastoga/core/components/default_emit_loading.dart';
import 'package:bastoga/core/components/default_list_view.dart';
import 'package:bastoga/core/components/default_text_form_field.dart';
import 'package:bastoga/core/components/no_data.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/helpers/sheet_helper.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/products_cubit.dart';
import 'merchant_governorate_field.dart';

class MerchantCityField extends StatefulWidget {
  const MerchantCityField({super.key, this.onCitySelected});

  final void Function()? onCitySelected;

  static TextEditingController cityController = TextEditingController();
  static String cityId = '';
  static double? cityPrice;

  @override
  State<MerchantCityField> createState() => _MerchantCityFieldState();
}

class _MerchantCityFieldState extends State<MerchantCityField> {
  @override
  void initState() {
    MerchantCityField.cityController.clear();
    MerchantCityField.cityId = '';
    MerchantCityField.cityPrice = null;
    super.initState();
  }

  void _onCitySelected(String name, String id, double price) {
    MerchantCityField.cityController.text = name;
    MerchantCityField.cityId = id;
    MerchantCityField.cityPrice = price;

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
            controller: MerchantCityField.cityController,
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
                      context.read<MerchantProductsCubit>()
                        ..getCities(region: MerchantGovernorateField.regionId),
                  child: Column(
                    children: [
                      Expanded(
                        child: BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
                          builder: (context, state) {
                            if (state is GetCitiesLoadingState) {
                              return const DefaultCircleProgressIndicator();
                            }
                            if (context.read<MerchantProductsCubit>().cities != null &&
                                context.read<MerchantProductsCubit>().cities!.isNotEmpty) {
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
                                                  .read<MerchantProductsCubit>()
                                                  .cities![index]
                                                  .name,
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            ),
                                            onTap: () {
                                              final city =
                                                  context
                                                      .read<MerchantProductsCubit>()
                                                      .cities![index];
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
                                  length: context.read<MerchantProductsCubit>().cities!.length,
                                  hasMore: false,
                                  onRefreshCall:
                                      () => context.read<MerchantProductsCubit>().getCities(
                                        region: MerchantGovernorateField.regionId,
                                      ),
                                ),
                              );
                            } else {
                              return NoData(
                                refresh:
                                    () => context.read<MerchantProductsCubit>().getCities(
                                      region: MerchantGovernorateField.regionId,
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
