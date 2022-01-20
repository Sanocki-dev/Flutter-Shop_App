import 'package:flutter/material.dart';

// Local
import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Shop Now'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.shopping_bag,
              color: Theme.of(context).colorScheme.primaryVariant,
            ),
            title: Text(
              'Shop',
              style: Theme.of(context).primaryTextTheme.headline2,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
            selectedColor: Colors.amber,
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.payment,
              color: Theme.of(context).colorScheme.primaryVariant,
            ),
            title: Text(
              'Orders',
              style: Theme.of(context).primaryTextTheme.headline2,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.primaryVariant,
            ),
            title: Text(
              'Manage Products',
              style: Theme.of(context).primaryTextTheme.headline2,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
