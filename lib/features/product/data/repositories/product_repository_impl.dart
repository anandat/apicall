import 'package:dio/dio.dart';
import 'package:apicall/core/constants/app_constants.dart';
import 'package:apicall/features/product/data/models/product_response_model.dart';
import 'package:apicall/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final Dio _dio;

  ProductRepositoryImpl(this._dio);

  @override
  Future<ProductResponse> getProducts({required int skip, int limit = AppConstants.pageLimit}) async {
    final res = await _dio.get(
      AppConstants.productsEndpoint,
      queryParameters: {'skip': skip, 'limit': limit},
    );
    return ProductResponse.fromJson(res.data);
  }
}
