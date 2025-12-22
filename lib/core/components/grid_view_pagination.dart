import 'package:flutter/cupertino.dart';

class GridViewPagination extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final void Function() addEvent;
  final Future<void> Function()? onRefresh;
  final bool shrinkWrap;
  final SliverGridDelegate gridDelegate;

  const GridViewPagination({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.addEvent,
    this.onRefresh,
    this.shrinkWrap = false,
    required this.gridDelegate,
  });

  @override
  State<GridViewPagination> createState() => _GridViewPaginationState();
}

class _GridViewPaginationState extends State<GridViewPagination> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        if (widget.onRefresh != null) CupertinoSliverRefreshControl(onRefresh: widget.onRefresh!),
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverGrid(
            gridDelegate: widget.gridDelegate,
            delegate: SliverChildBuilderDelegate(
              (context, index) => widget.itemBuilder(context, index),
              childCount: widget.itemCount,
            ),
          ),
        ),
      ],
    );
  }

  void _onScroll() {
    if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
      widget.addEvent();
    }
  }
}
