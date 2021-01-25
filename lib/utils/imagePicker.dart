/* ************************************************************************
 * FILE : imagePicker.dart
 * DESC : Class used to select images from local storage.
 * ************************************************************************
 */

import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:unistudentapp/utils/backend/userInteraction.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:unistudentapp/data/globals.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:uuid/uuid.dart';

class ImagePickerWidget extends StatefulWidget {
  final UserAccount account;
  ImagePickerWidget(this.account);

  @override
  ImagePickerState createState() => new ImagePickerState();
}

class ImagePickerState extends State<ImagePickerWidget> {

  List<MemoryImage> thumbnails;
  
  @override
  void initState() {
    super.initState();
    loadPhotos();
  }

  Future<void> loadPhotos() async {
    await this.widget.account.loadPhotos();
    setState(() {});
  }

  // Adds new image to global array
  Future<void> getImageFile() async {

    PickedFile image;
    Uint8List convertedImage;

    // Gets image from gallery
    image = await ImagePicker().getImage(source: ImageSource.gallery);

    // If no image
    if (image == null)
      return;

    // Compresses and coverts image
    convertedImage = await compressImage(image.path);

    // Save image to memory
    await this.widget.account.addPhoto(Uuid().v4(), convertedImage);
  }

  // Returns a list of tiles corresponding to images
  Widget imageTiles(int index) {

    // Creates tile for each image in list
    if (index < this.widget.account.photos.length) {
      return Card(
        elevation: 0,
        semanticContainer: true,
        color: Color(0xFFE5E5E5),
        child: Stack(children: <Widget>[

          // Displays image itself in box
          Container(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Image(
                image: this.widget.account.photos[index],
                fit: BoxFit.contain
              )
            )
          ),

          // Floating remove button for image
          Positioned(
            top: -8,
            right: -26,
            child: MaterialButton(
              height: 24,
              shape: CircleBorder(),
              color: PRIMARY_COLOR,
              child: Icon(
                Icons.close,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () {
                this.widget.account.removePhoto(index);
                setState(() {});
              },
            )
          )
        ])
      );
    }
 
    // Tile for adding a new image
    else {
      return Container(
        padding: EdgeInsets.all(45),
        child: FloatingActionButton(
          heroTag: UniqueKey(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          elevation: 0.2,
          focusElevation: 1.0,
          highlightElevation: 1.0,
          hoverElevation: 1.0,
          backgroundColor: Color(0xFFE5E5E5),
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
          onPressed: () async {
            await getImageFile();
            setState(() {});
          }
        )
      );
    }
  }

  int numImages() {
    return (this.widget.account.photos.length == 5)
    ? this.widget.account.photos.length
    : this.widget.account.photos.length + 1;
  }

  @override
  Widget build(BuildContext context) {

    return this.widget.account.photos == null
    ? Container(height: 50, child: Center(child: CircularProgressIndicator()))
    : Center(child: GridView.builder(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: numImages(),
        itemBuilder: (context, index) => imageTiles(index),
      ));
  }
}

// Compresses image from path
Future<Uint8List> compressImage(String path) {
  return FlutterImageCompress.compressWithFile(
    path,
    minHeight: 1080,
    minWidth: 1080
  );
}