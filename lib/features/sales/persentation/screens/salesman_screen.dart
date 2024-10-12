import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gss_manager_app/features/sales/persentation/bloc/top_salesman/top_salesman_bloc.dart';
import 'package:gss_manager_app/features/sales/persentation/screens/salesman_detail_screen.dart';
import 'package:intl/intl.dart';

class SalesmanScreen extends StatelessWidget {
  final int branchId;

  const SalesmanScreen({super.key, required this.branchId});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Salesmen'),
      ),
      body: BlocProvider(
        create: (context) =>
            TopSalesmanBloc()..add(LoadTopSalesman(branchId, 0)),
        child: BlocBuilder<TopSalesmanBloc, TopSalesmanState>(
          builder: (context, state) {
            if (state is TopSalesmanLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TopSalesmanLoaded) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.salesmen.length,
                itemBuilder: (context, index) {
                  final salesman = state.salesmen[index];
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
                    trailing: Text(
                      'Rp. ${formatter.format(salesman.totalSales)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SalesmanDetailScreen(
                            salesmanId: salesman.user.id);
                      }));
                    },
                  );
                },
              );
            } else if (state is TopSalesmanError) {
              return const Center(child: Text('Failed to load salesmen'));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
