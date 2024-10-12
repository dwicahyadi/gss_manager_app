import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gss_manager_app/core/models/branch_modal.dart';
import 'package:gss_manager_app/features/sales/persentation/bloc/product_sold/product_sold_bloc.dart';
import 'package:intl/intl.dart';

class ProductScreen extends StatefulWidget {
  final BranchModel branch;
  const ProductScreen({super.key, required this.branch});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String _searchQuery = '';
  bool _isSearching = false;
  final formatter = NumberFormat('#,###');

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductSoldBloc()..add(LoadProductSoldData(widget.branch.id)),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Product Sold'),
              Text(
                'Branch: ${widget.branch.name}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) _searchQuery = '';
                });
              },
            ),
          ],
          bottom: _isSearching
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                      onChanged: (query) {
                        setState(() {
                          _searchQuery = query;
                        });
                      },
                    ),
                  ),
                )
              : null,
        ),
        body: BlocBuilder<ProductSoldBloc, ProductSoldState>(
          builder: (context, state) {
            if (state is ProductSoldLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductSoldLoaded) {
              final filteredProducts = state.products.where((product) {
                return product.product.name
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()) ||
                    product.product.category!.name
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase());
              }).toList();
              return ListView.builder(
                itemCount: filteredProducts.length + 1,
                itemBuilder: (context, index) {
                  if (index < filteredProducts.length) {
                    final product = filteredProducts[index];
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
                                  product.product.image ?? 'default_image_url',
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            title: Text(
                              product.product.name,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    'Qty: Rp. ${formatter.format(product.quantity)}'),
                                Text(
                                    'Amt: ${formatter.format(product.amount)}'),
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
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    Theme.of(context).primaryColor),
                                foregroundColor:
                                    WidgetStateProperty.all(Colors.white),
                              ),
                              onPressed: () {
                                context
                                    .read<ProductSoldBloc>()
                                    .add(LoadNextPage(state.nextPageUrl!));
                              },
                              child: const Text('Load More'),
                            ),
                          )
                        : Container();
                  }
                },
              );
            } else if (state is ProductSoldError) {
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
