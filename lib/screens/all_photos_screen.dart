import 'dart:io';

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gallery/helper/databaseHelper.dart';
import 'package:flutter_gallery/helper/image_to_string.dart';
import 'package:flutter_gallery/helper/photos.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AllPhotosScreen extends StatefulWidget {
  @override
  _AllPhotosScreenState createState() => _AllPhotosScreenState();
}

class _AllPhotosScreenState extends State<AllPhotosScreen> {

  GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  DatabaseHelper databaseHelper;
  Future<File> imageFile;
  Image image;
  List<Photos> photo;

  @override
  void initState() {
    super.initState();
    photo = [];
    databaseHelper = DatabaseHelper();
    getAllPhotos();
    print(photo);
  }

  getAllPhotos() {
    databaseHelper.getPhotos().then((value) {
      print("Value : ${value}");
      setState(() {
        photo.clear();
        photo.addAll(value);
      });
    });
  }

  pickImageFromGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((value) {
      String imageString = ImageToString.base64String(value.readAsBytesSync());
      Photos p = Photos(id: 0, photoname: imageString);
      databaseHelper.save(p);
      getAllPhotos();
    });
  }

  pickImageFromCamera() {
    ImagePicker.pickImage(source: ImageSource.camera).then((value) {
      String imageString = ImageToString.base64String(value.readAsBytesSync());
      Photos p = Photos(id: 0, photoname: imageString);
      databaseHelper.save(p);
      getAllPhotos();
    });
  }

  gridView() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        children: photo.map((value) {
          return ImageToString.imageFromBase64String(value.photoname);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) => FabCircularMenu(
          key: fabKey,
          alignment: Alignment.bottomRight,
          ringColor: Colors.grey,
          ringDiameter: 300,
          ringWidth: 80,
          fabSize: 50,
          fabElevation: 10,
          fabColor: Colors.grey,
          fabOpenIcon: Icon(Icons.add, color: Colors.black,),
          fabCloseIcon: Icon(Icons.close, color: Colors.redAccent,),
          fabMargin: EdgeInsets.all(20),
          animationDuration: Duration(milliseconds: 500,),
          animationCurve: Curves.easeInOutCirc,
          children: <Widget>[
          FloatingActionButton(
            heroTag: "Add image from camera",
            tooltip: "Add image from camera",
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.camera,
              color: Colors.black,
            ),
            onPressed: () {
              pickImageFromCamera();
            },
          ),
            FloatingActionButton(
              heroTag: "Add image from gallery",
              tooltip: "Add image from gallery",
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.photo_album,
                color: Colors.black,
              ),
              onPressed: () {
                pickImageFromGallery();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Flutter Gallery",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: gridView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
