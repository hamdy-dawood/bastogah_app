import 'package:flutter/material.dart';

import '../utils/colors.dart';

typedef WidgetBuilder = Widget Function(BuildContext context, int index);

class DefaultGridView extends StatefulWidget {
  final Future Function(int page)? refresh;
  final Future<void> Function()? onRefreshCall;
  final WidgetBuilder itemBuilder;
  final int? length;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final SliverGridDelegate gridDelegate;
  final bool hasMore;

  const DefaultGridView({
    super.key,
    required this.refresh,
    required this.itemBuilder,
    required this.length,
    this.shrinkWrap = false,
    this.physics,
    required this.gridDelegate,
    required this.onRefreshCall,
    required this.hasMore,
  });

  @override
  State<DefaultGridView> createState() => _DefaultGridViewState();
}

class _DefaultGridViewState extends State<DefaultGridView> {
  final ScrollController _controller = ScrollController();
  int _page = 0;

  @override
  void initState() {
    //Init the scroll controller
    if (widget.refresh != null) {
      _controller.addListener(() async {
        if (_controller.position.pixels.isNegative && _controller.position.pixels <= -10) {
          _page = 0;
        }
        //Check if the controller get the max length
        if (_controller.position.pixels == _controller.position.maxScrollExtent) {
          setState(() {
            _controller.jumpTo(_controller.position.maxScrollExtent);
          });
          _page += 20;
          await widget.refresh!(_page);
          // print('======= $_page');
          // print('======= $_isLoading');
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.defaultColor,
      onRefresh: widget.onRefreshCall!,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        controller: _controller,
        gridDelegate: widget.gridDelegate,
        shrinkWrap: widget.shrinkWrap,
        physics:
            widget.physics ?? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemBuilder: (context, index) {
          if (index < widget.length!) {
            return widget.itemBuilder(context, index);
          } else if (index == widget.length) {
            return widget.hasMore
                ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(child: CircularProgressIndicator(color: AppColors.defaultColor)),
                )
                : const SizedBox();
          }
          return null;
        },
        itemCount: widget.hasMore ? widget.length! + 1 : widget.length,
      ),
    );
  }
}
