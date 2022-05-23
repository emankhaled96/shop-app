import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../providers/product.dart';
import './product_item.dart';

import '../providers/products.dart';
class ProductsGrid extends StatelessWidget {

  final bool showFavs;
  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
   final productsData= Provider.of<Products>(context);
   final products = showFavs ? productsData.favoritesItem :productsData.items;
   //print(products);
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3 / 2),
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: products[i] ,
          child: ProductItem(
              // products[i].id,
              // products[i].title,
              // products[i].imageUrl
          ),
        )
    );
  }
}
