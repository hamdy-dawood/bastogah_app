import 'package:bastoga/core/caching/shared_prefs.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../../../../../core/components/components.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../client_version/home/presentation/widgets/city_field.dart';
import '../../../../client_version/home/presentation/widgets/governorate_field.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_states.dart';
import '../screens/merchant_request_driver.dart';
import 'request_driver_hints_field.dart';
import 'request_driver_phone_field.dart';
import 'request_driver_price_field.dart';

class RequestDriverButton extends StatelessWidget {
  const RequestDriverButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocConsumer<MerchantProductsCubit, MerchantProductsStates>(
        listener: (context, state) {
          if (state is AddOrderLoadingState) {
            showDialog(context: context, builder: (context) => const Loader());
          }

          if (state is AddOrderFailState) {
            context.pop();
            showDefaultFlushBar(
              context: context,
              color: AppColors.redE7.withValues(alpha: 0.6),
              messageText: state.message,
            );
          }

          if (state is AddOrderSuccessState) {
            context.pop();
            context.pop();
            showDefaultFlushBar(
              context: context,
              color: AppColors.greenColor.withValues(alpha: 0.6),
              messageText: 'تم طلب السائق بنجاح',
              notificationType: ToastificationType.success,
            );
          }
        },
        builder: (context, state) {
          return CustomElevated(
            text: 'طلب السائق',
            press: () {
              // if (context.read<MerchantProductsCubit>().latitude == 0 &&
              //     context.read<MerchantProductsCubit>().longitude == 0) {
              //   showDefaultFlushBar(
              //     context: context,
              //     color: AppColors.redColor,
              //     messageText: "من فضلك حدد الموقع",
              //   );
              // } else
              if (MerchantRequestDriver.formKey.currentState!.validate()) {
                context.read<MerchantProductsCubit>().addOrder(
                  // items: [],
                  // itemsPrice: double.parse(RequestDriverPriceField
                  //     .requestDriverPriceController.text),
                  // shippingPrice: double.parse(RequestDriverShippingPriceField
                  //     .requestDriverShippingPriceController.text),
                  // clientPrice: double.parse(RequestDriverPriceField
                  //         .requestDriverPriceController.text) +
                  //     double.parse(RequestDriverShippingPriceField
                  //         .requestDriverShippingPriceController.text),
                  // clientName:
                  //     RequestDriverNameField.requestDriverNameController.text,
                  // clientId: "",
                  // address: RequestDriverAddressField
                  //     .requestDriverAddressController.text,
                  // phone:
                  //     '+964${RequestDriverPhoneField.requestDriverPhoneController.text}',
                  // locationLat: context.read<MerchantProductsCubit>().latitude,
                  // locationLng: context.read<MerchantProductsCubit>().longitude,
                  // merchantId:
                  //     "${Caching.getData(key: AppConstance.loggedInUserKey)}",
                  // notes:
                  //     RequestDriverHintsField.requestDriverHintController.text,
                  items: [],
                  itemsPrice: double.parse(
                    RequestDriverPriceField.requestDriverPriceController.text,
                  ),
                  totalDiscount: 0,
                  totalAppliedDiscount: 0,
                  discountDiff: 0,
                  // shippingPrice: double.parse(RequestDriverShippingPriceField
                  //     .requestDriverShippingPriceController.text),
                  // clientPrice: double.parse(RequestDriverShippingPriceField
                  //     .requestDriverShippingPriceController.text),
                  shippingPrice: CityField.cityPrice ?? 0,
                  clientPrice: double.parse(
                    context.read<MerchantProductsCubit>().requestDriverTotalPrice,
                  ),
                  // clientName:
                  //     RequestDriverNameField.requestDriverNameController.text,
                  clientName: "--",
                  clientId: "",
                  address:
                      "${GovernorateField.governorateController.text}, ${CityField.cityController.text}",
                  // address: "",
                  region: GovernorateField.regionId,
                  city: CityField.cityId,
                  phone: '+964${RequestDriverPhoneField.requestDriverPhoneController.text}',
                  locationLat: 0,
                  locationLng: 0,
                  merchantId: "${Caching.getData(key: AppConstance.loggedInUserKey)}",
                  notes: RequestDriverHintsField.requestDriverHintController.text,
                );
              }
              // else {
              //   showDefaultFlushBar(
              //     context: context,
              //     color: AppColors.redColor.withValues(alpha:0.6),
              //     messageText: 'من فضلك قم بملأ البيانات',
              //   );
              // }
            },
          );
        },
      ),
    );
  }
}
