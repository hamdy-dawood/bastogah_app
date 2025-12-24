import 'package:bastoga/core/components/components.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routing/routes.dart';
import '../../domain/entities/otp_with_context.dart';
import '../cubit/auth_cubit.dart';

class ForgetPasswordScreen extends StatefulWidget {
  final BuildContext blocContext;

  const ForgetPasswordScreen({super.key, required this.blocContext});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('استرداد كلمة المرور')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            height: context.screenHeight,
            // child: Image.asset(ImageManager.zaitonaBgArt, fit: BoxFit.cover,),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text("ادخل رقم الهاتف الخاص بك لاستعادة كلمة المرور"),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('رقم الهاتف', style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 8),
                        CustomTextFormField(
                          controller: phoneController,
                          hint: 'ادخل رقم الهاتف',
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider.value(
          value: widget.blocContext.read<AuthCubit>(),
          child: BlocListener<AuthCubit, AuthStates>(
            listener: (context, state) {
              if (state is VerifyLoadingState) {
                showDialog(context: context, builder: (context) => const Loader());
              }
              if (state is VerifyFailState) {
                context.pop();
                showDefaultFlushBar(
                  context: context,
                  color: AppColors.redE7.withValues(alpha: 0.6),
                  messageText: state.message,
                );
              }

              if (state is VerifySuccessState) {
                context.pop();
                context.pushReplacementNamed(
                  Routes.confirmOtpScreen,
                  arguments: OTPWithContext(
                    phone: "+964${phoneController.text}",
                    otp: state.success,
                    context: widget.blocContext,
                  ),
                );
              }
            },
            child: CustomElevated(
              text: "تأكيد",
              press: () {
                if (formKey.currentState!.validate()) {
                  widget.blocContext.read<AuthCubit>().verifyPhone(
                    phoneNumber: "+964${phoneController.text}",
                  );
                } else {
                  showDefaultFlushBar(
                    context: context,
                    color: AppColors.redE7.withValues(alpha: 0.6),
                    messageText: "من فضلك ادخل رقم الهاتف",
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
