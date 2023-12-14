import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidgets extends StatelessWidget {
  const LoadingWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.symmetric(vertical: 20),child: 
    Center(child: SizedBox(child: CircularProgressIndicator(),width: 30,height: 30,),),);
  }
}