import 'package:bastoga/core/components/default_emit_loading.dart';
import 'package:bastoga/core/helpers/context_extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/components/components.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../home/presentation/widgets/default_client_app_bar.dart';
import '../cubit/client_orders_cubit.dart';
import '../widgets/order_widget.dart';

class ClientOrdersScreen extends StatefulWidget {
  const ClientOrdersScreen({super.key});

  @override
  State<ClientOrdersScreen> createState() => _ClientOrdersScreenState();
}

class _ClientOrdersScreenState extends State<ClientOrdersScreen> {
  List<String> tabs = ['الكل', 'انتظار', 'بدون سائق', 'قيد التنفيذ', 'مكتمل', 'ملغي'];

  int tabIndex = 0;

  @override
  void initState() {
    context.read<ClientOrdersCubit>().getOrders(page: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultClientAppBar(leading: false, context: context),
      bottomNavigationBar: const ClientDefaultBottomNav(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(height: context.screenHeight),
          DefaultTabController(
            length: tabs.length,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 12, right: 16, left: 16, top: 12),
                  decoration: BoxDecoration(
                    color: AppColors.greyColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 40,
                  child: TabBar(
                    isScrollable: true,
                    indicator: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelPadding: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    unselectedLabelColor: AppColors.black.withValues(alpha: 0.6),
                    unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium,
                    labelColor: Colors.white,
                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                    overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                    onTap: (index) {
                      tabIndex = index;
                      // print('TAB INDEX ======= $tabIndex');
                      context.read<ClientOrdersCubit>().getOrders(
                        page: 0,
                        status: tabIndex == 0 ? null : tabIndex - 1,
                      );
                    },
                    tabs:
                        tabs
                            .map(
                              (e) => Tab(
                                child: Container(
                                  height: double.infinity,
                                  margin: const EdgeInsets.symmetric(horizontal: 0),
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  decoration: BoxDecoration(
                                    // color: AppColors.greyColor.withValues(alpha:0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(e),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
                BlocBuilder<ClientOrdersCubit, ClientOrdersStates>(
                  builder: (context, state) {
                    if (state is LoadingState) {
                      return const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 12, left: 16, right: 16),
                          child: EmitLoadingListView(
                            height: 100,
                            width: double.infinity,
                            radius: 5,
                            count: 10,
                          ),
                        ),
                      );
                    }
                    if (context.read<ClientOrdersCubit>().orders != null &&
                        context.read<ClientOrdersCubit>().orders!.isNotEmpty) {
                      return Expanded(
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children:
                              tabs
                                  .map(
                                    (e) => DefaultListView(
                                      refresh: (page) async {},
                                      itemBuilder:
                                          (context, index) => OrderWidget(
                                            order: context.read<ClientOrdersCubit>().orders![index],
                                          ),
                                      length: context.read<ClientOrdersCubit>().orders!.length,
                                      hasMore: false,
                                      onRefreshCall: () async {},
                                    ),
                                  )
                                  .toList(),
                        ),
                      );
                    } else {
                      return NoData(
                        refresh:
                            () => context.read<ClientOrdersCubit>().getOrders(
                              page: 0,
                              status: tabIndex == 0 ? null : tabIndex - 1,
                            ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
