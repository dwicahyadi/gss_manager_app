import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gss_manager_app/config/api.dart';
import 'package:gss_manager_app/core/constants/shared_prefs_keys.dart';
import 'package:gss_manager_app/features/inventory/data/models/attention_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'stock_attention_event.dart';
part 'stock_attention_state.dart';

class StockAttentionBloc
    extends Bloc<StockAttentionEvent, StockAttentionState> {
  StockAttentionBloc() : super(StockAttentionInitial()) {
    on<LoadStockAttentionData>(_onLoadStockAttentionData);
  }

  Future<void> _onLoadStockAttentionData(
      LoadStockAttentionData event, Emitter<StockAttentionState> emit) async {
    emit(StockAttentionLoading());
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(GisaApiConfig.stockAttention),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        final attentionData = AttentionModel.fromJson(data);
        emit(StockAttentionLoaded(attentionData));
      } else {
        emit(StockAttentionError('Failed to load attention data'));
      }
    } catch (e) {
      emit(StockAttentionError(e.toString()));
    }
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefsKeys.token) ?? '';
  }
}
