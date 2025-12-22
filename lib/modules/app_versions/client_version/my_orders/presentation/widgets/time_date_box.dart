import 'package:flutter/material.dart';

class TimeAndDateBox extends StatelessWidget {
  final IconData iconData;
  final String value;

  const TimeAndDateBox({super.key, required this.iconData, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 1)],
      ),
      child: Row(
        children: [
          Icon(iconData, color: Colors.black.withValues(alpha: 0.5)),
          const SizedBox(width: 5),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.black.withValues(alpha: 0.5)),
            ),
          ),
        ],
      ),
    );
  }
}
