import 'package:flutter/material.dart';

import '../utils/colors.dart';

typedef WidgetBuilder = Widget Function(BuildContext context, int index);

class DefaultHorizontalListView extends StatefulWidget {
  final Future Function(int page)? refresh;
  final Future<void> Function()? onRefreshCall;
  final WidgetBuilder itemBuilder;
  final int? length;
  final bool hasMore;

  const DefaultHorizontalListView({
    super.key,
    required this.refresh,
    required this.itemBuilder,
    required this.length,
    required this.onRefreshCall,
    required this.hasMore,
  });

  @override
  State<DefaultHorizontalListView> createState() => _DefaultHorizontalListViewState();
}

class _DefaultHorizontalListViewState extends State<DefaultHorizontalListView> {
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
          _page += 20;
          await widget.refresh!(_page);
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
      child: ListView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
        itemCount: widget.length! + 1,
      ),
    );
  }
}
