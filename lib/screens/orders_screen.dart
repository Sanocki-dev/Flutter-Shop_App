import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Local
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              // Error handling stuff
              return Center(
                child: Text('Error has occured!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, ordersData, _) {
                  if (ordersData.orders.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'No orders yet!',
                            style: Theme.of(context).textTheme.headline6,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                          child: Text('Shop Now!'),
                        )
                      ],
                    );
                  } else {
                    return ListView.builder(
                      itemCount: ordersData.orders.length,
                      itemBuilder: (ctx, i) => OrderItem(
                        ordersData.orders[i],
                      ),
                    );
                  }
                },
              );
            }
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
