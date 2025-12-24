import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/core/networking/endpoints.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../modules/app_versions/client_version/home/domain/entities/merchant_details_object.dart';
import '../../modules/app_versions/client_version/home/domain/entities/product_details_object.dart';
import '../../modules/app_versions/client_version/home/domain/entities/slider.dart';
import '../../modules/app_versions/client_version/home/domain/entities/sub_category_object.dart';
import '../routing/routes.dart';
import '../utils/colors.dart';

class SliderImages extends StatefulWidget {
  final List<String> sliderImages;
  final List<Sliders>? sliders;

  // final bool showFraction;
  final bool largeHeight;

  const SliderImages({
    super.key,
    required this.sliderImages,
    // required this.showFraction,
    this.sliders,
    this.largeHeight = false,
  });

  @override
  State<SliderImages> createState() => _SliderImagesState();
}

class _SliderImagesState extends State<SliderImages> {
  late CarouselSliderController sliderController;
  int activeIndex = 0;
  bool autoPlay = true;

  final List<YoutubePlayerController?> _videoControllers = [];

  @override
  void initState() {
    sliderController = CarouselSliderController();
    _initializeVideoControllers();
    super.initState();
  }

  @override
  void dispose() {
    for (var i = 0; i < _videoControllers.length; i++) {
      final controller = _videoControllers[i];
      if (controller != null) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // const SizedBox(height: 10),
          // buildCarouselSlider(),
          CarouselSlider(
            carouselController: sliderController,
            items:
                widget.sliderImages
                    .asMap()
                    .map((index, e) => buildCarouselItem(e, index))
                    .values
                    .toList(),
            options: CarouselOptions(
              onPageChanged: (index, reason) {
                setState(() {
                  activeIndex = index;
                });
              },
              autoPlay: shouldAutoPlay(),
              // autoPlay: autoPlay,
              enlargeCenterPage: widget.sliderImages.length > 1,
              disableCenter: true,
              viewportFraction: widget.sliderImages.length > 1 ? 0.8 : 1,
              aspectRatio: widget.largeHeight ? 1.4 : 2.5,
            ),
          ),
          const SizedBox(height: 8),
          buildSmoothIndicator(),
        ],
      ),
    );
  }

  // Widget buildCarouselSlider() {
  //   return CarouselSlider(
  //     carouselController: sliderController,
  //     items: widget.sliderImages.asMap().map((index, e) => buildCarouselItem(e, index)).values.toList(),
  //     options: CarouselOptions(
  //       onPageChanged: (index, reason) {
  //         setState(() {
  //           activeIndex = index;
  //         });
  //       },
  //       // autoPlay: shouldAutoPlay(),
  //       autoPlay: autoPlay,
  //       enlargeCenterPage: widget.sliderImages.length > 1,
  //       disableCenter: true,
  //       viewportFraction: widget.sliderImages.length > 1 ? 0.8 : 0.95,
  //       aspectRatio: widget.largeHeight ? 1.4 : 2.5,
  //     ),
  //   );
  // }

  MapEntry<String, Widget> buildCarouselItem(String e, int index) {
    final controller = _videoControllers[index];
    final isVideo = e.startsWith("fromVideo") && controller != null;

    if (!isVideo && activeIndex == index) {
      autoPlay = true;
    }

    return MapEntry(
      e,
      GestureDetector(
        onTap: () {
          // Add navigation or custom onTap behavior if needed
          if ( /*!isVideo && */ widget.sliders != null) {
            if (widget.sliders![index].product != null) {
              context.pushNamed(
                Routes.productDetailsScreen,
                arguments: ProductDetailsObject(
                  product: widget.sliders![index].product!,
                  isMerchant: false,
                  merchantBlocContext: null,
                ),
              );
            } else if (widget.sliders![index].merchant != null) {
              context.pushNamed(
                Routes.merchantDetailsScreen,
                arguments: MerchantDetailsObject(
                  merchant: widget.sliders![index].merchant!,
                  // blocContext: context,
                ),
              );
              // context.pushNamed(
              //   Routes.categoryDetailsScreen,
              //   pathParameters: {'categoryId': widget.slider.categoryId!},
              // );
            } else if (widget.sliders![index].merchantCategory != null) {
              context.pushNamed(
                Routes.subCategoryListScreen,
                arguments: SubCategoryObject(
                  categoryName: widget.sliders![index].merchantCategory!.name,
                  categoryId: widget.sliders![index].merchantCategory!.id,
                  coverImage: widget.sliders![index].merchantCategory!.coverImage,
                  // blocContext: context,
                ),
              );
            } else if (widget.sliders![index].isDiscount) {
              context.pushNamed(Routes.discountMerchantsScreen);
            }
          }
        },
        child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child:
              isVideo /*&& activeIndex == index*/
                  ? YoutubePlayer(
                    controller: controller,
                    showVideoProgressIndicator: false,
                    progressIndicatorColor: Colors.transparent,
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.transparent,
                      handleColor: Colors.transparent,
                    ),
                    onReady: () {
                      print("== READY ==");
                    },
                    onEnded: (metaData) {
                      print("== ENDED ${metaData.duration.inMilliseconds} ==");
                      setState(() => autoPlay = true);
                      final nextIndex = (index + 1) % widget.sliderImages.length;
                      activeIndex = nextIndex;
                      sliderController.animateToPage(nextIndex);
                    },
                  )
                  : buildImageWidget(e),
        ),
      ),
    );
  }

  Widget buildImageWidget(String e) {
    return e.contains(ApiConstants.baseUrl)
        ? CachedNetworkImage(
          imageUrl: e,
          width: context.screenWidth,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          errorWidget: (context, error, stackTrace) => const SizedBox(),
        )
        : Image.asset(
          e,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const SizedBox(),
        );
  }

  void _initializeVideoControllers() {
    for (var slider in widget.sliderImages) {
      if (slider.startsWith("fromVideo")) {
        final url = slider.replaceFirst("fromVideo", "");
        final videoId = YoutubePlayer.convertUrlToId(url);

        if (videoId == null) {
          _videoControllers.add(null);
          continue;
        }

        final controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            enableCaption: false,
            mute: true,
            controlsVisibleAtStart: false,
            disableDragSeek: true,
            hideControls: true,
            hideThumbnail: true,
            forceHD: false,
            loop: true, // Loop the video
          ),
        );

        bool hasStartedPlaying = false;

        controller.addListener(() {
          controller.mute();

          final isActive = activeIndex == _videoControllers.indexOf(controller);

          if (isActive && !hasStartedPlaying) {
            hasStartedPlaying = true;

            controller.seekTo(Duration.zero);
            controller.play();
          } else if (!isActive) {
            hasStartedPlaying = false; // reset for next time it's active
          }

          setState(() => autoPlay = false);
        });
        _videoControllers.add(controller);
      } else {
        _videoControllers.add(null); // Placeholder for non-video items
      }
    }
  }

  bool shouldAutoPlay() {
    return autoPlay && widget.sliderImages.length > 1;
  }

  Widget buildSmoothIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: widget.sliderImages.length,
      effect: WormEffect(
        activeDotColor: AppColors.defaultColor,
        dotColor: AppColors.black.withValues(alpha: 0.2),
        dotHeight: 8,
        dotWidth: 8,
        type: WormType.thin,
      ),
    );
  }
}
