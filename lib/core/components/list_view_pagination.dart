import 'package:flutter/cupertino.dart';

class ListViewPagination extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final void Function() addEvent;
  final Future<void> Function()? onRefresh;
  final bool shrinkWrap;

  const ListViewPagination({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.addEvent,
    this.onRefresh,
    this.shrinkWrap = false,
    this.separatorBuilder,
  });

  @override
  State<ListViewPagination> createState() => _ListViewPaginationState();
}

class _ListViewPaginationState extends State<ListViewPagination> {
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
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return widget.itemBuilder(context, index);
          }, childCount: widget.itemCount),
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
