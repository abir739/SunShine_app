import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:SunShine/services/widget/profile_widget.dart';

class ImageWithDynamicBackgroundColor extends StatefulWidget {
  final String imageUrl;
  final bool isCirculair;

  ImageWithDynamicBackgroundColor(
      {required this.imageUrl, required this.isCirculair});

  @override
  _ImageWithDynamicBackgroundColorState createState() =>
      _ImageWithDynamicBackgroundColorState();
}

class _ImageWithDynamicBackgroundColorState
    extends State<ImageWithDynamicBackgroundColor> {
  Color? backgroundColor;

  @override
  void initState() {
    super.initState();
    loadImagePalette();
  }

  Future<void> loadImagePalette() async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(NetworkImage(widget.imageUrl));

    setState(() {
      backgroundColor = paletteGenerator.dominantColor?.color ??
          Color.fromARGB(244, 228, 3,
              3); // Use a default color if no dominant color is found
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isCirculair
        ? Container(
            padding: EdgeInsets.all(4.0), // Adjust the padding values as needed
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
            child: ProfileWidget(
              imagePath: widget.imageUrl,
              onClicked: () {},
            ),
          )
        : Image.network(widget.imageUrl);
  }
}
