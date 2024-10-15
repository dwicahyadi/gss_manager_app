import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gss_manager_app/features/sales/persentation/screens/dashboard_screen.dart';
import 'package:gss_manager_app/shared/persentation/bloc/branches_tabs_bloc.dart';
import 'package:gss_manager_app/shared/persentation/bloc/branches_tabs_event.dart';
import 'package:gss_manager_app/shared/persentation/bloc/branches_tabs_state.dart';
import 'package:gss_manager_app/shared/persentation/widgets/braches_tab_bar.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => BranchesBloc()..add(LoadBranches()),
      child: BlocBuilder<BranchesBloc, BranchesState>(
        builder: (context, state) {
          if (state is BranchesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BranchesLoaded) {
            return DefaultTabController(
              length: state.branches.length,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Sales Dashboard'),
                  bottom: BranchesTabBar(branches: state.branches),
                ),
                body: TabBarView(
                  children: state.branches.map((branch) {
                    return DashboardScreen(branch: branch);
                  }).toList(),
                ),
              ),
            );
          } else if (state is BranchesError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Sales'),
              ),
              body: Center(child: Text(state.message)),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Sales'),
              ),
              body: const Center(child: Text('No branches available')),
            );
          }
        },
      ),
    );
  }
}
