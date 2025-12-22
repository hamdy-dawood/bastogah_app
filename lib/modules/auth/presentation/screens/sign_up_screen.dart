import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/components.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/utils/colors.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/city_field.dart';
import '../widgets/logo_widget_view.dart';
import '../widgets/region_field.dart';
import '../widgets/register_password_field.dart';
import '../widgets/register_phone_field.dart';
import '../widgets/register_user_name_field.dart';

class SignUpScreen extends StatefulWidget {
  final BuildContext blocContext;

  const SignUpScreen({super.key, required this.blocContext});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    RegisterUserNameField.userNameController.clear();
    RegisterPhoneField.phoneController.clear();
    RegisterPasswordField.passwordController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.blocContext.read<AuthCubit>(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LogoWidgetView(),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.arrow_back_ios, size: 18),
                          ),
                        ),
                        Text(
                          'إنشاء حساب',
                          style: Theme.of(context).textTheme.bodyLarge,
                          // style: GoogleFonts.tajawalTextTheme().bodyLarge,
                        ),
                      ],
                    ),
                    const RegisterUserNameField(),
                    const RegisterPhoneField(),
                    RegionField(blocContext: widget.blocContext),
                    CityField(blocContext: widget.blocContext),
                    const RegisterPasswordField(),
                    const SizedBox(height: 32),
                    BlocConsumer<AuthCubit, AuthStates>(
                      listener: (context, state) {
                        if (state is SendOtpLoadingState) {
                          showDialog(context: context, builder: (context) => const Loader());
                        }
                        if (state is SendOtpFailState) {
                          context.pop();
                          showDefaultFlushBar(
                            context: context,
                            color: AppColors.redE7.withValues(alpha: 0.6),
                            messageText: state.message,
                          );
                        }

                        if (state is SendOtpSuccessState) {
                          context.pushReplacementNamed(
                            Routes.registerOtpScreen,
                            arguments: widget.blocContext,
                          );
                        }
                      },
                      builder: (context, state) {
                        return CustomElevated(
                          text: "تسجيل",
                          press: () {
                            if (!formKey.currentState!.validate()) return;
                            widget.blocContext.read<AuthCubit>().sendOtp(
                              phoneNumber: "+964${RegisterPhoneField.phoneController.text}",
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
