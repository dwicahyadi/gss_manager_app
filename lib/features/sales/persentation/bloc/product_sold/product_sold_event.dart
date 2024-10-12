part of 'product_sold_bloc.dart';

sealed class ProductSoldEvent extends Equatable {
  const ProductSoldEvent();

  @override
  List<Object> get props => [];
}

final class LoadProductSoldData extends ProductSoldEvent {
  final int branchId;
  const LoadProductSoldData(this.branchId);

  @override
  List<Object> get props => [branchId];
}

final class LoadNextPage extends ProductSoldEvent {
  final String nextPageUrl;
  const LoadNextPage(this.nextPageUrl);

  @override
  List<Object> get props => [nextPageUrl];
}
