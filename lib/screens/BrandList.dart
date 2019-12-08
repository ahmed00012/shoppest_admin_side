import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppest_admin_side/db/brand.dart';


class BrandList extends StatefulWidget {
  @override
  _BrandListState createState() => _BrandListState();
}

class _BrandListState extends State<BrandList> {

  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  BrandService _brandService = BrandService();

  @override
  void initState() {

    _getBrands();
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.white,
        title: Text("Brands",style: TextStyle(color: Colors.redAccent),),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
        body:ListView.builder(itemBuilder: (BuildContext context,int index){
          return new Column(
            children: <Widget>[

              Padding(padding: EdgeInsets.all(7),
              child:Text(brands[index].data['brand'] , style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.w400),) ,),
              Divider()

            ],
          );
        },
          itemCount: brands.length,

        ),
    );
  }



 _getBrands() async {
  List<DocumentSnapshot> data = await _brandService.getBrands();
  List<String> brandsList = new List(data.length);

  setState(() {
    brands = data;


  });
//  for(int i=0; i<brands.length ; i++){
//
//    brandsList.insert(i,brands[i].data['brand']);
//
//
//  }
//
//
//  return brandsList;
}
}







//
//
//
