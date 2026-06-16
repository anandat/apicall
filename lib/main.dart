import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apicall/core/constants/app_constants.dart';
import 'package:apicall/core/di/injection.dart';
import 'package:apicall/features/product/presentation/bloc/product_bloc.dart';
import 'package:apicall/features/product/presentation/bloc/product_event.dart';
import 'package:apicall/features/product/presentation/pages/product_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => getIt<ProductBloc>()..add(const FetchProducts()),
        child: const ProductPage(),
      ),
    );
  }
}
