import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_may/controller/home_screen_controller.dart';

import 'package:shopping_cart_may/view/cart_screen/cart_screen.dart';
import 'package:shopping_cart_may/view/product_details_screen/product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<HomeScreenController>().allcategories();
      await context.read<HomeScreenController>().getproducts();
    },);
    super.initState();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedIndex(int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final categoryWidth = screenWidth /
        3; // Adjust this width based on the item width (container + padding)
    final targetOffset =
        (index * categoryWidth) - (screenWidth / 2) + (categoryWidth / 2);

    _scrollController.animateTo(
      targetOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final catvalue=context.watch<HomeScreenController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Discover",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ));
              },
              icon: Icon(Icons.shopping_bag)),
          Stack(
            children: [
              Icon(
                Icons.notifications_none,
                color: Colors.black,
                size: 40,
              ),
              Positioned(
                right: 5,
                top: 5,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.black,
                  child: Text(
                    "1",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              )
            ],
          )
        ],
      ),
      body:catvalue.isloading
          ? Center(child: CircularProgressIndicator()) : Column(
        children: [
          // #1
          _buildsearchfield(),

          SizedBox(
            height: 16,
          ),
          _buildcatogery(catvalue),
          SizedBox(
            height: 16,
          ),
          __buildproductsection()
        ],
      ),
    );
  }

  Expanded __buildproductsection() {
    final    catvalue=context.watch<HomeScreenController>();
    return Expanded(

            child:catvalue.productLoading?Center(child: CircularProgressIndicator(),):
             GridView.builder(
          itemCount: catvalue.products.length,
          padding: EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            mainAxisExtent: 250,
          ),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(),
                  ));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(.2),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              catvalue.products[index].image??'null'))),
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.7),
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      Icons.favorite_outline,
                      size: 30,
                    ),
                  ),
                ),
                Text(
                  maxLines: 1,
                  "title",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Text("price".toString()),
              ],
            ),
          ),
        ));
  }

  SingleChildScrollView _buildcatogery(HomeScreenController catvalue) {
    final catvalue=context.watch<HomeScreenController>();
    return SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: List.generate(
                catvalue.categories.length,
                (index) => Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      _scrollToSelectedIndex(index);
                      context.read<HomeScreenController>().onCAtogoryselection( clickedindex:index);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      height: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: catvalue.selectedindex==index?Colors.black:Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        catvalue.categories[index].toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: catvalue.selectedindex==index?Colors.white:Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
  }

  Padding _buildsearchfield() {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(.2)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Search anything",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
              )
            ],
          ),
        );
  }
}