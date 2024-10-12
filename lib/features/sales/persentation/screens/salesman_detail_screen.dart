import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gss_manager_app/features/sales/persentation/bloc/top_salesman/top_salesman_bloc.dart';
import 'package:gss_manager_app/shared/persentation/widgets/stat_card.dart';
import 'package:intl/intl.dart';

class SalesmanDetailScreen extends StatelessWidget {
  final int salesmanId;

  const SalesmanDetailScreen({super.key, required this.salesmanId});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Salesman Detail'),
      ),
      body: BlocProvider(
        create: (context) =>
            TopSalesmanBloc()..add(LoadSalesmanDetail(salesmanId)),
        child: BlocBuilder<TopSalesmanBloc, TopSalesmanState>(
          builder: (context, state) {
            if (state is TopSalesmanLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SalesmanDetailLoaded) {
              final salesman = state.salesman;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: salesman.user.avatar != null &&
                                  salesman.user.avatar!.isNotEmpty
                              ? NetworkImage(salesman.user.avatar!)
                              : const AssetImage(
                                      'assets/images/default_avatar.png')
                                  as ImageProvider,
                          radius: 40,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              salesman.user.name,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              salesman.user.role,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text('Statistic this month:'),
                    const SizedBox(height: 16),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          StatCard(
                              title: 'Total Sales',
                              value: formatter.format(salesman.totalSales),
                              color: Colors.pink),
                          StatCard(
                              title: 'Total Order',
                              value: formatter.format(salesman.totalOrders),
                              color: Colors.lightBlue),
                          StatCard(
                              title: 'Active Customer',
                              value: formatter
                                  .format(salesman.countActiveCustomer),
                              color: Colors.lightGreen),
                          StatCard(
                              title: 'Unpaid Amount',
                              value: formatter.format(salesman.totalUnpaid),
                              color: Colors.yellow),
                          StatCard(
                            title: 'Overdue Amount',
                            value: formatter.format(salesman.totalOverdue),
                            color: Colors.red,
                            isCritical: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is TopSalesmanError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
