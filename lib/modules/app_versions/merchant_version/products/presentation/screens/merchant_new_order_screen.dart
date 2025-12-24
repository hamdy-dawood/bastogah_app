import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/routing/routes.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_cubit.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_states.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/widgets/merchant_city_field.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/widgets/merchant_governorate_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/caching/local_cart.dart';
import '../../../../../../core/components/components.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/constance.dart';
import '../../../../client_version/home/presentation/widgets/success_order_alert.dart';
import '../../../../client_version/my_orders/presentation/widgets/order_details_row_item.dart';
import '../../../../merchant_version/home/domain/entities/new_order_object.dart';
import '../widgets/select_location_container.dart';

class MerchantNewOrderScreen extends StatefulWidget {
  final NewOrderObject newOrderObject;

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  const MerchantNewOrderScreen({super.key, required this.newOrderObject});

  @override
  State<MerchantNewOrderScreen> createState() => _MerchantNewOrderScreenState();
}

class _MerchantNewOrderScreenState extends State<MerchantNewOrderScreen> {
  @override
  void initState() {
    ClientNameField.clientNameController.clear();
    ClientPhoneField.clientPhoneController.clear();
    ClientAddressField.clientAddressController.clear();
    MerchantCityField.cityPrice = null;
    // if (widget.newOrderObject.blocContext.read<MerchantProductsCubit>().config == null) {
    //   widget.newOrderObject.blocContext.read<MerchantProductsCubit>().getConfig();
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.newOrderObject.blocContext.read<MerchantProductsCubit>(),
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
          title: Text('اضافة طلبية جديدة', style: Theme.of(context).textTheme.bodyMedium),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: MerchantNewOrderScreen.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MerchantGovernorateField(),
                  MerchantCityField(
                    onCitySelected: () {
                      setState(() {});
                    },
                  ),
                  const ClientNameField(),
                  const ClientPhoneField(),
                  const SelectLocationContainer(),
                  const SizedBox(height: 10),
                  const ClientAddressField(),
                  const SizedBox(height: 16),
                  Text(
                    'تفاصيل الطلبية',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.black.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      children: [
                        // OrderDetailsRowItem(
                        //   title: 'سعر المنتجات',
                        //   value: AppConstance.currencyFormat
                        //       .format(widget.newOrderObject.itemsPrice),
                        // ),
                        BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
                          builder: (context, state) {
                            // if (context.read<MerchantProductsCubit>().config != null) {
                            return Column(
                              children: [
                                if (widget.newOrderObject.totalAppliedDiscount > 0) ...[
                                  OrderDetailsRowItem(
                                    title: 'إجمالي الخصم',
                                    value: AppConstance.currencyFormat.format(
                                      widget.newOrderObject.totalAppliedDiscount,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                                OrderDetailsRowItem(
                                  title: 'السعر',
                                  value: AppConstance.currencyFormat.format(
                                    widget.newOrderObject.itemsPrice,
                                  ),
                                ),
                              ],
                            );
                            // } else {
                            //   return DefaultCircleProgressIndicator();
                            // }
                          },
                        ),
                        BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
                          builder: (context, state) {
                            return MerchantCityField.cityPrice != null
                                ? Column(
                                  children: [
                                    const SizedBox(height: 16),
                                    OrderDetailsRowItem(
                                      title: 'التوصيل',
                                      value: AppConstance.currencyFormat.format(
                                        MerchantCityField.cityPrice,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    OrderDetailsRowItem(
                                      title: 'الإجمالي',
                                      value: AppConstance.currencyFormat.format(
                                        widget.newOrderObject.itemsPrice +
                                            MerchantCityField.cityPrice!,
                                      ),
                                      valueColor: AppColors.defaultColor,
                                    ),
                                  ],
                                )
                                : const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: AddOrderButton(newOrderObject: widget.newOrderObject),
      ),
    );
  }
}

class ClientNameField extends StatelessWidget {
  const ClientNameField({super.key});

  static TextEditingController clientNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('اسم العميل', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: clientNameController,
            hint: 'ادخل اسم العميل...',
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value!.isEmpty) {
                return '';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

class ClientPhoneField extends StatelessWidget {
  const ClientPhoneField({super.key});

  static TextEditingController clientPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('هاتف العميل', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: clientPhoneController,
            hint: 'ادخل رقم هاتف العميل...',
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "";
              }
              if (!value.startsWith('07')) {
                return "رقم الهاتف يجب ان يبدأ ب 07 !";
              }
              if (value.length != 11) {
                return "رقم الهاتف يجب ان يكون 11 رقم !";
              }

              return null;
            },
          ),
        ],
      ),
    );
  }
}

class ClientAddressField extends StatelessWidget {
  const ClientAddressField({super.key});

  static TextEditingController clientAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('نقطة دالة', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: clientAddressController,
            hint: 'ادخل نقطة دالة...',
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value!.isEmpty) {
                return '';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

class AddOrderButton extends StatelessWidget {
  final NewOrderObject newOrderObject;

  const AddOrderButton({super.key, required this.newOrderObject});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocConsumer<MerchantProductsCubit, MerchantProductsStates>(
        listener: (context, state) {
          if (state is AddOrderLoadingState) {
            debugPrint('-----------------------oooooooooo');
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
            context.read<MerchantProductsCubit>().clearAllCart();
            showDialog(
              context: context,
              builder:
                  (context) => SuccessOrderAlert(
                    onTap: () {
                      context.pushNamedAndRemoveUntil(
                        Routes.merchantHomeScreen,
                        predicate: (route) => false,
                      );
                    },
                  ),
            );
          }
        },
        builder: (context, state) {
          return CustomElevated(
            text: 'تاكيد الاضافة',
            press: () {
              if (context.read<MerchantProductsCubit>().latitude == 0 &&
                  context.read<MerchantProductsCubit>().longitude == 0) {
                showDefaultFlushBar(
                  context: context,
                  color: AppColors.redE7,
                  messageText: "من فضلك حدد الموقع",
                );
              } else if (MerchantNewOrderScreen.formKey.currentState!.validate()) {
                List<Map<String, dynamic>> orderItems = [];
                double totalDiscount = 0;

                for (var product in cart) {
                  num itemTotalDiscount = product.discountAmount * product.quantity;
                  totalDiscount += itemTotalDiscount;

                  orderItems.add({
                    "product": product.id,
                    "productName": product.name,
                    "qty": product.quantity,
                    "price": product.finalPrice,
                    "discount": product.discountAmount,
                    "totalPrice": product.mySellPrice,
                    "totalDiscount": product.discountAmount * product.quantity,
                    "notes": product.notes,
                    if (product.discount != null && product.discount!.isNotEmpty)
                      "discountEntity": product.discount,
                    "appliedDiscount": product.appliedDiscount,
                  });
                }
                debugPrint("$orderItems");
                context.read<MerchantProductsCubit>().addOrder(
                  items: orderItems,
                  itemsPrice: newOrderObject.itemsPrice,
                  totalDiscount: totalDiscount,
                  totalAppliedDiscount: newOrderObject.totalAppliedDiscount.toDouble(),
                  discountDiff: 0,
                  shippingPrice: MerchantCityField.cityPrice!,
                  clientPrice: newOrderObject.itemsPrice + MerchantCityField.cityPrice!,
                  clientName: ClientNameField.clientNameController.text,
                  clientId: "",
                  address: ClientAddressField.clientAddressController.text,
                  region: MerchantGovernorateField.regionId,
                  city: MerchantCityField.cityId,
                  phone: '+964${ClientPhoneField.clientPhoneController.text}',
                  locationLat: context.read<MerchantProductsCubit>().latitude,
                  locationLng: context.read<MerchantProductsCubit>().longitude,
                  merchantId: newOrderObject.merchantId,
                  notes: "",
                  maxDiscount: newOrderObject.maxDiscount,
                );
              } else {
                showDefaultFlushBar(
                  context: context,
                  color: AppColors.redE7.withValues(alpha: 0.6),
                  messageText: 'من فضلك قم بملأ البيانات',
                );
              }
            },
          );
        },
      ),
    );
  }
}
