import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gss_manager_app/features/inventory/persentation/bloc/stock_all_branch/stock_all_branch_bloc.dart';
import 'package:gss_manager_app/features/inventory/persentation/bloc/stock_attention/stock_attention_bloc.dart';
import 'package:gss_manager_app/features/inventory/persentation/screens/stock_branch_screen.dart';
import 'package:gss_manager_app/shared/persentation/widgets/stat_card.dart';
import 'package:intl/intl.dart';

class InventoryDashboardScreen extends StatelessWidget {
  const InventoryDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              StockAllBranchBloc()..add(LoadStockAllBranchData()),
        ),
        BlocProvider(
          create: (context) =>
              StockAttentionBloc()..add(LoadStockAttentionData()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inventory Dashboard'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<StockAttentionBloc, StockAttentionState>(
              builder: (context, state) {
                if (state is StockAttentionLoading) {
                  return const Center(
                      child: Text(
                    'Cheking stock attention...',
                  ));
                } else if (state is StockAttentionLoaded) {
                  final attentionData = state.attentionData;
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(.1),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Need Attention',
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        if (attentionData.invalidProductQuantity != null)
                          _buildAttentionCard(
                            context,
                            'Invalid stock: ${formatter.format(attentionData.invalidProductQuantity)} items',
                            'Ditemukan prduk dengan stock kurang dari 0',
                            Colors.red,
                          ),
                        if (attentionData.lowStock != null)
                          _buildAttentionCard(
                            context,
                            'Low stock: ${formatter.format(attentionData.lowStock)} items',
                            'Ditemukan produk dibawah level stock minimum',
                            Colors.orange,
                          ),
                        if (attentionData.invalidProductCost != null)
                          _buildAttentionCard(
                            context,
                            'Invalid harga modal: ${formatter.format(attentionData.invalidProductCost)} items',
                            'Untuk hasil perhitungan lebih akurat mohon periksa kembali harga modal produk',
                            Colors.orange,
                          ),
                      ],
                    ),
                  );
                } else if (state is StockAttentionError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return Container();
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                'Stock Value by Branch',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Expanded(
              child: BlocBuilder<StockAllBranchBloc, StockAllBranchState>(
                builder: (context, state) {
                  if (state is StockAllBranchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is StockAllBranchLoaded) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.branchStocks.length,
                      itemBuilder: (context, index) {
                        final branchStock = state.branchStocks[index];
                        return Column(
                          children: [
                            StatCard(
                              title: branchStock.branch.name,
                              value:
                                  'Rp. ${formatter.format(branchStock.totalStockValue)}',
                              color: Theme.of(context).primaryColor,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StockBranchScreen(
                                            branch: branchStock.branch)));
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    );
                  } else if (state is StockAllBranchError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttentionCard(
      BuildContext context, String title, String message, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.error,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
