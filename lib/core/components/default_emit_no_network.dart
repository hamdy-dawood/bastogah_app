import 'package:flutter/material.dart';

class EmitNetworkItem extends StatelessWidget {
  const EmitNetworkItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("لا يوجد انترنت", style: Theme.of(context).textTheme.titleLarge));
  }
}
