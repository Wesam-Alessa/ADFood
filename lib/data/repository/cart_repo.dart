
import 'dart:convert';

import 'package:food_delivery_app/models/cart_model.dart';
import 'package:food_delivery_app/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo{

  final SharedPreferences sharedPreferences;

  CartRepo({required this.sharedPreferences});


  List<String> cart = [];

  List<String> cartHistory = [];

  void addToCartList(List<CartModel> cartList){
    //sharedPreferences.remove(AppConstants.CART_LIST);
    //sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
    //return;
    cart = [];
    var time = DateTime.now().toString();
    /*
      convert objects to string because shared preferences only accepts string
     */
    for (int i=0; i<cartList.length;i++) {
      cartList[i].time = time;
      cart.add(jsonEncode(cartList[i]));
    }
    setCartListInSharedPreferences(AppConstants.CART_LIST,cart);
    //getCartList();
  }

  void setCartListInSharedPreferences(String key,List<String>list){
    sharedPreferences.setStringList(key,list);
  }

  List<String> getCartHistoryListFromSharedPreferences(String key,){
    List<String> list = [];
    list = sharedPreferences.getStringList(key)!;
    return list;
  }

  List<CartModel> getCartList(){
    List<String> sharedCart = [];
    if(sharedPreferences.containsKey(AppConstants.CART_LIST)){
      sharedCart = getCartHistoryListFromSharedPreferences(AppConstants.CART_LIST) ;
    }
    List<CartModel> cartList = [];
    for (int i=0; i< sharedCart.length;i++) {
      cartList.add(CartModel.fromJson(jsonDecode(sharedCart[i])));
    }
    return cartList;
  }

  void addToCartHistoryList(){
    if(sharedPreferences.containsKey(AppConstants.CART_HISTORY_LIST)){
      cartHistory = [];
      cartHistory = getCartHistoryListFromSharedPreferences(AppConstants.CART_HISTORY_LIST);
    }
    for(int i=0; i< cart.length;i++){
      cartHistory.add(cart[i]);
    }
    setCartListInSharedPreferences(AppConstants.CART_HISTORY_LIST,cartHistory);
    removeCart();
  }

  List<CartModel> getCartHistoryList(){
    if(sharedPreferences.containsKey(AppConstants.CART_HISTORY_LIST)){
      cartHistory = [];
      cartHistory = getCartHistoryListFromSharedPreferences(AppConstants.CART_HISTORY_LIST);
    }
    List<CartModel> cartHistoryList = [];
    for (int i=0; i< cartHistory.length;i++) {
      cartHistoryList.add(CartModel.fromJson(jsonDecode(cartHistory[i])));
    }
    return cartHistoryList;
  }

  void removeCart(){
    cart = [];
    sharedPreferences.remove(AppConstants.CART_LIST);
  }
  void clearCartHistory(){
    removeCart();
    cartHistory = [];
    sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
  }

  void removeCartSharedPreference(){
    sharedPreferences.remove(AppConstants.CART_LIST);
    sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
  }
}