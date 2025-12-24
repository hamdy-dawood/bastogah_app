import 'package:bastoga/core/components/custom_text.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:bastoga/core/utils/constance.dart';
import 'package:bastoga/core/utils/image_manager.dart';
import 'package:bastoga/modules/app_versions/driver_version/home/presentation/cubit/driver_home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverDuesScreen extends StatefulWidget {
  const DriverDuesScreen({super.key});

  @override
  State<DriverDuesScreen> createState() => _DriverDuesScreenState();
}

class _DriverDuesScreenState extends State<DriverDuesScreen> {
  @override
  void initState() {
    context.read<DriverHomeCubit>().getDriverDues();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DriverHomeCubit>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: CircleAvatar(
              backgroundColor: AppColors.defaultColor.withValues(alpha: 0.15),
              child: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: AppColors.defaultColor,
                size: 20,
              ),
            ),
          ),
        ),
        title: CustomText(
          text: "المستحقات",
          color: AppColors.black1A,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<DriverHomeCubit, DriverHomeStates>(
                builder: (context, state) {
                  return Container(
                    height: 200,
                    width: context.screenWidth,
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage(ImageManager.dues),
                        // fit: BoxFit.cover,
                      ),
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "المستحقات",
                            color: AppColors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                          const SizedBox(height: 5),
                          state is DriverDuesLoadingState
                              ? Padding(
                                padding: const EdgeInsets.all(11),
                                child: const Center(
                                  heightFactor: 1,
                                  widthFactor: 1,
                                  child: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                ),
                              )
                              : FittedBox(
                                child: CustomText(
                                  text:
                                      "${cubit.driverDues != null ? "${AppConstance.currencyFormat.format(cubit.driverDues!.driverDues)}" : "-"} د.ع",
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 36,
                                ),
                              ),
                          const SizedBox(height: 10),
                          CustomText(
                            text: "دينار عراقي",
                            color: AppColors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              CustomText(
                text: "آخر العمليات",
                color: AppColors.black1A,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
