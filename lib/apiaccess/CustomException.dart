import 'package:almadalla/screens/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../main.dart';

class SessionExpiredException implements Exception {
  String cause;
  SessionExpiredException(this.cause);
  Future<void> showDialogBox() async {
    await /*showDialog(
      barrierDismissible: false,
      context: navigatorKey
          .currentContext!, //navigatorKey.currentState!.overlay!.context,
      builder: (context) => new AlertDialog(
        title: Text("Session expired. Please login again."),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () => {
              Navigator.of(
                navigatorKey.currentContext!,
              ).popUntil((route) => route.isFirst)
            },
          ),
        ],
      ),
    );*/

    showDialog(
        barrierDismissible: false,
        // useRootNavigator: false,
        context: navigatorKey
          .currentContext!,
        builder: (BuildContext context) {
          // return object of type AlertDialog

          var messageText = Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text("Session expired. Please login again.",
                style: new TextStyle(
                  color: Colors.black87,
                  fontSize: 15.0,
                  //fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.left),
          );
          var cupertinoAlertDialog = CupertinoAlertDialog(
              title: /*new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Icon(
                    Icons.sentiment_very_dissatisfied,
                    color: Colors.red,
                    size: 50,
                  ),*/
              new Text(" Attention !",
                  style: new TextStyle(
                      color: Colors.black87,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
              //],
              //),
              content: messageText, //PriceCheckerScreen(),
              actions: <Widget>[
                new CupertinoDialogAction(
                    child: Text('OK',
                        style: new TextStyle(
                          color: Colors.black87,
                          fontSize: 15.0,
                          //fontWeight: FontWeight.bold
                        )),
                    isDefaultAction: true,
                    onPressed: () {
                     Navigator.of(
                navigatorKey.currentContext!,
              ).popUntil((route) => route.isFirst);
                    })
              ]);

          return  cupertinoAlertDialog;
        });
  }
}

class BadResponseException implements Exception {
  String cause;
  BadResponseException(this.cause);
  Future<void> showDialogBox() async {
    await 
    showDialog(
        barrierDismissible: false,
        // useRootNavigator: false,
        context: navigatorKey
          .currentContext!,
        builder: (BuildContext context) {
          // return object of type AlertDialog

          var messageText = Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text("Error in response. Please try again later.",
                style: new TextStyle(
                  color: Colors.black87,
                  fontSize: 15.0,
                  //fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.left),
          );
          var cupertinoAlertDialog = CupertinoAlertDialog(
              title: /*new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Icon(
                    Icons.sentiment_very_dissatisfied,
                    color: Colors.red,
                    size: 50,
                  ),*/
              new Text(" Attention !",
                  style: new TextStyle(
                      color: Colors.black87,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
              //],
              //),
              content: messageText, //PriceCheckerScreen(),
              actions: <Widget>[
                new CupertinoDialogAction(
                    child: Text('OK',
                        style: new TextStyle(
                          color: Colors.black87,
                          fontSize: 15.0,
                          //fontWeight: FontWeight.bold
                        )),
                    isDefaultAction: true,
                    onPressed: () {                    
                      Navigator.pop(context);
                      /*Navigator.of(
                navigatorKey.currentContext!,
              ).popUntil((route) => route.isFirst);*/
                    })
              ]);

          return  cupertinoAlertDialog;
        });
  }
}

class UnauthorisedException {
  String message;
  UnauthorisedException(this.message);
  String toString() {
    return "$message";
  }
}

class BadRequestException {
  String message;
  BadRequestException(this.message);
  String toString() {
    return "$message";
  }
}


  //  sessionCheckingMessage(context) {
  //   showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //               content: Text("Session Expired"),
  //               actions: <Widget>[
  //                 TextButton(
  //                   child: Text("ok"),
  //                   onPressed: () => {Navigator.push(
  //                   context,
  //                   new MaterialPageRoute(
  //                   builder: (context) => new LoginPage(title: '',)))},
  //                 ),
  //               ] );
  //         });
  //
  // }
