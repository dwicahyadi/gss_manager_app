import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gss_manager_app/core/models/branch_modal.dart';
import 'package:gss_manager_app/features/sales/data/models/salesman_model.dart';
import 'package:gss_manager_app/features/sales/persentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:gss_manager_app/features/sales/persentation/bloc/dashboard/dashboard_event.dart';
import 'package:gss_manager_app/features/sales/persentation/bloc/dashboard/dashboard_state.dart';
import 'package:gss_manager_app/features/sales/persentation/bloc/top_salesman/top_salesman_bloc.dart';
import 'package:gss_manager_app/features/sales/persentation/screens/orders_screen.dart';
import 'package:gss_manager_app/features/sales/persentation/screens/product_screen.dart';
import 'package:gss_manager_app/features/sales/persentation/screens/salesman_detail_screen.dart';
import 'package:gss_manager_app/features/sales/persentation/screens/salesman_screen.dart';
import 'package:gss_manager_app/shared/persentation/widgets/stat_card.dart';
import 'package:gss_manager_app/shared/persentation/widgets/unauth_screen.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  final BranchModel branch;
  final formatter = NumberFormat('#,###');

  Future<void> _refreshData(BuildContext context) async {
    // Implement your data refresh logic here
    context.read<DashboardBloc>().add(LoadDashboardData(branch.id));
    context.read<TopSalesmanBloc>().add(LoadTopSalesman(branch.id, 3));
  }

  DashboardScreen({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              DashboardBloc()..add(LoadDashboardData(branch.id)),
        ),
        BlocProvider(
          create: (context) =>
              TopSalesmanBloc()..add(LoadTopSalesman(branch.id, 3)),
        ),
      ],
      child: Builder(builder: (context) {
        return RefreshIndicator(
          onRefresh: () => _refreshData(context),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    if (state is DashboardLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DashboardLoaded) {
                      return _buildDashboardContent(context, state, branch);
                    } else if (state is DashboardError) {
                      return Text('Error: ${state.message}');
                    } else if (state is DashboardUnauthorized) {
                      return const UnauthorizedScreen();
                    } else {
                      return Container();
                    }
                  },
                ),
                const SizedBox(height: 24),
                Text('Best Salesman',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                BlocBuilder<TopSalesmanBloc, TopSalesmanState>(
                  builder: (context, state) {
                    if (state is TopSalesmanLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TopSalesmanLoaded) {
                      return _buildTopSalesmanList(context, state.salesmen);
                    } else if (state is TopSalesmanError) {
                      return Text('Error: ${state.message}');
                    } else if (state is TopSalesmanEmpty) {
                      return const Center(child: Text('No salesmen available'));
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDashboardContent(
      BuildContext context, DashboardLoaded state, BranchModel branch) {
    return Column(
      children: [
        _buildStatRow(
          context,
          [
            _buildStatCard(
              context,
              title: 'Total Sales',
              value: 'Rp ${formatter.format(state.totalSales)}',
              color: Colors.pink.shade300,
            ),
            _buildStatCard(
              context,
              title: 'Total Orders',
              value: formatter.format(state.totalOrders),
              color: Colors.lightBlue.shade300,
              onTap: () => _navigateToOrdersScreen(context, branch),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildStatRow(
          context,
          [
            _buildStatCard(
              context,
              title: 'Active Customers',
              value: formatter.format(state.totalActiveCustomers),
              color: Colors.lightGreen.shade300,
            ),
            _buildStatCard(
              context,
              title: 'Products Sold',
              value: formatter.format(state.totalProductsSold),
              color: Colors.yellow.shade300,
              onTap: () => _navigateToProductScreen(context, branch),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildStatCard(
          context,
          title: 'Unpaid Order',
          value: 'Rp. ${formatter.format(state.unpaidOrderValue)}',
          color: Colors.orange,
          isCritical: true,
          onTap: () => _navigateToOrdersScreen(
            context,
            branch,
            status: 'UNPAID',
          ),
        ),
        const SizedBox(height: 16),
        _buildStatCard(
          context,
          title: 'Over Due Order',
          value: 'Rp. ${formatter.format(state.overDueOrderValue)}',
          color: Colors.red,
          isCritical: true,
          onTap: () => _navigateToOrdersScreen(
            context,
            branch,
            status: 'OVERDUE',
          ),
        ),
      ],
    );
  }

  Widget _buildTopSalesmanList(
      BuildContext context, List<SalesmanModel> salesmen) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Top Salesman',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SalesmanScreen(branchId: branch.id),
                      ),
                    );
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  )),
            ],
          ),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: salesmen.length,
            itemBuilder: (context, index) {
              final salesman = salesmen[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    salesman.user.avatar ?? '',
                  ),
                ),
                title: Text(
                  salesman.user.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                subtitle: Text(
                  'Rp ${formatter.format(salesman.totalSales)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onTap: () {
                  // navigate to salesman detail screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SalesmanDetailScreen(
                        salesmanId: salesman.user.id,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children.map((child) {
        return SizedBox(
          width: MediaQuery.of(context).size.width / 2 - 24,
          child: child,
        );
      }).toList(),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required Color color,
    VoidCallback? onTap,
    bool isCritical = false,
  }) {
    return StatCard(
      title: title,
      value: value,
      color: color,
      onTap: onTap,
      isCritical: isCritical,
    );
  }

  void _navigateToOrdersScreen(
    BuildContext context,
    BranchModel branch, {
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrdersScreen(
          branch: branch,
          startDate: startDate,
          endDate: endDate,
          status: status,
        ),
      ),
    );
  }

  void _navigateToProductScreen(BuildContext context, BranchModel branch) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductScreen(branch: branch),
      ),
    );
  }
}
