import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gss_manager_app/config/api.dart';
import 'package:gss_manager_app/core/constants/shared_prefs_keys.dart';
import 'package:gss_manager_app/features/inventory/data/models/stock_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'stock_branch_event.dart';
part 'stock_branch_state.dart';

class StockBranchBloc extends Bloc<StockBranchEvent, StockBranchState> {
  StockBranchBloc() : super(StockBranchInitial()) {
    on<LoadStockBranchData>(_onLoadStockBranchData);
    on<LoadNextPage>(_onLoadNextPage);
  }

  Future<void> _onLoadStockBranchData(
      LoadStockBranchData event, Emitter<StockBranchState> emit) async {
    emit(StockBranchLoading());
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('${GisaApiConfig.stock}/${event.branchId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        final stocks = data.map((json) => StockModel.fromJson(json)).toList();
        final nextPageUrl = json.decode(response.body)['links']?['next'];
        emit(StockBranchLoaded(stocks: stocks, nextPageUrl: nextPageUrl));
      } else {
        emit(StockBranchError('Failed to load stock data'));
      }
    } catch (e) {
      emit(StockBranchError(e.toString()));
    }
  }

  Future<void> _onLoadNextPage(
      LoadNextPage event, Emitter<StockBranchState> emit) async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(event.nextPageUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        final newStocks =
            data.map((json) => StockModel.fromJson(json)).toList();
        final nextPageUrl = json.decode(response.body)['links']['next'];
        if (state is StockBranchLoaded) {
          final currentState = state as StockBranchLoaded;
          final allStocks = List<StockModel>.from(currentState.stocks)
            ..addAll(newStocks);
          emit(StockBranchLoaded(stocks: allStocks, nextPageUrl: nextPageUrl));
        }
      } else {
        emit(StockBranchError('Failed to load data'));
      }
    } catch (e) {
      emit(StockBranchError(e.toString()));
    }
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefsKeys.token) ?? '';
  }
}
