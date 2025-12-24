import 'package:bastoga/core/caching/shared_prefs.dart';
import 'package:bastoga/core/components/components.dart';
import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/utils/colors.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/city_field.dart';
import '../widgets/otp_fields.dart';
import '../widgets/region_field.dart';
import '../widgets/register_password_field.dart';
import '../widgets/register_phone_field.dart';
import '../widgets/register_user_name_field.dart';
import 'maintenance_screen.dart';

class RegisterOtpScreen extends StatefulWidget {
  final BuildContext registerContext;

  const RegisterOtpScreen({super.key, required this.registerContext});

  @override
  State<RegisterOtpScreen> createState() => _RegisterOtpScreenState();
}

class _RegisterOtpScreenState extends State<RegisterOtpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController firstDigitController = TextEditingController();
  TextEditingController secondDigitController = TextEditingController();
  TextEditingController thirdDigitController = TextEditingController();
  TextEditingController forthDigitController = TextEditingController();
  TextEditingController fifthDigitController = TextEditingController();
  TextEditingController sixthDigitController = TextEditingController();

  FocusNode firstDigitFocus = FocusNode();
  FocusNode secondDigitFocus = FocusNode();
  FocusNode thirdDigitFocus = FocusNode();
  FocusNode forthDigitFocus = FocusNode();
  FocusNode fifthDigitFocus = FocusNode();
  FocusNode sixthDigitFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("رمز التأكيد")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const CustomText(
                text: "ادخل رمز التأكيد المرسل لرقمك",
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 16,
                maxLines: 5,
              ),
              const SizedBox(height: 100),
              const Text('رمز التأكيد'),
              const SizedBox(height: 8),
              OtpFields(
                firstDigitController: firstDigitController,
                secondDigitController: secondDigitController,
                thirdDigitController: thirdDigitController,
                forthDigitController: forthDigitController,
                fifthDigitController: fifthDigitController,
                sixthDigitController: sixthDigitController,
                firstDigitFocus: firstDigitFocus,
                secondDigitFocus: secondDigitFocus,
                thirdDigitFocus: thirdDigitFocus,
                forthDigitFocus: forthDigitFocus,
                fifthDigitFocus: fifthDigitFocus,
                sixthDigitFocus: sixthDigitFocus,
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlocProvider.value(
                  value: widget.registerContext.read<AuthCubit>(),
                  child: BlocConsumer<AuthCubit, AuthStates>(
                    listener: (context, state) {
                      if (state is SignUpLoadingState) {
                        showDialog(context: context, builder: (context) => const Loader());
                      }

                      if (state is SignUpFailState) {
                        context.pop();
                        showDefaultFlushBar(
                          context: context,
                          color: AppColors.redE7.withValues(alpha: 0.6),
                          messageText: state.message,
                        );
                      }

                      if (state is AuthMaintenanceState) {
                        context.pop();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => MaintenanceScreen(message: state.message),
                          ),
                          (route) => false,
                        );
                      }

                      if (state is SignUpSuccessState) {
                        if (state.success.roles.first == 'client') {
                          Caching.saveData(
                            key: AppConstance.clientCachedKey,
                            value: AppConstance.clientCachedKey,
                          );
                          Future.delayed(const Duration(milliseconds: 500)).whenComplete(
                            () => context.pushNamedAndRemoveUntil(
                              Routes.clientHomeScreen,
                              predicate: (route) => false,
                            ),
                          );
                        }
                      }
                    },
                    builder: (context, state) {
                      return CustomElevated(
                        text: "تأكيد",
                        press: () {
                          if (formKey.currentState!.validate()) {
                            widget.registerContext.read<AuthCubit>().signUp(
                              userName: RegisterUserNameField.userNameController.text,
                              city: CityField.cityId,
                              phone: '+964${RegisterPhoneField.phoneController.text}',
                              region: RegionField.regionId,
                              password: RegisterPasswordField.passwordController.text,
                              otpCode:
                                  firstDigitController.text +
                                  secondDigitController.text +
                                  thirdDigitController.text +
                                  forthDigitController.text +
                                  fifthDigitController.text +
                                  sixthDigitController.text,
                            );
                          } else {
                            showDefaultFlushBar(
                              context: context,
                              color: AppColors.redE7.withValues(alpha: 0.6),
                              messageText: "من فضلك قم بإدخال جميع البيانات",
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
