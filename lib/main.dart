import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Local
import './providers/cart.dart';
import './providers/products.dart';
import './providers/orders.dart';
import './screens/user_products_screen.dart';
import './screens/manage_product_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // create is best used to display items that dont already exist
    // or when you will be creating new items
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          canvasColor: Colors.teal[100],
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.teal,
            accentColor: Colors.white,
          ).copyWith(
            secondary: Colors.tealAccent[400],
          ),
          fontFamily: 'Lato',
          primaryTextTheme: TextTheme(
            headline1: TextStyle(
              color: Colors.teal,
            ),
            headline2: TextStyle(
              color: Colors.teal[800],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          ManageProductScreen.routeName: (ctx) => ManageProductScreen(),
        },
      ),
    );
  }
}
