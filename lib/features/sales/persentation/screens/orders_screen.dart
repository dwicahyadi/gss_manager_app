import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gss_manager_app/core/models/branch_modal.dart';
import 'package:gss_manager_app/features/sales/data/models/order_model.dart';
import 'package:gss_manager_app/features/sales/persentation/bloc/order_list/order_list_bloc.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  final BranchModel branch;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;
  final int? userId;
  final int? customerId;

  const OrdersScreen({
    super.key,
    required this.branch,
    this.startDate,
    this.endDate,
    this.status,
    this.userId,
    this.customerId,
  });

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderListBloc()
        ..add(LoadOrdersData(
          branchId: widget.branch.id,
          startDate: widget.startDate,
          endDate: widget.endDate,
          status: widget.status,
          userId: widget.userId,
          customerId: widget.customerId,
        )),
      child: Scaffold(
        appBar: AppBar(
          title: _isSearching
              ? TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search customer name...',
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
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Orders List'),
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
                  if (!_isSearching) {
                    _searchQuery = '';
                  }
                });
              },
            ),
          ],
        ),
        body: BlocBuilder<OrderListBloc, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrdersLoaded) {
              final filteredOrders = state.orders.where((order) {
                return order.customer.name
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());
              }).toList();

              return ListView.builder(
                itemCount: filteredOrders.length + 1,
                itemBuilder: (context, index) {
                  if (index < filteredOrders.length) {
                    final order = filteredOrders[index];
                    return OrderWidget(order: order);
                  } else {
                    return state.nextPageUrl != null
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColor),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                              onPressed: () {
                                context
                                    .read<OrderListBloc>()
                                    .add(LoadNextPage(state.nextPageUrl!));
                              },
                              child: const Text('Load More'),
                            ),
                          )
                        : Container();
                  }
                },
              );
            } else if (state is OrdersError) {
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

class OrderWidget extends StatelessWidget {
  final OrderModel order;

  const OrderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final formatter = NumberFormat('#,###');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black : Colors.grey.shade300,
              blurRadius: 4.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      '#${order.orderCode}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: order.status == 'UNPAID'
                            ? Colors.orange
                            : order.status == 'PAID'
                                ? Colors.green
                                : Colors.red,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        order.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Rp. ${formatter.format(order.totalAmount)}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              order.customer.name,
              style: const TextStyle(
                fontSize: 16, // Increased font size for readability
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Salesman: ${order.user.name}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Branch: ${order.branch.name}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Order Date: ${order.orderDate}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Due Date: ${order.dueDate}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50, // Background color for emphasis
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Paid Amount: \nRp. ${formatter.format(order.paidAmount ?? 0)}',
                    style: const TextStyle(
                      color:
                          Colors.lightGreen, // Highlight paid amount in green
                    ),
                  ),
                  Text(
                    'Remaining Amount: \nRp. ${formatter.format(order.remainingAmount)}',
                    style: const TextStyle(
                      color: Colors.red, // Highlight remaining amount in red
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
