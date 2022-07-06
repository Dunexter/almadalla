import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

class Utils {
  static String getDateFormatted(String? unformattedDate) {
    //final DateFormat formatter = DateFormat('dd-MMM-yyyy');
    final DateFormat formatter = DateFormat.yMMMd();
    final String formatted = unformattedDate != null
        ? formatter.format(DateTime.parse(unformattedDate))
        : 'No data';

    return formatted;
  }

  static Future<String> getDateFormattedArabic(String? unformattedDate) async {
    await initializeDateFormatting("en_US", null);
    var date = DateTime.parse(unformattedDate!);
    var formatter = DateFormat.yMMMd();
    //final DateFormat formatter = DateFormat('dd-MMM-yyyy',"en_US");
    print(formatter.locale);
    String formatted = formatter.format(date);
    print(formatted);

    return formatted.toString();
  }

  static Widget getFixedTopAlert(Widget childWidget) {
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.center,
          child: Container(
            height: 380,
            //color: Colors.white,
            child: SizedBox.expand(child: childWidget),
            margin: EdgeInsets.only(top: 30, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ));
  }

  static showDialogGeneralMessage(String message, context, bool fixedTop) {
    showDialog(
        barrierDismissible: false,
        // useRootNavigator: false,
        context: context,
        builder: (BuildContext context) {
          // return object of type AlertDialog

          var messageText = Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(message,
                style: new TextStyle(
                  color: Colors.black87,
                  fontSize: 15.0,
                  //fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.left),
          );
          var cupertinoAlertDialog = CupertinoAlertDialog(
              title:
                  /*new Row(
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
                    child: Text('Dismiss',
                        style: new TextStyle(
                          color: Colors.black87,
                          fontSize: 15.0,
                          //fontWeight: FontWeight.bold
                        )),
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);

          return (fixedTop)
              ? getFixedTopAlert(cupertinoAlertDialog)
              : cupertinoAlertDialog;
        });
  }

  static String getLanguage() {
    return LocaleKeys.language.tr();
  }
}
