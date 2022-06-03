import 'dart:convert';

import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final num price;
  final String imageUrl;
  bool isFavorite;


  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false
});

  void _setFavValue(bool newValue){
    isFavorite = newValue;
    notifyListeners();
  }
  Future<void> toggleFavoriteStatus(String? authToken,String userId)async{
    final url = Uri.parse(
        'https://twitter-clone-228ab.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken');
    final oldFavStatus=isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try{
      final response = await http.put(url,body: json.encode(
        isFavorite
      ));
      // print(json.decode(response.body));
      if (response.statusCode >= 400) {
       _setFavValue(oldFavStatus);
      }
    }catch(error){
      // print(error);
      _setFavValue(oldFavStatus);

    }



  }

}