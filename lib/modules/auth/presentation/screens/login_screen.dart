import 'package:bastoga/core/caching/local_cart.dart';
import 'package:bastoga/core/caching/shared_prefs.dart';
import 'package:bastoga/core/components/app_version_widget.dart';
import 'package:bastoga/core/components/components.dart';
import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routing/routes.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/logo_widget_view.dart';
import '../widgets/password_field.dart';
import '../widgets/user_name_field.dart';
import 'maintenance_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    UserNameField.userNameController.clear();
    PasswordField.passwordController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Center(
                    child: CustomText(
                      text: "مرحباً بك",
                      color: AppColors.black1A,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      maxLines: 5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const UserNameField(),
                  const PasswordField(),
                  const SizedBox(height: 32),
                  BlocConsumer<AuthCubit, AuthStates>(
                    listener: (context, state) {
                      if (state is LoginLoadingState) {
                        showDialog(context: context, builder: (context) => const Loader());
                      }
                      if (state is LoginFailState) {
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

                      if (state is LoginSuccessState) {
                        Caching.removeData(key: AppConstance.guestCachedKey);
                        context.pop();
                        if (state.role == 'merchant') {
                          Caching.removeData(key: AppConstance.cartCachedKey);
                          cart.clear();
                          Caching.saveData(
                            key: AppConstance.merchantCachedKey,
                            value: AppConstance.merchantCachedKey,
                          );
                          Future.delayed(const Duration(milliseconds: 500)).whenComplete(
                            () => context.pushNamedAndRemoveUntil(
                              Routes.merchantHomeScreen,
                              predicate: (route) => false,
                            ),
                          );
                        }

                        if (state.role == 'client') {
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

                        if (state.role == 'driver') {
                          Caching.removeData(key: AppConstance.cartCachedKey);
                          cart.clear();
                          Caching.saveData(
                            key: AppConstance.driverCachedKey,
                            value: AppConstance.driverCachedKey,
                          );
                          Future.delayed(const Duration(milliseconds: 500)).whenComplete(
                            () => context.pushNamedAndRemoveUntil(
                              Routes.driverHomeScreen,
                              predicate: (route) => false,
                            ),
                          );
                        }
                      }
                    },
                    builder: (context, state) {
                      return CustomElevated(
                        text: "دخول للحساب",
                        press: () {
                          if (!formKey.currentState!.validate()) return;
                          context.read<AuthCubit>().login(
                            userName: UserNameField.userNameController.text,
                            password: PasswordField.passwordController.text,
                          );
                        },
                        borderRadius: 15,
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'ليس لديك حساب ؟',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13),
                          ),
                          BlocBuilder<AuthCubit, AuthStates>(
                            builder: (blocContext, state) {
                              return Row(
                                children: [
                                  TextButton(
                                    style: const ButtonStyle(
                                      overlayColor: WidgetStateColor.transparent,
                                    ),
                                    onPressed: () {
                                      context
                                          .pushNamed(Routes.signUpScreen, arguments: blocContext)
                                          .whenComplete(() {
                                            UserNameField.userNameController.clear();
                                            PasswordField.passwordController.clear();
                                          });
                                    },
                                    child: Text(
                                      'إنشاء حساب',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.defaultColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'أو',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(fontSize: 13),
                                  ),
                                  TextButton(
                                    style: const ButtonStyle(
                                      overlayColor: WidgetStateColor.transparent,
                                    ),
                                    onPressed: () {
                                      Caching.saveData(
                                        key: AppConstance.guestCachedKey,
                                        value: true,
                                      );
                                      context.pushNamedAndRemoveUntil(
                                        Routes.clientHomeScreen,
                                        predicate: (route) => false,
                                      );
                                    },
                                    child: Text(
                                      'الدخول كضيف',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.defaultColor,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const SizedBox(height: 40, child: Center(child: AppVersionWidget())),
    );
  }
}
