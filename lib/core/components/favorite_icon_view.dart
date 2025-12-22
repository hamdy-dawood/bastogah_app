import 'package:bastoga/core/caching/local_favorite.dart';
import 'package:bastoga/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../modules/app_versions/client_version/home/domain/entities/product.dart';
import '../utils/image_manager.dart';

class FavoriteIconView extends StatefulWidget {
  final Product product;

  const FavoriteIconView({super.key, required this.product});

  @override
  State<FavoriteIconView> createState() => _FavoriteIconViewState();
}

class _FavoriteIconViewState extends State<FavoriteIconView> {
  bool isFavorite = false;

  @override
  void initState() {
    for (var p in favorite) {
      if (p.id == widget.product.id) {
        isFavorite = true;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          toggleProductFavorite(product: widget.product);
          isFavorite = !isFavorite;
        });
      },
      child: Container(
        height: 25,
        width: 25,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: SvgPicture.asset(
          isFavorite ? ImageManager.coloredFavoriteIcon : ImageManager.favoriteIcon,
          color: isFavorite ? AppColors.defaultColor : null,
        ),
      ),
    );
  }
}
