import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:apicall/core/network/dio_client.dart';
import 'package:apicall/features/product/data/repositories/product_repository_impl.dart';
import 'package:apicall/features/product/domain/repositories/product_repository.dart';
import 'package:apicall/features/product/presentation/bloc/product_bloc.dart';

final getIt = GetIt.instance;

void setupDI() {
  getIt.registerLazySingleton<Dio>(() => createDio());

  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt<Dio>()),
  );

  getIt.registerFactory<ProductBloc>(
    () => ProductBloc(getIt<ProductRepository>()),
  );
}
