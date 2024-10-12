import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gss_manager_app/config/api.dart';
import 'package:gss_manager_app/core/constants/shared_prefs_keys.dart';
import 'package:gss_manager_app/features/sales/data/models/product_sold_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

part 'product_sold_event.dart';
part 'product_sold_state.dart';

class ProductSoldBloc extends Bloc<ProductSoldEvent, ProductSoldState> {
  ProductSoldBloc() : super(ProductSoldInitial()) {
    on<LoadProductSoldData>(_onLoadProductSoldData);
    on<LoadNextPage>(_onLoadNextPage);
  }

  Future<void> _onLoadProductSoldData(
      LoadProductSoldData event, Emitter<ProductSoldState> emit) async {
    emit(ProductSoldLoading());
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('${GisaApiConfig.productSold}?branch_id=${event.branchId}'),
        headers: {
          'Content-Type': 'applaication/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Use the dynamic token
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<ProductSoldModel> products = (data['data'] as List)
            .map((product) => ProductSoldModel.fromJson(product))
            .toList();
        final nextPageUrl = data['links']['next'];
        emit(ProductSoldLoaded(products, nextPageUrl: nextPageUrl));
      } else {
        emit(const ProductSoldError('Failed to load data'));
      }
    } catch (e) {
      emit(ProductSoldError(e.toString()));
    }
  }

  Future<void> _onLoadNextPage(
      LoadNextPage event, Emitter<ProductSoldState> emit) async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(event.nextPageUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newProducts = (data['data'] as List)
            .map((product) => ProductSoldModel.fromJson(product))
            .toList();
        final nextPageUrl = data['links']['next'];
        if (state is ProductSoldLoaded) {
          final currentState = state as ProductSoldLoaded;
          final allProducts = List<ProductSoldModel>.from(currentState.products)
            ..addAll(newProducts);
          emit(ProductSoldLoaded(allProducts, nextPageUrl: nextPageUrl));
        }
      } else {
        emit(const ProductSoldError('Failed to load data'));
      }
    } catch (e) {
      emit(ProductSoldError(e.toString()));
    }
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefsKeys.token) ?? '';
  }
}
