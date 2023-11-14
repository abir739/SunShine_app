import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:palette_generator/palette_generator.dart';

class ImageViewScreen extends StatefulWidget {
  final String imageUrl;

  ImageViewScreen(this.imageUrl);

  @override
  _ImageViewScreenState createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  Color? backgroundColor;

  @override
  void initState() {
    super.initState();
    loadImagePalette();
  }

  Future<void> loadImagePalette() async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(NetworkImage(widget.imageUrl));

    if (mounted) {
      setState(() {
        backgroundColor = paletteGenerator.dominantColor?.color ??
            Color.fromARGB(1, 228, 3, 3); // Use a default color if no dominant color is found
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor, // Set the background color
        child: PhotoView(
          enablePanAlways: true,
          imageProvider: NetworkImage(widget.imageUrl),
          backgroundDecoration: BoxDecoration(
            color: backgroundColor,
          ),  scaleStateCycle: (currentScaleState) {
          // Implement your custom logic for cycling through scale states
          if (currentScaleState == PhotoViewScaleState.originalSize) {
            return PhotoViewScaleState.covering;
          } else if (currentScaleState == PhotoViewScaleState.covering) {
            return PhotoViewScaleState.originalSize;
          }
          return currentScaleState;
        },
      
    
  
        ),
      ),
    );
  }
}
