import 'package:flutter/material.dart';

class SecondarySplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      //backgroundColor: Color(0xe1f5fe).withOpacity(1.0),
      //child: Expanded(child:FittedBox(child: new Image(image: new AssetImage("assets/splash.gif"),fit: BoxFit.fill,))),

      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/splash.gif"),
          fit: BoxFit.cover
        ) ,
      ),
    );
  }
}

