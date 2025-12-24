import 'package:bastoga/core/external/url_launcher.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/helpers/sheet_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/image_manager.dart';
import '../cubit/client_home_cubit.dart';
import '../screens/cart_screen.dart';

PreferredSizeWidget? defaultClientAppBar({required bool leading, required BuildContext context}) {
  List<String> phones = ["07866698539", "07866698540"];
  return AppBar(
    leadingWidth: leading ? null : 100,
    leading:
        leading
            ? IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () {
                context.pop();
              },
            )
            : GestureDetector(
              onTap: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Padding(
                padding: EdgeInsets.only(right: leading ? 0.0 : 16.0),
                child: SizedBox(height: 40, child: Image.asset(ImageManager.logo)),
              ),
            ),
    titleSpacing: 0,
    title:
        leading
            ? GestureDetector(
              onTap: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Padding(
                padding: EdgeInsets.only(right: leading ? 0.0 : 16.0),
                child: SizedBox(height: 40, width: 100, child: Image.asset(ImageManager.logo)),
              ),
            )
            : null,
    actions: [
      CartIconWidget(),
      IconButton(
        onPressed: () {
          SheetHelper.showCustomSheet(
            context: context,
            title: "الدعم الفني",
            bottomSheetContent: Column(
              children:
                  phones
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
                              ),
                              title: Text(
                                e,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(letterSpacing: 1.5),
                              ),
                              trailing: Icon(Icons.call),
                              onTap: () {
                                context.pop();
                                UrlLaunchers().phoneCallLauncher(phoneNumber: e);
                              },
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
            isForm: true,
          );
        },
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: SvgPicture.asset(ImageManager.customerSupport, height: 26),
        ),
      ),
    ],
  );
}

class CartIconWidget extends StatefulWidget {
  const CartIconWidget({super.key});

  @override
  State<CartIconWidget> createState() => _CartIconWidgetState();
}

class _CartIconWidgetState extends State<CartIconWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientHomeCubit, ClientHomeStates>(
      builder: (context, state) {
        return Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, animation, secondaryAnimation) => const CartScreen(),
                  ),
                );
              },
              icon: SvgPicture.asset(ImageManager.shoppingCartIcon, height: 26),
            ),
            if (context.read<ClientHomeCubit>().cubitCartCount.isNotEmpty)
              Positioned(
                top: 5,
                right: 5,
                child: CircleAvatar(
                  radius: 9,
                  backgroundColor: AppColors.redE7,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text(
                      '${context.read<ClientHomeCubit>().cubitCartCount.length}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 13, color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
