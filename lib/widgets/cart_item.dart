import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String prodId;

  final double price;
  final int quantity;
  final String title;

  CartItem({
    required this.id,
    required this.prodId,
    required this.title,
    required this.price,
    required this.quantity,
  });
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(color: Theme.of(context).errorColor,
      child: Icon(Icons.delete,
      color: Colors.white,
      size: 40,
      )
        ,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(context: context, builder: (ctx)=>
            AlertDialog(title: Text('Are You Sure ?'),
            content: Text('Do You Want to Delete This Item ?'),
            actions: [


              FlatButton(onPressed: (){
                Navigator.of(ctx).pop(true);
              }, child: Text('Yes')),
              FlatButton(onPressed: (){
                Navigator.of(ctx).pop(false);
              }, child: Text('No')),

            ],)
        );

      },
      onDismissed: (direction){
        Provider.of<Cart>(context,listen: false).removeItem(prodId);
      },
      child: Card(

        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(

              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                    child: Text('\$$price')),
              ),
              radius: 25,
            ),
            title: Text(title),
            subtitle: Text('Total : \$${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
