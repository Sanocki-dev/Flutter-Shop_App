import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Local
import '../providers/products.dart';
import '../providers/product.dart';

class ManageProductScreen extends StatefulWidget {
  static const routeName = '/mangage-products';

  const ManageProductScreen({Key? key}) : super(key: key);

  @override
  _ManageProductScreenState createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  final _imageController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  // ignore: prefer_final_fields
  var _managedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  // Runs right before build is executed
  @override
  void didChangeDependencies() {
    // Checks if this is the first build of the page
    if (_isInit) {
      var ctx = ModalRoute.of(context)?.settings.arguments;
      // If it is checks to see if it has a id argument
      if (ctx != null) {
        final String productId = ctx as String;
        _managedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _managedProduct.title,
          'description': _managedProduct.description,
          'price': _managedProduct.price.toString(),
          // 'imageUrl': _managedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageController.text = _managedProduct.imageUrl;
      }
    }

    // Makes sure this only runs once
    _isInit = false;
    super.didChangeDependencies();
  }

  // Clears data to not cause memory leaks
  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageURL);
    _imageController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  void _updateImageURL() {
    if (!_imageFocusNode.hasFocus) {
      if ((!_imageController.text.startsWith('http') &&
              !_imageController.text.startsWith('https')) ||
          (!_imageController.text.endsWith('.png') &&
              !_imageController.text.endsWith('.jpg') &&
              !_imageController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    if (_managedProduct.id == '') {
      Provider.of<Products>(context, listen: false).addProduct(_managedProduct);
    } else {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_managedProduct.id, _managedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              initialValue: _initValues['title'],
              decoration: InputDecoration(labelText: 'Title'),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) return 'Please enter a title.';
                return null; // No Error
              },
              onSaved: (value) {
                // Creates a new product only updating the title field
                _managedProduct = Product(
                  id: _managedProduct.id,
                  isFavorite: _managedProduct.isFavorite,
                  title: value as String,
                  description: _managedProduct.description,
                  price: _managedProduct.price,
                  imageUrl: _managedProduct.imageUrl,
                );
              },
            ),
            TextFormField(
              initialValue: _initValues['price'],
              decoration: InputDecoration(
                labelText: 'Price',
                icon: Icon(Icons.attach_money),
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a price.';
                } else if (double.tryParse(value) == null) {
                  return 'Please enter a valid number.';
                } else if (double.parse(value) <= 0) {
                  return 'Please enter a price greater than 0.';
                }
                return null; // No Error
              },
              onSaved: (value) {
                // Creates a new product only updating the price field
                _managedProduct = Product(
                  id: _managedProduct.id,
                  isFavorite: _managedProduct.isFavorite,
                  title: _managedProduct.title,
                  description: _managedProduct.description,
                  price: double.parse(value as String),
                  imageUrl: _managedProduct.imageUrl,
                );
              },
            ),
            TextFormField(
              initialValue: _initValues['description'],
              decoration: InputDecoration(labelText: 'Description'),
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a description.';
                } else if (value.length < 10) {
                  return 'Should be at least 10 characters long.';
                }

                return null; // No Error
              },
              onSaved: (value) {
                // Creates a new product only updating the description field
                _managedProduct = Product(
                  id: _managedProduct.id,
                  isFavorite: _managedProduct.isFavorite,
                  title: _managedProduct.title,
                  description: value as String,
                  price: _managedProduct.price,
                  imageUrl: _managedProduct.imageUrl,
                );
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(top: 8.0, right: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: _imageController.text.isEmpty
                      ? Text('Enter a URL')
                      : FittedBox(child: Image.network(_imageController.text)),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Image URL'),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    controller: _imageController,
                    focusNode: _imageFocusNode, // When this loses focus
                    onEditingComplete: () {
                      setState(() {});
                    },
                    onFieldSubmitted: (_) {
                      _saveForm();
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a image URL.';
                      } else if (!value.startsWith('http') &&
                          !value.startsWith('https')) {
                        return 'Please enter a valid URL.';
                      } else if (!value.endsWith('.png') &&
                          !value.endsWith('.jpg') &&
                          !value.endsWith('.jpeg')) {
                        return 'Please enter a valid image URL.';
                      }

                      return null; // No Error
                    },
                    onSaved: (value) {
                      // Creates a new product only updating the description field
                      _managedProduct = Product(
                        id: _managedProduct.id,
                        isFavorite: _managedProduct.isFavorite,
                        title: _managedProduct.title,
                        description: _managedProduct.description,
                        price: _managedProduct.price,
                        imageUrl: value as String,
                      );
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
