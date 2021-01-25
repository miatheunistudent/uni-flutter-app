/* ************************************************************************
 * FILE : ImageViewer.dart
 * DESC : Full screen images from given List of MemoryImages, starting
 *        at given index
 * ************************************************************************
 */

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewer extends StatelessWidget {

  final List<ImageProvider<Object>> images;
  final int startingIndex;
  ImageViewer(this.images, this.startingIndex, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Controls movement between pages
    PageController galleryController = PageController(
      initialPage: startingIndex,
    );

    // Array to contain image tiles
    List<PhotoViewGalleryPageOptions> pages = [];
    this.images.forEach((image) => pages.add(
      PhotoViewGalleryPageOptions(
        imageProvider: image,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 3
      )
    ));

    return Scaffold(
      
      // App bar
      appBar: AppBar(
        backgroundColor: Colors.black.withAlpha(175),
      ),
      extendBodyBehindAppBar: true,

      // Background
      backgroundColor: Colors.black,

      // Contains images
      body: PhotoViewGallery(
        pageOptions: pages,
        pageController: galleryController
      ),
    );
  }
}