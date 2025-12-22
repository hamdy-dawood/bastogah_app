import 'package:flutter/material.dart';

class IsProductActiveView extends StatefulWidget {
  static bool isSelected = false;

  const IsProductActiveView({super.key});

  @override
  State<IsProductActiveView> createState() => _IsProductActiveViewState();
}

class _IsProductActiveViewState extends State<IsProductActiveView> {
  @override
  void initState() {
    // IsProductActiveView.isSelected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(highlightColor: Colors.transparent, splashFactory: NoSplash.splashFactory),
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text('المنتج مخفي', style: Theme.of(context).textTheme.bodyMedium),
        value: IsProductActiveView.isSelected,
        onChanged: (v) {
          setState(() {
            IsProductActiveView.isSelected = v!;
          });
        },
      ),
    );
  }
}
