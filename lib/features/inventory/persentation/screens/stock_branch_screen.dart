import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gss_manager_app/core/models/branch_modal.dart';
import 'package:gss_manager_app/features/inventory/persentation/bloc/stock_branch/stock_branch_bloc.dart';
import 'package:intl/intl.dart';

class StockBranchScreen extends StatefulWidget {
  final BranchModel branch;
  const StockBranchScreen({super.key, required this.branch});

  @override
  _StockBranchScreenState createState() => _StockBranchScreenState();
}

class _StockBranchScreenState extends State<StockBranchScreen> {
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    return BlocProvider(
      create: (context) =>
          StockBranchBloc()..add(LoadStockBranchData(widget.branch.id)),
      child: Scaffold(
        appBar: AppBar(
          title: _isSearching
              ? TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search by product ...',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                )
              : Text('Stock for ${widget.branch.name}'),
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.clear : Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchQuery = '';
                  }
                });
              },
            ),
          ],
        ),
        body: BlocBuilder<StockBranchBloc, StockBranchState>(
          builder: (context, state) {
            if (state is StockBranchLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StockBranchLoaded) {
              final filteredStocks = state.stocks.where((stock) {
                return stock.product.name
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());
              }).toList();

              return ListView.builder(
                itemCount: filteredStocks.length + 1,
                itemBuilder: (context, index) {
                  if (index < filteredStocks.length) {
                    final stock = filteredStocks[index];
                    return Column(
                      children: [
                        Container(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.white,
                          child: ListTile(
                            leading: CachedNetworkImage(
                              width: 50,
                              imageUrl:
                                  stock.product.image ?? 'default_image_url',
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            title: Text(
                              stock.product.name,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    'Qty: ${formatter.format(stock.quantity)}'),
                                Text(
                                    'Amt: Rp. ${formatter.format(stock.total)}'),
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                      ],
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
                              child: const Text('Load More'),
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
