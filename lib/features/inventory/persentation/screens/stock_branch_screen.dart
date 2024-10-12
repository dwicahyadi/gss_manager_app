import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gss_manager_app/core/models/branch_modal.dart';
import 'package:gss_manager_app/features/inventory/persentation/bloc/stock_branch/stock_branch_bloc.dart';

class StockBranchScreen extends StatelessWidget {
  final BranchModel branch;
  const StockBranchScreen({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StockBranchBloc()..add(LoadStockBranchData(branch.id)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Stock for ${branch.name}'),
        ),
        body: BlocBuilder<StockBranchBloc, StockBranchState>(
          builder: (context, state) {
            if (state is StockBranchLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StockBranchLoaded) {
              return ListView.builder(
                itemCount: state.stocks.length + 1,
                itemBuilder: (context, index) {
                  if (index < state.stocks.length) {
                    final stock = state.stocks[index];
                    return ListTile(
                      leading: CachedNetworkImage(
                        width: 50,
                        imageUrl: stock.product.image ?? 'default_image_url',
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      title: Text(stock.product.name),
                      subtitle: Text('Quantity: ${stock.quantity}'),
                      trailing: Text('Total: ${stock.total}'),
                    );
                  } else {
                    return state.nextPageUrl != null
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                context
                                    .read<StockBranchBloc>()
                                    .add(LoadNextPage(state.nextPageUrl!));
                              },
                              child: Text('Load More'),
                            ),
                          )
                        : Container();
                  }
                },
              );
            } else if (state is StockBranchError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
