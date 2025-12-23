import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/routing/routes.dart';
import 'package:bastoga/modules/app_versions/client_version/home/presentation/cubit/client_home_cubit.dart';
import 'package:bastoga/modules/app_versions/client_version/home/presentation/widgets/city_field.dart';
import 'package:bastoga/modules/app_versions/client_version/home/presentation/widgets/governorate_field.dart';
import 'package:bastoga/modules/app_versions/client_version/home/presentation/widgets/success_order_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../core/caching/local_cart.dart';
import '../../../../../../core/components/components.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/constance.dart';
import '../../../../../../core/utils/image_manager.dart';
import '../../../../merchant_version/home/domain/entities/new_order_object.dart';
import '../../../my_orders/presentation/widgets/order_details_row_item.dart';
import 'order_maps_screen.dart';

class NewOrderScreen extends StatefulWidget {
  final NewOrderObject newOrderObject;

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  const NewOrderScreen({super.key, required this.newOrderObject});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  @override
  void initState() {
    widget.newOrderObject.blocContext.read<ClientHomeCubit>().checkLocationService();
    if (widget.newOrderObject.blocContext.read<ClientHomeCubit>().profile == null) {
      widget.newOrderObject.blocContext.read<ClientHomeCubit>().getProfile();
    } else {
      ClientPhoneField.clientPhoneController.text = widget.newOrderObject.blocContext
          .read<ClientHomeCubit>()
          .profile!
          .phone
          .substring(4);
      if (!ClientPhoneField.clientPhoneController.text.startsWith("0")) {
        ClientPhoneField.clientPhoneController.text =
            "0${ClientPhoneField.clientPhoneController.text}";
      }
      ClientAddressField.clientAddressController.clear();
      // ClientAddressField.clientAddressController.text =
      //     '${context.read<ClientHomeCubit>().profile!.region?.name ?? ''},${context.read<ClientHomeCubit>().profile!.city?.name ?? ''}';
    }

    // context.read<ClientHomeCubit>().getConfig();
    CityField.cityPrice = null;
    super.initState();
  }

  @override
  Widget build(BuildContext screenContext) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text(
          'اضافة طلبية جديدة',
          style: TextStyle(
            fontFamily: AppConstance.appFomFamily,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: NewOrderScreen.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GovernorateField(),
                CityField(
                  merchant: widget.newOrderObject.merchantId,
                  onCitySelected: () {
                    setState(() {});
                  },
                ),
                const ClientPhoneField(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('الموقع', style: Theme.of(context).textTheme.bodyMedium),
                ),
                BlocBuilder<ClientHomeCubit, ClientHomeStates>(
                  builder: (context, state) {
                    if (context.read<ClientHomeCubit>().selectedLng != null) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        foregroundDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.black.withValues(alpha: 0.1)),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (_, animation, secondaryAnimation) =>
                                        OrderMapsScreen(oldContext: context),
                              ),
                            );
                          },
                          child: Image.network(
                            "https://static-maps.yandex.ru/1.x/?lang=ar-EG&ll=${context.read<ClientHomeCubit>().selectedLng},${context.read<ClientHomeCubit>().selectedLat}&z=8&l=map&size=250,250&pt=${context.read<ClientHomeCubit>().selectedLng},${context.read<ClientHomeCubit>().selectedLat},vkgrm",
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (_, animation, secondaryAnimation) =>
                                      OrderMapsScreen(oldContext: context),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                          foregroundDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.black.withValues(alpha: 0.1)),
                          ),
                          child: SvgPicture.asset(ImageManager.openMapIcon, fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
                const ClientAddressField(),
                const LocationListener(),
                const SizedBox(height: 20),
                Text(
                  'تفاصيل الطلبية',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.black.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    children: [
                      BlocBuilder<ClientHomeCubit, ClientHomeStates>(
                        builder: (context, state) {
                          // if (context.read<ClientHomeCubit>().config != null) {
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
                        },
                      ),
                      BlocBuilder<ClientHomeCubit, ClientHomeStates>(
                        builder: (context, state) {
                          return CityField.cityPrice != null
                              ? Column(
                                children: [
                                  const SizedBox(height: 16),
                                  OrderDetailsRowItem(
                                    title: 'التوصيل',
                                    value: AppConstance.currencyFormat.format(CityField.cityPrice),
                                  ),
                                  const SizedBox(height: 16),
                                  OrderDetailsRowItem(
                                    title: 'الإجمالي',
                                    value: AppConstance.currencyFormat.format(
                                      widget.newOrderObject.itemsPrice + CityField.cityPrice!,
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
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AddOrderButton(newOrderObject: widget.newOrderObject),
    );
  }
}

class LocationListener extends StatelessWidget {
  const LocationListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClientHomeCubit, ClientHomeStates>(
      listener: (context, state) {
        if (state is ProfileFailState) {
          // context.pop();
          showDefaultFlushBar(
            context: context,
            color: AppColors.redE7.withValues(alpha: 0.6),
            messageText: state.message,
          );
        }

        if (state is ClientProfileSuccessState) {
          ClientPhoneField.clientPhoneController.text = context
              .read<ClientHomeCubit>()
              .profile!
              .phone
              .substring(4);
          if (!ClientPhoneField.clientPhoneController.text.startsWith("0")) {
            ClientPhoneField.clientPhoneController.text =
                "0${ClientPhoneField.clientPhoneController.text}";
          }
          ClientAddressField.clientAddressController.clear();
          // ClientAddressField.clientAddressController.text =
          //     '${context.read<ClientHomeCubit>().profile!.region?.name ?? ''},${context.read<ClientHomeCubit>().profile!.city?.name ?? ''}';
        }

        if (state is ServiceNotEnabledState) {
          showDefaultFlushBar(
            context: context,
            color: AppColors.redE7.withValues(alpha: 0.6),
            messageText: 'قم بتفعيل الوصول للموقع',
          );
        }

        if (state is CurrentPreciseLocationFailState) {
          // context.pop();
          context.read<ClientHomeCubit>().checkLocationService();
        }
        if (state is PermissionDeniedState) {
          // context.pop();
          showDefaultFlushBar(
            context: context,
            color: AppColors.redE7.withValues(alpha: 0.6),
            messageText: 'قم بإعطاء سماحية للموقع',
          );
          context.read<ClientHomeCubit>().checkLocationService();
        }

        if (state is PermissionDeniedForEverState) {
          // context.pop();
          openAppSettings().whenComplete(
            () => context.read<ClientHomeCubit>().checkLocationService(),
          );
        }
      },
      child: const SizedBox(),
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
      child: BlocConsumer<ClientHomeCubit, ClientHomeStates>(
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
            context.read<ClientHomeCubit>().clearAllCart();
            showDialog(
              context: context,
              builder:
                  (context) => SuccessOrderAlert(
                    onTap: () {
                      context.pushNamedAndRemoveUntil(
                        Routes.clientHomeScreen,
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
              if (NewOrderScreen.formKey.currentState!.validate() &&
                  context.read<ClientHomeCubit>().profile != null &&
                  context.read<ClientHomeCubit>().selectedLat != null) {
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

                context.read<ClientHomeCubit>().addOrder(
                  items: orderItems,
                  itemsPrice: newOrderObject.itemsPrice,
                  totalDiscount: totalDiscount,
                  totalAppliedDiscount: newOrderObject.totalAppliedDiscount.toDouble(),
                  discountDiff: 0,
                  shippingPrice: CityField.cityPrice!,
                  clientPrice: newOrderObject.itemsPrice + CityField.cityPrice!,
                  clientName: context.read<ClientHomeCubit>().profile!.username,
                  clientId: context.read<ClientHomeCubit>().profile!.id,
                  address: ClientAddressField.clientAddressController.text,
                  region: GovernorateField.regionId,
                  city: CityField.cityId,
                  phone: '+964${ClientPhoneField.clientPhoneController.text}',
                  locationLat: context.read<ClientHomeCubit>().selectedLat!,
                  locationLng: context.read<ClientHomeCubit>().selectedLng!,
                  merchantId: newOrderObject.merchantId,
                  notes: "",
                  maxDiscount: newOrderObject.maxDiscount,
                );
              } else if (context.read<ClientHomeCubit>().profile == null) {
                context.read<ClientHomeCubit>().getProfile();
                showDefaultFlushBar(
                  context: context,
                  color: AppColors.redE7.withValues(alpha: 0.6),
                  messageText: 'برجاء انتظار تحميل البيانات',
                );
              } else if (context.read<ClientHomeCubit>().selectedLat == null) {
                showDefaultFlushBar(
                  context: context,
                  color: AppColors.redE7.withValues(alpha: 0.6),
                  messageText: 'برجاء اختيار الموقع',
                );
              } else {
                showDefaultFlushBar(
                  context: context,
                  color: AppColors.redE7.withValues(alpha: 0.6),
                  messageText: 'برجاء ادخال جميع البيانات المطلوبة',
                );
              }
            },
          );
        },
      ),
    );
  }
}
