import 'package:flutter/material.dart';

class IsProductNewView extends StatefulWidget {
  static bool isSelected = false;

  const IsProductNewView({super.key});

  @override
  State<IsProductNewView> createState() => _IsProductNewViewState();
}

class _IsProductNewViewState extends State<IsProductNewView> {
  @override
  void initState() {
    // IsProductNewView.isSelected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(highlightColor: Colors.transparent, splashFactory: NoSplash.splashFactory),
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text('المنتج جديد', style: Theme.of(context).textTheme.bodyMedium),
        value: IsProductNewView.isSelected,
        onChanged: (v) {
          setState(() {
            IsProductNewView.isSelected = v!;
          });
        },
      ),
    );
  }
}
