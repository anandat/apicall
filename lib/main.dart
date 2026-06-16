import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apicall/di.dart';
import 'package:apicall/product_bloc.dart';
import 'package:apicall/product_event.dart';
import 'package:apicall/product_state.dart';
import 'package:apicall/app_constants.dart';

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
        child: const MyHomePage(title: AppConstants.appTitle),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll * AppConstants.scrollThreshold) {
      context.read<ProductBloc>().add(const LoadMoreProducts());
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isTablet = screenWidth > AppConstants.tabletBreakpoint;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state.isLoading && state.products.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null && state.products.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.error!,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenWidth * 0.03),
                      ElevatedButton(
                        onPressed: () => context
                            .read<ProductBloc>()
                            .add(const FetchProducts()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.separated(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? screenWidth * 0.1 : screenWidth * 0.04,
                vertical: screenWidth * 0.02,
              ),
              itemCount: state.products.length + (state.hasMore ? 1 : 0),
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                if (index >= state.products.length) {
                  return Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                final product = state.products[index];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenWidth * 0.01,
                  ),
                  title: Text(
                    product.title ?? '',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
