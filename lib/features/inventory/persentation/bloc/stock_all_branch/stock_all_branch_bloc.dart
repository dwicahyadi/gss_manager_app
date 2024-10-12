import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gss_manager_app/config/api.dart';
import 'package:gss_manager_app/core/constants/shared_prefs_keys.dart';
import 'package:gss_manager_app/features/inventory/data/models/branch_stock_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'stock_all_branch_event.dart';
part 'stock_all_branch_state.dart';

class StockAllBranchBloc
    extends Bloc<StockAllBranchEvent, StockAllBranchState> {
  StockAllBranchBloc() : super(StockAllBranchInitial()) {
    on<LoadStockAllBranchData>(_onLoadStockAllBranchData);
  }

  Future<void> _onLoadStockAllBranchData(
      LoadStockAllBranchData event, Emitter<StockAllBranchState> emit) async {
    emit(StockAllBranchLoading());
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(GisaApiConfig.stock),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        final branchStocks =
            data.map((json) => BranchStockModel.fromJson(json)).toList();
        emit(StockAllBranchLoaded(branchStocks));
      } else {
        emit(StockAllBranchError('Failed to load stock data'));
      }
    } catch (e) {
      emit(StockAllBranchError(e.toString()));
    }
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefsKeys.token) ?? '';
  }
}
