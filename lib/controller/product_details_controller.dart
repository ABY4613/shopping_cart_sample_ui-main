import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_cart_may/app_config.dart';

import 'package:shopping_cart_may/model/product_model.dart';

class ProductDetailsController with ChangeNotifier {
  // List categories = ['All'];
  bool isloading=false;
  bool productLoading=false;
  int selectedindex=0;
  List <ProductModel>  products=[];


  // Future<void> allcategories() async {
  //   final url = Uri.parse(AppConfig.baseUrl+'products/categories');
  //   try {isloading=true;
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       // categories=jsonDecode(response.body);
  //       // categories.insert(0, 'All');//for adding extra catogory all
  //   }

  //   } catch (e) {}isloading=false;notifyListeners();
  // }

  Future productDetails({String?category}) async {
    String endpointurl=category==null?'products':'/products/$category';


    final url=Uri.parse(AppConfig.baseUrl+endpointurl);
  
    try{productLoading=true;
    notifyListeners();
 
  final response = await http.get(url);
  if(response.statusCode==200){
     products=productModelFromJson(response.body);
   
    
  }else{log('api failed${response.body}');}
    }catch(e){}
    productLoading=false;
    notifyListeners();

  }
  // onCAtogoryselection({required int clickedindex}){
    // selectedindex=clickedindex;
    // getproducts(category: selectedindex==0?null:categories[selectedindex]);
      
    
    // notifyListeners();
  

  // }
}