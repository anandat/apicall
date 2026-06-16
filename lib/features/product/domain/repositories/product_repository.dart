import 'package:apicall/features/product/data/models/product_response_model.dart';

abstract class ProductRepository {
  Future<ProductResponse> getProducts({required int skip, int limit});
}
