import 'package:dio/dio.dart';
import 'package:apicall/core/constants/app_constants.dart';
import 'package:apicall/core/network/app_interceptor.dart';

Dio createDio() {
  final dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: AppConstants.connectTimeout,
    receiveTimeout: AppConstants.receiveTimeout,
  ));
  dio.interceptors.add(AppInterceptor());
  return dio;
}
