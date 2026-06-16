import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:apicall/dio_interceptor.dart';
import 'package:apicall/product_repo.dart';
import 'package:apicall/product_bloc.dart';

final getIt = GetIt.instance;

void setupDI() {
  getIt.registerLazySingleton<Dio>(() => createDio());
  getIt.registerLazySingleton<ProductRepo>(() => ProductRepo(getIt<Dio>()));
  getIt.registerFactory<ProductBloc>(() => ProductBloc(getIt<ProductRepo>()));
}
