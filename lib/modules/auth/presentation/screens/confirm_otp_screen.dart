import 'package:bastoga/core/components/components.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:bastoga/core/helpers/sheet_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/utils/colors.dart';
import '../../domain/entities/otp_with_context.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/otp_fields.dart';

class ConfirmOtpScreen extends StatefulWidget {
  final OTPWithContext otpWithContext;

  const ConfirmOtpScreen({super.key, required this.otpWithContext});

  @override
  State<ConfirmOtpScreen> createState() => _ConfirmOtpScreenState();
}

class _ConfirmOtpScreenState extends State<ConfirmOtpScreen> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
  void initState() {
    userController.text = widget.otpWithContext.otp.users.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("تغيير كلمة المرور")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('اسم المستخدم'),
              const SizedBox(height: 8),
              CustomTextFormField(
                title: "اسم المستخدم",
                hint: "اسم المستخدم",
                controller: userController,
                keyboardType: TextInputType.none,
                onTap: () {
                  SheetHelper.showCustomSheet(
                    context: context,
                    title: "اسم المستخدم",
                    bottomSheetContent: Material(
                      color: AppColors.white,
                      child: ListView(
                        children:
                            widget.otpWithContext.otp.users
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
                                                userController.text == e
                                                    ? AppColors.defaultColor
                                                    : Colors.transparent,
                                          ),
                                        ),
                                        title: Text(
                                          e,
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                        onTap: () {
                                          context.pop();
                                          userController.text = e;
                                        },
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                    isForm: true,
                  );
                },
                validator: (v) {
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('كود الدخول المستلم'),
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
              const SizedBox(height: 16),
              const Text('كلمة المرور الجديدة'),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                hint: "كلمة المرور الجديدة",
                validator: (v) {
                  if (v!.isEmpty) {
                    return "";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider.value(
          value: widget.otpWithContext.context.read<AuthCubit>(),
          child: BlocConsumer<AuthCubit, AuthStates>(
            listener: (context, state) {
              if (state is ChangePasswordLoadingState) {
                showDialog(context: context, builder: (context) => const Loader());
              }

              if (state is ChangePasswordFailState) {
                context.pop();
                showDefaultFlushBar(
                  context: context,
                  color: AppColors.redE7.withValues(alpha: 0.6),
                  messageText: state.message,
                );
              }

              if (state is ChangePasswordSuccessState) {
                showDefaultFlushBar(
                  context: context,
                  color: AppColors.greenColor.withValues(alpha: 0.6),
                  messageText: "تم الحفظ بنجاح.",
                );
                context.pushNamedAndRemoveUntil(Routes.loginScreen, predicate: (route) => false);
              }
            },
            builder: (context, state) {
              return CustomElevated(
                text: "تأكيد",
                press: () {
                  if (formKey.currentState!.validate()) {
                    context.read<AuthCubit>().changePassword(
                      phone: widget.otpWithContext.phone,
                      otpCode:
                          firstDigitController.text +
                          secondDigitController.text +
                          thirdDigitController.text +
                          forthDigitController.text +
                          fifthDigitController.text +
                          sixthDigitController.text,
                      username: userController.text,
                      newPassword: passwordController.text,
                    );
                  } else {
                    showDefaultFlushBar(
                      context: context,
                      color: AppColors.redE7.withValues(alpha: 0.6),
                      messageText: "من فضلك قم بإدخال جميع البيانات",
                    );
                  }
                },
                btnColor: AppColors.defaultColor,
              );
            },
          ),
        ),
      ),
    );
  }
}
