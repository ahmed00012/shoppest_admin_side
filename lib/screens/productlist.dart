import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shoppest_admin_side/db/product.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:popup_menu/popup_menu.dart';

import '../Admin.dart';

class products extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _products();
  }
}

class _products extends State<products> {
  List<DocumentSnapshot> product_list = <DocumentSnapshot>[];
  ProductService _productService = ProductService();


  @override
  initState() {
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        title: Text(
          "products",
          style: TextStyle(color: Colors.redAccent),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: GridView.builder(
          padding: EdgeInsets.all(10),
          itemCount: product_list.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, childAspectRatio: 2),
          itemBuilder: (BuildContext context, int index) {


            return product(
              id: product_list[index].data['id'],
              name: product_list[index].data['name'],
              images: product_list[index].data['images'][0],
              price: product_list[index].data['price'].toString(),
              quantity: product_list[index].data['quantity'].toString(),
              brand: product_list[index].data['brand'],
              category: product_list[index].data['category'],
            );
          }),
    );
  }

  _getProducts() async {
    List<DocumentSnapshot> data = await _productService.getProducts();

    setState(() {
      product_list = data;
    });
  }
}

class product extends StatefulWidget {
  var id;
  final String name;
  final String images;
  final String price;
  final String quantity;
  final String brand;
  final String category;

  product(
      {this.id,
      this.name,
      this.images,
      this.price,
      this.quantity,
      this.brand,
      this.category});



  @override
  _productState createState() => _productState();
}


class _productState extends State<product> {

  @override


  Firestore _firestore = Firestore.instance;


//  @override
//  void initState() {
//    _updateData();
//    //Delete();
//  }

  _updateData() {
    setState(()  {
       _firestore
          .collection('product')
          .document(widget.id)
          .updateData({'quantity': FieldValue.increment(-1)});

    });
  }

  _navigate() {
    Navigator.pop(context);
  }
  Future<void> Delete() {
    _firestore.collection('product').document(widget.id).delete();
  }

  @override
  Widget build(BuildContext context) {


    // TODO: implement build
    return Scaffold(
      body:Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(widget.images),
            Padding(
              padding: EdgeInsets.all(5),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "name: ",
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(widget.name, style: TextStyle(fontSize: 18))
                  ],
                ),
                Padding(padding: EdgeInsets.all(5)),
                Row(children: <Widget>[
                  Text(
                    "price: ",
                    style: TextStyle(color: Colors.red),
                  ),
                  Text(widget.price, style: TextStyle(fontSize: 18))
                ]),
                Padding(padding: EdgeInsets.all(3)),
                Row(
                  children: <Widget>[
                    Text(
                      "quantity:  ",
                      style: TextStyle(color: Colors.red,fontSize: 14)
                    ),
                    Text(widget.quantity.toString(),style: TextStyle(fontSize: 18),),
//
//               Counter(
//                   initialValue: int.parse(widget.quantity),
//                   minValue: 0,
//                   maxValue: int.parse(widget.quantity),
//                   step: 1,
//                   color: Colors.red,
//                   textStyle: TextStyle(fontSize: 18),
//                   buttonSize: 25  ,
//                   decimalPlaces: 0,
//                   onChanged: (value) {
//                     _updateData();
//
//                   } // get the latest value from here
//
//               ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(3)),
                Row(
                  children: <Widget>[
                    Text(
                      "brand: ",
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(widget.brand, style: TextStyle(fontSize: 16)),
                    Padding(padding: EdgeInsets.only(right: 20)),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(3),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "category: ",
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(widget.category, style: TextStyle(fontSize: 16)),
                  ],
                )
              ],
            ),

            Padding(padding: EdgeInsets.only(left: 30),
              child: PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                          child: InkWell(
                            child: Text("delete"),
                            onTap: () {
                              Delete();
                              _navigate();
                            },
                          )),
                      PopupMenuItem(
                          child: InkWell(
                            child: Text("edit"),
                          ))
                    ];
                  }

              ),)

          ],
        ),
      )
    );
  }
}
