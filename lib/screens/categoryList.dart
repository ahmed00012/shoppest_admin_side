import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppest_admin_side/db/category.dart';


class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {

  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  CategoryService _categoryService = CategoryService();

  @override
  void initState() {

    _getCategories ();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: Text("Categories",style: TextStyle(color: Colors.redAccent),),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body:ListView.builder(itemBuilder: (BuildContext context,int index){
        return new Column(
          children: <Widget>[

            Padding(padding: EdgeInsets.all(7),
              child:Text(categories [index].data['category'] , style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.w400),) ,),
            Divider()

          ],
        );
      },
        itemCount: categories .length,

      ),
    );
  }



  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();


    setState(() {
      categories  = data;


    });

  }
}



