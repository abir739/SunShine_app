import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:SunShine/services/widget/profile_widget.dart';

class ImageWithDynamicBackgroundColorusersList extends StatefulWidget {
  final String imageUrl;
  final bool isCirculair;
  bool color;

  ImageWithDynamicBackgroundColorusersList(
      {required this.color, required this.imageUrl, required this.isCirculair});

  @override
  _ImageWithDynamicBackgroundColorusersListState createState() =>
      _ImageWithDynamicBackgroundColorusersListState();
}

class _ImageWithDynamicBackgroundColorusersListState
    extends State<ImageWithDynamicBackgroundColorusersList> {
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
            Color.fromARGB(1, 228, 3,
                3); // Use a default color if no dominant color is found
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isCirculair
        ? Container(
            width: 50, height: 50,
            padding: EdgeInsets.all(2.5), // Adjust the padding values as needed
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color ? backgroundColor : Colors.black,
            ),
            child: ProfileWidget(
              imagePath: widget.imageUrl,
              onClicked: () {},
            ),
          )
        : Image.network(widget.imageUrl);
  }
}
