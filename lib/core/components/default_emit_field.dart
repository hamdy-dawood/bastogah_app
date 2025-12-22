import 'package:flutter/material.dart';

class EmitFailedItem extends StatelessWidget {
  const EmitFailedItem({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message, style: Theme.of(context).textTheme.titleLarge));
  }
}
