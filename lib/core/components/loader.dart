import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        child: Chip(
          autofocus: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.all(20.0),
          backgroundColor: AppColors.black,
          label: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 25,
                width: 25,
                child: CupertinoActivityIndicator(
                  // strokeWidth: 3,
                  color: Colors.white,
                ),
              ),
              // SizedBox(height: 15,),
              // Text(
              //   'Loading',
              //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              //     color: Colors.white
              //   )
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
