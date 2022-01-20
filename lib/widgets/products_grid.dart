import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Local
import '../widgets/loading_container.dart';
import '../providers/products.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  final bool isLoading;

  const ProductsGrid(
    this.showFavs,
    this.isLoading, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;

    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size.width;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: isLoading ? 6 : products.length,
      // Defines how the grid is structured
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenSize <= 400 ? 2 : 2,
        childAspectRatio: 2 / 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      // .value is best used to display items that already exist
      itemBuilder: isLoading
          ? (ctx, index) => GridTile(
                child: LoadingContainer(),
              )
          : (ctx, index) => ChangeNotifierProvider.value(
                value: products[index],
                child: ProductItem(),
              ),
    );
  }
}
