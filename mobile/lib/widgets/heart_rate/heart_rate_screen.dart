import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:pi_mobile/routing/routes.dart";
import "package:pi_mobile/widgets/common/app_navigation_drawer.dart";
import "package:pi_mobile/widgets/heart_rate/heart_rate_data_page.dart";
import "package:pi_mobile/widgets/heart_rate/heart_rate_graph_page.dart";

class HeartRateScreen extends StatefulWidget {
  const HeartRateScreen({super.key});

  @override
  State<HeartRateScreen> createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen>
    with SingleTickerProviderStateMixin {
  static const List<(Tab, Widget)> _tabs = <(Tab, Widget)>[
    (
      Tab(
        icon: Icon(Icons.auto_graph),
      ),
      HeartRateGraphPage(),
    ),
    (
      Tab(
        icon: Icon(Icons.auto_graph),
      ),
      HeartRateDataPage(),
    ),
  ];

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const AppNavigationDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _onEntryAddPressed(context),
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: context.colors.scaffoldBackground,
          title: const Text("Heart rate"), // TODO: I18N
          bottom: TabBar(
            controller: _tabController,
            tabs: _tabs.map((tab) => tab.$1).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: _tabs.map((tab) => tab.$2).toList(),
        ),
      );

  void _onEntryAddPressed(BuildContext context) {
    const AddHeartRateRoute().go(context);
  }
}
