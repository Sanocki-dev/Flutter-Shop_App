import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Local
import '../screens/manage_product_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem({
    Key? key,
    required this.id,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
        child: ListTile(
          title: Text(title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          trailing: SizedBox(
            width: 96,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => {
                    Navigator.of(context).pushNamed(
                      ManageProductScreen.routeName,
                      arguments: id,
                    )
                  },
                  icon: Icon(Icons.edit),
                  color: Theme.of(context).colorScheme.primary,
                ),
                IconButton(
                  onPressed: () async {
                    try {
                      await Provider.of<Products>(
                        context,
                        listen: false,
                      ).deleteProduct(id);
                    } catch (e) {
                      scaffold.hideCurrentSnackBar();
                      scaffold.showSnackBar(
                        SnackBar(
                          content: Text('Deleting failed!'),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
