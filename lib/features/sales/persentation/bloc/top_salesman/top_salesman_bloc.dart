import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gss_manager_app/config/api.dart';
import 'package:gss_manager_app/core/constants/shared_prefs_keys.dart';
import 'package:gss_manager_app/features/sales/data/models/salesman_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

part 'top_salesman_event.dart';
part 'top_salesman_state.dart';

class TopSalesmanBloc extends Bloc<TopSalesmanEvent, TopSalesmanState> {
  TopSalesmanBloc() : super(TopSalesmanInitial()) {
    on<LoadTopSalesman>(_onLoadTopSalesman);
    on<LoadSalesmanDetail>(_onLoadSalesmanDetail);
  }

  Future<void> _onLoadTopSalesman(
      LoadTopSalesman event, Emitter<TopSalesmanState> emit) async {
    emit(TopSalesmanLoading());
    try {
      final token = await _getToken();
      final startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
      final endDate =
          DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
      final limit = event.limit ?? 0;

      final response = await http.get(
        Uri.parse(
            '${GisaApiConfig.topSalesman}?branch_id=${event.branchId}&start_date=$startDate&end_date=$endDate&limit=$limit'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.contains('text/html') == true) {
          emit(
              const TopSalesmanError('Received HTML response instead of JSON'));
          return;
        }
        print('OKOK ini respons top salesaman ${response.body}');

        final data = json.decode(response.body);
        final List<SalesmanModel> salesmen =
            (data['data'] as List).map((salesman) {
          return SalesmanModel.fromJson(salesman);
        }).toList();

        emit(TopSalesmanLoaded(salesmen));
      } else {
        emit(const TopSalesmanError('Failed to load top salesmen'));
      }
    } catch (e) {
      emit(TopSalesmanError(e.toString()));
    }
  }

  Future<void> _onLoadSalesmanDetail(
      LoadSalesmanDetail event, Emitter<TopSalesmanState> emit) async {
    emit(TopSalesmanLoading());
    try {
      final token = await _getToken();

      final response = await http.get(
        Uri.parse('${GisaApiConfig.salesman}?user_id=${event.salesmanId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.contains('text/html') == true) {
          emit(
              const TopSalesmanError('Received HTML response instead of JSON'));
          return;
        }

        final data = json.decode(response.body);
        final salesman = SalesmanModel.fromJson(data['data']);
        emit(SalesmanDetailLoaded(salesman));
      } else {
        emit(const TopSalesmanError('Failed to load salesman detail'));
      }
    } catch (e) {
      emit(TopSalesmanError(e.toString()));
    }
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefsKeys.token) ?? '';
  }
}
