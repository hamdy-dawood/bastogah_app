import 'package:bastoga/core/components/default_emit_loading.dart';
import 'package:bastoga/core/components/default_list_view.dart';
import 'package:bastoga/core/components/default_text_form_field.dart';
import 'package:bastoga/core/components/no_data.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/helpers/sheet_helper.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/modules/app_versions/client_version/home/presentation/cubit/client_home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'merchant_city_field.dart';

class MerchantGovernorateField extends StatefulWidget {
  const MerchantGovernorateField({super.key});

  static TextEditingController governorateController = TextEditingController();
  static String regionId = '';

  @override
  State<MerchantGovernorateField> createState() => _MerchantGovernorateFieldState();
}

class _MerchantGovernorateFieldState extends State<MerchantGovernorateField> {
  void clearMerchantCityValue() {
    MerchantCityField.cityController.clear();
    MerchantCityField.cityId = '';
    MerchantCityField.cityPrice = null;
  }

  @override
  void initState() {
    MerchantGovernorateField.governorateController.clear();
    MerchantGovernorateField.regionId = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('المحافظة', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          CustomTextFormField(
            readOnly: true,
            controller: MerchantGovernorateField.governorateController,
            hint: 'ادخل المحافظة...',
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
                title: 'اختيار محافظة',
                bottomSheetContent: BlocProvider.value(
                  value: context.read<ClientHomeCubit>()..getGovernorate(),
                  child: Column(
                    children: [
                      Expanded(
                        child: BlocBuilder<ClientHomeCubit, ClientHomeStates>(
                          builder: (context, state) {
                            if (state is GetGovernorateLoadingState) {
                              return const DefaultCircleProgressIndicator();
                            }
                            if (context.read<ClientHomeCubit>().governorates != null &&
                                context.read<ClientHomeCubit>().governorates!.isNotEmpty) {
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
                                                  .governorates![index]
                                                  .name,
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            ),
                                            onTap: () {
                                              context.pop();
                                              MerchantGovernorateField.governorateController.text =
                                                  context
                                                      .read<ClientHomeCubit>()
                                                      .governorates![index]
                                                      .name;
                                              MerchantGovernorateField.regionId =
                                                  context
                                                      .read<ClientHomeCubit>()
                                                      .governorates![index]
                                                      .id;
                                              clearMerchantCityValue();
                                            },
                                          ),
                                        ),
                                      ),
                                  length: context.read<ClientHomeCubit>().governorates!.length,
                                  hasMore: false,
                                  onRefreshCall:
                                      () => context.read<ClientHomeCubit>().getGovernorate(),
                                ),
                              );
                            } else {
                              return NoData(
                                refresh: () => context.read<ClientHomeCubit>().getGovernorate(),
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
