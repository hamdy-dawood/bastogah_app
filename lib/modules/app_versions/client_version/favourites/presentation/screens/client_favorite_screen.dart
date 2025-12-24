import 'package:bastoga/core/caching/local_favorite.dart';
import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/components/components.dart';
import '../../../home/presentation/widgets/default_client_app_bar.dart';
import '../widgets/favorite_product_card_view.dart';

class ClientFavoriteScreen extends StatefulWidget {
  const ClientFavoriteScreen({super.key});

  @override
  State<ClientFavoriteScreen> createState() => _ClientFavoriteScreenState();
}

class _ClientFavoriteScreenState extends State<ClientFavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leadingWidth: 70,
      //   leading: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //     child: Image.asset(
      //       ImageManager.logoIcon,
      //     ),
      //   ),
      //   title: const Text('المفضلة'),
      //   // actions: [
      //   //   IconButton(
      //   //     pressed: () {},
      //   //     icon: SvgPicture.asset(
      //   //       ImageManager.shoppingCartIcon,
      //   //     ),
      //   //   ),
      //   // ],
      // ),
      appBar: defaultClientAppBar(context: context, leading: false),
      bottomNavigationBar: const ClientDefaultBottomNav(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            height: context.screenHeight,
            // child: Image.asset(ImageManager.zaitonaBgArt,fit: BoxFit.cover,),
          ),
          favorite.isNotEmpty
              ? DefaultListView(
                refresh: (page) async {},
                itemBuilder:
                    (context, index) => FavoriteProductCardView(
                      product: favorite[index],
                      onFavTap: () {
                        setState(() {
                          toggleProductFavorite(product: favorite[index]);
                        });
                      },
                    ),
                length: favorite.length,
                hasMore: false,
                onRefreshCall: () async {
                  setState(() {});
                },
              )
              : NoData(
                refresh: () async {
                  setState(() {});
                },
              ),
        ],
      ),
    );
  }
}
