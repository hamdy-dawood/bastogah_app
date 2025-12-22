import 'package:flutter/material.dart';

class RatingBoxWidget extends StatelessWidget {
  final Color color;
  final String rating;

  const RatingBoxWidget({super.key, required this.color, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 1)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Icon(Icons.star_border, color: color, size: 18),
          ),
          const SizedBox(width: 5),
          Text(rating, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color)),
        ],
      ),
    );
  }
}
