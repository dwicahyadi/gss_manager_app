part of 'product_sold_bloc.dart';

sealed class ProductSoldState extends Equatable {
  const ProductSoldState();

  @override
  List<Object> get props => [];
}

final class ProductSoldInitial extends ProductSoldState {}

final class ProductSoldLoading extends ProductSoldState {}

final class ProductSoldLoaded extends ProductSoldState {
  final List<ProductSoldModel> products;
  final String? nextPageUrl;

  const ProductSoldLoaded(this.products, {this.nextPageUrl});

  @override
  List<Object> get props => [products, nextPageUrl ?? ''];
}

final class ProductSoldError extends ProductSoldState {
  final String message;

  const ProductSoldError(this.message);

  @override
  List<Object> get props => [message];
}
