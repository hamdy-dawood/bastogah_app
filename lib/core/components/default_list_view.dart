import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/colors.dart';
import 'default_emit_loading.dart';

typedef WidgetBuilder = Widget Function(BuildContext context, int index);

class DefaultListView extends StatefulWidget {
  final Future Function(int page)? refresh;
  final Future<void> Function() onRefreshCall;
  final WidgetBuilder itemBuilder;
  final int? length;
  final bool hasMore;
  final bool? noPadding;

  const DefaultListView({
    super.key,
    required this.refresh,
    required this.itemBuilder,
    required this.length,
    required this.hasMore,
    this.noPadding,
    required this.onRefreshCall,
  });

  @override
  State<DefaultListView> createState() => _DefaultListViewState();
}

class _DefaultListViewState extends State<DefaultListView> {
  final ScrollController _controller = ScrollController();
  int _page = 0;
  bool _isLoading = false;

  @override
  void initState() {
    if (widget.refresh != null) {
      _controller.addListener(() async {
        if (_controller.position.pixels.isNegative && _controller.position.pixels <= -10) {
          _page = 0;
        }

        if (_controller.position.pixels == _controller.position.maxScrollExtent && !_isLoading) {
          setState(() {
            _isLoading = true;
          });
          _page += 20;
          await widget.refresh!(_page);
          setState(() {
            _isLoading = false;
          });
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
      onRefresh: widget.onRefreshCall,
      child: ListView.builder(
        padding: widget.noPadding != null ? EdgeInsets.zero : const EdgeInsets.all(16),
        controller: _controller,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemBuilder: (context, index) {
          if (index < widget.length!) {
            return widget.itemBuilder(context, index);
          } else if (index == widget.length!) {
            if (_isLoading) {
              return const DefaultSmallCircleIndicator();
            } else {
              return const SizedBox();
            }
          }
          return null;
        },
        itemCount: widget.length! + 1,
      ),
    );
  }
}
