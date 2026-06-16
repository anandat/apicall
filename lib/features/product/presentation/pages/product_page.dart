import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apicall/core/constants/app_constants.dart';
import 'package:apicall/features/product/presentation/bloc/product_bloc.dart';
import 'package:apicall/features/product/presentation/bloc/product_event.dart';
import 'package:apicall/features/product/presentation/bloc/product_state.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
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
        title: const Text(AppConstants.appTitle),
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
              separatorBuilder: (_, _) => const Divider(height: 1),
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
