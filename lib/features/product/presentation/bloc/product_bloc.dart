import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apicall/core/constants/app_constants.dart';
import 'package:apicall/features/product/domain/repositories/product_repository.dart';
import 'package:apicall/features/product/presentation/bloc/product_event.dart';
import 'package:apicall/features/product/presentation/bloc/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repo;

  ProductBloc(this._repo) : super(const ProductState()) {
    on<FetchProducts>(_onFetchProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
  }

  Future<void> _onFetchProducts(
    FetchProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await _repo.getProducts(skip: 0);
      final products = response.products ?? [];
      emit(state.copyWith(
        products: products,
        isLoading: false,
        skip: products.length,
        hasMore: products.length >= AppConstants.pageLimit,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state.isLoading || !state.hasMore) return;
    emit(state.copyWith(isLoading: true));
    try {
      final response = await _repo.getProducts(skip: state.skip);
      final newProducts = response.products ?? [];
      emit(state.copyWith(
        products: [...state.products, ...newProducts],
        isLoading: false,
        skip: state.skip + newProducts.length,
        hasMore: newProducts.length >= AppConstants.pageLimit,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
