class AppConstants {
  AppConstants._();

  static const String baseUrl = 'https://dummyjson.com';
  static const String productsEndpoint = '/products';
  static const String appTitle = 'Products';

  static const int pageLimit = 10;
  static const double scrollThreshold = 0.8;

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static const double tabletBreakpoint = 600;
}
