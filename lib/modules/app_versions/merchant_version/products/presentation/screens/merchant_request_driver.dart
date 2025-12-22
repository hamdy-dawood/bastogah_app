import 'package:bastoga/core/caching/shared_prefs.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/modules/app_versions/client_version/home/presentation/cubit/client_home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/components/default_flushbar.dart';
import '../../../../../../core/dependancy_injection/dependancy_injection.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../client_version/home/presentation/widgets/city_field.dart';
import '../../../../client_version/home/presentation/widgets/governorate_field.dart';
import '../cubit/products_cubit.dart';
import '../widgets/request_driver_button.dart';
import '../widgets/request_driver_hints_field.dart';
import '../widgets/request_driver_phone_field.dart';
import '../widgets/request_driver_price_field.dart';
import '../widgets/request_driver_shipping_price_field.dart';

class MerchantRequestDriver extends StatelessWidget {
  const MerchantRequestDriver({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return const _MerchantRequestDriverBody();
  }
}

class _MerchantRequestDriverBody extends StatefulWidget {
  const _MerchantRequestDriverBody();

  @override
  State<_MerchantRequestDriverBody> createState() => _MerchantRequestDriverBodyState();
}

class _MerchantRequestDriverBodyState extends State<_MerchantRequestDriverBody> {
  @override
  void initState() {
    // RequestDriverNameField.requestDriverNameController.clear();
    RequestDriverPhoneField.requestDriverPhoneController.clear();
    RequestDriverPriceField.requestDriverPriceController.clear();
    // RequestDriverShippingPriceField.requestDriverShippingPriceController
    //     .clear();
    // RequestDriverAddressField.requestDriverAddressController.clear();
    RequestDriverHintsField.requestDriverHintController.clear();
    context.read<ClientHomeCubit>().getGovernorate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClientHomeCubit, ClientHomeStates>(
      listener: (context, state) {
        if (state is GetGovernorateSuccessState) {
          bool isBabelExist = context.read<ClientHomeCubit>().governorates!.any(
            (g) => g.name.contains("بابل"),
          );
          if (isBabelExist) {
            final babel = context.read<ClientHomeCubit>().governorates!.firstWhere(
              (g) => g.name.contains("بابل"),
            );
            GovernorateField.governorateController.text = babel.name;
            GovernorateField.regionId = babel.id;
          } else {
            GovernorateField.governorateController.clear();
            GovernorateField.regionId = "";
            showDefaultFlushBar(
              context: context,
              color: AppColors.redE7.withValues(alpha: 0.6),
              messageText: "تعذر الوصول الي محافظة بابل، يرجى المحاولة لاحقاً.",
            );
          }
        }

        if (state is GetGovernorateFailState) {
          showDefaultFlushBar(
            context: context,
            color: AppColors.redE7.withValues(alpha: 0.6),
            messageText: state.message,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              context.pop();
            },
          ),
          title: const Text("طلب سائق"),
        ),
        body: RefreshIndicator(
          color: AppColors.defaultColor,
          onRefresh: () async {
            await context.read<ClientHomeCubit>().getGovernorate();
          },
          child: Form(
            key: MerchantRequestDriver.formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: BlocProvider(
                  create: (context) => getIt<ClientHomeCubit>(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      // RequestDriverNameField(),
                      // SizedBox(height: 10),
                      // RequestDriverShippingPriceField(),
                      // GovernorateField(),
                      // SizedBox(height: 10),
                      CityField(
                        selectFromRequestDriver:
                            () =>
                                context
                                    .read<MerchantProductsCubit>()
                                    .changeRequestDriverTotalPrice(),
                        merchant: "${Caching.getData(key: AppConstance.loggedInUserKey)}",
                        onCitySelected: () {
                          setState(() {});
                        },
                      ),
                      // BlocBuilder<ClientHomeCubit, ClientHomeStates>(
                      //   builder: (context, state) {
                      //     return Text(CityField.cityPrice.toString());
                      //   },
                      // ),
                      const SizedBox(height: 10),
                      const RequestDriverPhoneField(),
                      const SizedBox(height: 10),
                      const RequestDriverPriceField(),
                      const SizedBox(height: 10),
                      // RequestDriverTotalPriceField(),
                      const RequestDriverShippingPriceField(),
                      const SizedBox(height: 10),
                      // SelectLocationContainer(),
                      // SizedBox(height: 10),
                      // RequestDriverAddressField(),
                      // SizedBox(height: 10),
                      const RequestDriverHintsField(),
                      const SizedBox(height: 15),
                      const RequestDriverButton(),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
