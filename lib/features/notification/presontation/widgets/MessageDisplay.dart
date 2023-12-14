import 'package:flutter/cupertino.dart';

class MessageDisplay extends StatelessWidget {
 final String Message;
   MessageDisplay({super.key, required this.Message});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(Message,style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
