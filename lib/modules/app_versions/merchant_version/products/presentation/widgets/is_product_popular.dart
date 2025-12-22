import 'package:flutter/material.dart';

class IsProductPopularView extends StatefulWidget {
  static bool isSelected = false;

  const IsProductPopularView({super.key});

  @override
  State<IsProductPopularView> createState() => _IsProductPopularViewState();
}

class _IsProductPopularViewState extends State<IsProductPopularView> {
  @override
  void initState() {
    // IsProductPopularView.isSelected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(highlightColor: Colors.transparent, splashFactory: NoSplash.splashFactory),
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text('المنتج رائج', style: Theme.of(context).textTheme.bodyMedium),
        value: IsProductPopularView.isSelected,
        onChanged: (v) {
          setState(() {
            IsProductPopularView.isSelected = v!;
          });
        },
      ),
    );
  }
}
