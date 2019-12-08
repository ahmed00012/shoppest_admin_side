import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductService{
  Firestore _firestore = Firestore.instance;
  String ref = 'product';
  var id = Uuid();
  String productId;






  void UploadProduct({String productName ,int quantity,String brand,String category, List sizes , List images , double price,String gender  }){

     productId = id.v1();

    _firestore.collection(ref).document(productId).setData({
      'name': productName,
      'id':productId,
      'price':price,
      'images':images,
      'brand':brand,
      'category':category,
      'quantity':quantity,
      'gender':gender,
      'sizes':sizes



    });
  }

  Future<List<DocumentSnapshot>> getProducts() => _firestore.collection(ref).getDocuments().then((snaps){

    return snaps.documents;
  });



}