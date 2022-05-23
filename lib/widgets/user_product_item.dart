import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_and_add_product.dart';

import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String id;

  final String imageUrl;

  UserProductItem(this.id,this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditAndAddProductScreen.routeName,arguments: id);
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(context: context, builder: (ctx)=>
                    AlertDialog(title: Text('Are You Sure ?'),
                      content: Text('Do You Want to Delete This Item ?'),
                      actions: [


                        FlatButton(onPressed: ()async{
                          try{
                            await Provider.of<Products>(context, listen: false).deleteProduct(id);

                          }catch(error){
                            scaffold.showSnackBar(SnackBar(
                                content: Text('Deleting Failed!!',textAlign: TextAlign.center,)
                            )
                            );
                          }

                          Navigator.of(ctx).pop(true);
                        }, child: Text('Yes')),
                        FlatButton(onPressed: (){
                          Navigator.of(ctx).pop(false);
                        }, child: Text('No')),

                      ],
                    )
    );
              },
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
