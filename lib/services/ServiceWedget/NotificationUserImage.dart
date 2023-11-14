import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:zenify_app/Secreens/Profile/User_FromNotif.dart';
import 'package:zenify_app/modele/creatorUser.dart';
import 'package:zenify_app/services/widget/profile_widget.dart';

import 'package:get/get.dart';

class NotificationUserImage extends StatefulWidget {
  final String imageUrl;
  final bool isCirculair;
  CreatorUser? createduser;
  NotificationUserImage(
      {this.createduser, required this.imageUrl, required this.isCirculair});

  @override
  _NotificationUserImageState createState() => _NotificationUserImageState();
}

class _NotificationUserImageState extends State<NotificationUserImage> {
  Color? backgroundColor;

  @override
  void initState() {
    super.initState();
    loadImagePalette();
    print("${widget.createduser}");
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
              // color: backgroundColor,
            ),
            child: ProfileWidget(
              imagePath: widget.imageUrl,
              onClicked: () {
                print("${widget.createduser} createduser");
                Get.to(UserfromNotification(widget.createduser));
              },
            ),
          )
        : Image.network(widget.imageUrl);
  }
}
