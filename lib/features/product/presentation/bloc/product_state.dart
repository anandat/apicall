import 'package:equatable/equatable.dart';
import 'package:apicall/features/product/data/models/product_response_model.dart';

class ProductState extends Equatable {
  final List<Products> products;
  final bool isLoading;
  final bool hasMore;
  final int skip;
  final String? error;

  const ProductState({
    this.products = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.skip = 0,
    this.error,
  });

  ProductState copyWith({
    List<Products>? products,
    bool? isLoading,
    bool? hasMore,
    int? skip,
    String? error,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      skip: skip ?? this.skip,
      error: error,
    );
  }

  @override
  List<Object?> get props => [products, isLoading, hasMore, skip, error];
}
