import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/screens/splash_screen.dart';

import './screens/user_product_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_details_screen.dart';
import './screens/product_overview_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/edit_and_add_product.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build');
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProvider.value(value: Products(null,null,[])),

          ChangeNotifierProxyProvider<Auth, Products>(

              create: (_) => Products(null, null, []),
              update: (ctx, auth, prevProduct) => Products(auth.token,
                  auth.userId, prevProduct == null ? [] : prevProduct.items)),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (_) => Orders('', '', []),
              update: (ctx, auth, prevProduct) => Orders(auth.token!,
                  auth.userId!, prevProduct == null ? [] : prevProduct.orders)),
        ],
        child: Consumer<Auth>(
          builder: (ctx, authData, _) =>
          MaterialApp(
            title: 'My Shop',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
            pageTransitionsTheme:  PageTransitionsTheme(builders: {
              TargetPlatform.android:CustomPageTransitionBuilder(),
              TargetPlatform.iOS:CustomPageTransitionBuilder(),
            })),


            home: authData.isAuth
                ? ProductOverviewScreen()

                : FutureBuilder(
    future: authData.tryAutoLogin(),
    builder: (ctx, authResultSnapshot) {
                    // print(authResultSnapshot.data);
                        return authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen();}
                  ),
            routes: {
              ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
              ProductDetailsScreen.routName: (ctx) => ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditAndAddProductScreen.routeName: (ctx) =>
                  EditAndAddProductScreen(),
            },
          ),
        )
    );
  }
}
