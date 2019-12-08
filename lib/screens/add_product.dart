import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppest_admin_side/db/brand.dart';
import 'dart:convert';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:shoppest_admin_side/db/category.dart';
import 'package:shoppest_admin_side/db/product.dart';

class addproduct extends StatefulWidget {
  @override
  _addproductState createState() => _addproductState();
}

class _addproductState extends State<addproduct> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController ProductNameConroller = new TextEditingController();
  TextEditingController quantityConroller = new TextEditingController();
  TextEditingController priceConroller = new TextEditingController();
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  String _currentBrand;
  String _currentCategory;
  String _currentGender;
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  ProductService productService = ProductService();
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;
  List<String> selectedSizes = <String>[];
  File _image1;
  File _image2;
  File _image3;
  bool isLoading = false;

  @override
  void initState() {
    _getCategories();
    _getBrands();
    _getGender();
  }

  List<DropdownMenuItem<String>> getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
              child: Text(categories[i].data['category']),
              value: categories[i].data['category'],
            ));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getBrandosDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < brands.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(brands[i].data['brand']),
                value: brands[i].data['brand']));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getGenderDown() {
    List<DropdownMenuItem<String>> items = new List();

    setState(() {
      items.insert(0, DropdownMenuItem(child: Text("Men"), value: 'Men'));
      items.insert(1, DropdownMenuItem(child: Text("Women"), value: 'Women'));
      items.insert(
          2, DropdownMenuItem(child: Text("Kids"), value: 'Children'));
    });

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Colors.white,
          leading: Icon(
            Icons.close,
            color: Colors.black,
          ),
          title: new Text(
            "add product",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: isLoading
              ? Center(child:CircularProgressIndicator())
              : Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: OutlineButton(
                              onPressed: () {
                                _selectImage(
                                    ImagePicker.pickImage(
                                        source: ImageSource.gallery),
                                    1);
                              },
                              child: _displayChild1(),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.8),
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: OutlineButton(
                                onPressed: () {
                                  _selectImage(
                                      ImagePicker.pickImage(
                                          source: ImageSource.gallery),
                                      2);
                                },
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.8),
                                  width: 1.0,
                                ),
                                child: _displayChild2()),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: OutlineButton(
                                onPressed: () {
                                  _selectImage(
                                      ImagePicker.pickImage(
                                          source: ImageSource.gallery),
                                      3);
                                },
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.8),
                                  width: 1.0,
                                ),
                                child: _displayChild3()),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                        controller: ProductNameConroller,
                        decoration: InputDecoration(hintText: 'product name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'you must put product name';
                          }
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Category: ',
                                style: TextStyle(color: red),
                              ),
                            ),
                            DropdownButton(
                              items: categoriesDropDown,
                              onChanged: changeSelectedCategory,
                              value: _currentCategory,
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Brand: ',
                                style: TextStyle(color: red),
                              ),
                            ),
                            DropdownButton(
                              items: brandsDropDown,
                              onChanged: changeSelectedBrand,
                              value: _currentBrand,
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'gender: ',
                                style: TextStyle(color: red),
                              ),
                            ),
                            DropdownButton(
                              items: getGenderDown(),
                              onChanged: changeSelectedGender,
                              value: _currentGender,
                            ),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: quantityConroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Quantity',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'You must enter the quantity';
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: priceConroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'price',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'You must enter the price';
                          }
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    Text('Available Sizes'),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Checkbox(
                                  value: selectedSizes.contains('XS'),
                                  onChanged: (value) =>
                                      changeSelectedSize('XS')),
                              Text('XS'),
                              Checkbox(
                                  value: selectedSizes.contains('S'),
                                  onChanged: (value) =>
                                      changeSelectedSize('S')),
                              Text('S'),
                              Checkbox(
                                  value: selectedSizes.contains('M'),
                                  onChanged: (value) =>
                                      changeSelectedSize('M')),
                              Text('M'),
                              Checkbox(
                                  value: selectedSizes.contains('L'),
                                  onChanged: (value) =>
                                      changeSelectedSize('L')),
                              Text('L'),
                              Checkbox(
                                  value: selectedSizes.contains('XL'),
                                  onChanged: (value) =>
                                      changeSelectedSize('XL')),
                              Text('XL'),
                              Checkbox(
                                  value: selectedSizes.contains('XXL'),
                                  onChanged: (value) =>
                                      changeSelectedSize('XXL')),
                              Text('XXL'),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Checkbox(
                                  value: selectedSizes.contains('28'),
                                  onChanged: (value) =>
                                      changeSelectedSize('28')),
                              Text('28'),
                              Checkbox(
                                  value: selectedSizes.contains('30'),
                                  onChanged: (value) =>
                                      changeSelectedSize('30')),
                              Text('30'),
                              Checkbox(
                                  value: selectedSizes.contains('32'),
                                  onChanged: (value) =>
                                      changeSelectedSize('32')),
                              Text('32'),
                              Checkbox(
                                  value: selectedSizes.contains('34'),
                                  onChanged: (value) =>
                                      changeSelectedSize('34')),
                              Text('34'),
                              Checkbox(
                                  value: selectedSizes.contains('36'),
                                  onChanged: (value) =>
                                      changeSelectedSize('36')),
                              Text('36'),
                              Checkbox(
                                  value: selectedSizes.contains('38'),
                                  onChanged: (value) =>
                                      changeSelectedSize('38')),
                              Text('38'),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Checkbox(
                                  value: selectedSizes.contains('40'),
                                  onChanged: (value) =>
                                      changeSelectedSize('40')),
                              Text('40'),
                              Checkbox(
                                  value: selectedSizes.contains('42'),
                                  onChanged: (value) =>
                                      changeSelectedSize('42')),
                              Text('42'),
                              Checkbox(
                                  value: selectedSizes.contains('44'),
                                  onChanged: (value) =>
                                      changeSelectedSize('44')),
                              Text('44'),
                              Checkbox(
                                  value: selectedSizes.contains('46'),
                                  onChanged: (value) =>
                                      changeSelectedSize('46')),
                              Text('46'),
                              Checkbox(
                                  value: selectedSizes.contains('48'),
                                  onChanged: (value) =>
                                      changeSelectedSize('48')),
                              Text('48'),
                              Checkbox(
                                  value: selectedSizes.contains('50'),
                                  onChanged: (value) =>
                                      changeSelectedSize('50')),
                              Text('50'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    FlatButton(
                      color: red,
                      textColor: white,
                      child: Text('add product'),
                      onPressed: () {
                        validateAndUpload();
                      },
                    )
                  ],
                ),
        ));
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    print(data.length);
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropDown();
      _currentCategory = categories[0].data['category'];
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }

  _getBrands() async {
    List<DocumentSnapshot> data = await _brandService.getBrands();
    print("data =" + data.length.toString());
    setState(() {
      brands = data;
      brandsDropDown = getBrandosDropDown();
      _currentBrand = brands[0].data['brand'];
    });
  }
  _getGender()async{
    setState(() {
      _currentGender='Men';
    });
  }

  changeSelectedBrand(String selectedBrand) {
    setState(() => _currentBrand = selectedBrand);
  }

  changeSelectedGender(String selectedGender) {
    setState(() => _currentGender = selectedGender);
  }

  void changeSelectedSize(String size) {
    if (selectedSizes.contains(size)) {
      setState(() {
        selectedSizes.remove(size);
      });
    } else {
      setState(() {
        selectedSizes.insert(0, size);
      });
    }
  }

  void _selectImage(Future<File> pickImage, int imageNumber) async {
    File tempImg = await pickImage;
    switch (imageNumber) {
      case 1:
        setState(() => _image1 = tempImg);
        break;
      case 2:
        setState(() => _image2 = tempImg);
        break;
      case 3:
        setState(() => _image3 = tempImg);
        break;
    }
  }

  Widget _displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 40, 12, 40),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image1,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Widget _displayChild2() {
    if (_image2 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 40, 12, 40),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image2,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Widget _displayChild3() {
    if (_image3 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 40, 12, 40),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image3,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Future validateAndUpload() async {
    //  if (_formKey.currentState.validate()) {

    setState(() => isLoading = true);
    if (_image1 != null && _image2 != null && _image3 != null) {
      if (selectedSizes.isNotEmpty) {
        String imageUrl1;
        String imageUrl2;
        String imageUrl3;
        final FirebaseStorage storage = FirebaseStorage.instance;
        final String picture1 =
            "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
        StorageUploadTask task1 =
            storage.ref().child(picture1).putFile(_image1);
        final String picture2 =
            "2${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
        StorageUploadTask task2 =
            storage.ref().child(picture2).putFile(_image2);
        final String picture3 =
            "3${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
        StorageUploadTask task3 =
            storage.ref().child(picture3).putFile(_image3);

        StorageTaskSnapshot snapshot1 =
            await task1.onComplete.then((snapshot) => snapshot);
        StorageTaskSnapshot snapshot2 =
            await task2.onComplete.then((snapshot) => snapshot);

        task3.onComplete.then((snapshot3) async {
          imageUrl1 = await snapshot1.ref.getDownloadURL();
          imageUrl2 = await snapshot2.ref.getDownloadURL();
          imageUrl3 = await snapshot3.ref.getDownloadURL();

          List<String> imageList = [imageUrl1, imageUrl2, imageUrl3];

          productService.UploadProduct(
            productName: ProductNameConroller.text,
            quantity: int.parse(quantityConroller.text),
            brand: _currentBrand,
            category: _currentCategory,
            sizes: selectedSizes,
            images: imageList,
            price: double.parse(priceConroller.text),
            gender: _currentGender,
          );
        });
//          _formKey.currentState.reset();
        setState(() => isLoading = false);
        Navigator.pop(context);
      }
    }
//    }
  }
}
