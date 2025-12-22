import 'package:flutter/material.dart';

import '../../../../../../core/components/rating_box_widget.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/image_manager.dart';

class ReviewCardView extends StatelessWidget {
  const ReviewCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 1)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.black.withValues(alpha: 0.1),
            child: const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(ImageManager.logo),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'علي منصور',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 12),
                    RatingBoxWidget(rating: '4.4', color: AppColors.black.withValues(alpha: 0.5)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'جربة لذيذة وممتعة! كانت الأطباق لذيذة للغاية وطازجة، وخدمة العملاء كانت ممتازة. أحببت الأجواء الدافئة والمريحة في المطعم أيضًا',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
