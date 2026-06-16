import 'package:apicall/product_response_model.dart';
import 'package:apicall/app_constants.dart';
import 'package:dio/dio.dart';

class ProductRepo {
  final Dio _dio;

  ProductRepo(this._dio);

  Future<ProductResponse> getProducts({required int skip, int limit = AppConstants.pageLimit}) async {
    final res = await _dio.get(
      AppConstants.productsEndpoint,
      queryParameters: {'skip': skip, 'limit': limit},
    );
    return ProductResponse.fromJson(res.data);
  }
}
