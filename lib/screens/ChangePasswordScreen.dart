import 'package:almadalla/Util/Utils.dart';
import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/customwidgets/CustomDrawer.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/UserSettingsBloc.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/screens/LanguageBloc.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'LoginPage.dart';
import 'ProfileScreen.dart';
import 'SettingsScreen.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage({Key? key, required this.title, required this.loginData})
      : super(key: key);

  final String title;
  final LoginData? loginData;

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  void _onSettingEnd(context) {
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SettingsPage(title: '')),
    );*/
    Navigator.of(context).pop();
  }

  bool isLoginProgress = false;
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String errorMessagePassword = "";
  UserSettingsBloc? userSettingsBloc;
  bool value = false;
  LanguageBloc? bloc;
  Future<void> _onSubmitClicked() async {
    setState(() {
      isLoginProgress = true;
    });
    String password = _newPasswordController.text.isNotEmpty
        ? _newPasswordController.text
        : "";
    String? response =
        await RestDatasource().updatePassword(widget.loginData, password);
    if ((response != null && response.isNotEmpty) && response == "success") {
      setState(() {
        isLoginProgress = false;
      });
      /*SnackBar successMessage = SnackBar(
          content: new Text("Your Password has been successfully changed"));
      ScaffoldMessenger.of(context).showSnackBar(successMessage);*/

      showDialog(
          barrierDismissible: false,
          // useRootNavigator: false,
          context: navigatorKey.currentContext!,
          builder: (BuildContext context) {
            // return object of type AlertDialog

            var messageText = Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                  "Your Password has been successfully changed. Please login again with new password.",
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
                      child: Text('OK',
                          style: new TextStyle(
                            color: Colors.black87,
                            fontSize: 15.0,
                            //fontWeight: FontWeight.bold
                          )),
                      isDefaultAction: true,
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        //prefs.setString("password", "");
                        await prefs.remove("password");

                        Navigator.of(
                          navigatorKey.currentContext!,
                        ).popUntil((route) => route.isFirst);
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    new LoginPage(title: '')));
                      })
                ]);

            return cupertinoAlertDialog;
          });
    } else {
      setState(() {
        isLoginProgress = false;
      });
      String? msg = response;
      String? finalString = "";
      if (response!.contains(',')) {
        String regex = ",";
        String result = response.replaceAll(regex, "");
        List<String> values = result.split(" ");
        print("values$values");
        for (int i = 0; i < values.length; i++) {
          finalString = finalString! + " " + values[i].tr();
        }
        print("finalString$finalString");
        //   String first =  result.split(" ").first;
        //   print("first$first");
        //    String last=  result.split(" ").last;
        //   print("last$last");
        //   String convertFirst=first.tr();
        //  String convertLast=  last.tr();
        //
        // String finalString = convertFirst + " ," + convertLast;

        SnackBar changePasswordErrorMessage =
            SnackBar(content: new Text(finalString!));
        ScaffoldMessenger.of(context).showSnackBar(changePasswordErrorMessage);
      } else {
        String errorMessage = response.tr();
        print("msg$msg");
        SnackBar changePasswordErrorMessage =
            SnackBar(content: new Text(errorMessage));
        ScaffoldMessenger.of(context).showSnackBar(changePasswordErrorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    userSettingsBloc = Provider.of<UserSettingsBloc>(context, listen: false);
    bloc = Provider.of<LanguageBloc>(context);
    int? val = bloc!.getLanguage();
    if (LocaleKeys.language.tr() == "arabic") {
      value = true;
    } else {
      value = false;
    }
    return Scaffold(
        backgroundColor: Color(0xFFeeede7),
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Color(0xFFeeede7),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black87,
            onPressed: () {
              _onSettingEnd(context);
            },
          ),
        ),
        body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                // borderRadius: BorderRadius.all(Radius.circular(100.0)),
                image: DecorationImage(
                  image: AssetImage("assets/login.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      LocaleKeys.change_password.tr(),
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 5.0, top: 5.0, bottom: 5.0),
                    margin: const EdgeInsets.only(
                        top: 12.0, left: 15, right: 15.0, bottom: 10.0),
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        border: new Border.all(
                          color: Colors.transparent,
                        ),
                        borderRadius: new BorderRadius.all(Radius.circular(5.0))
                        // color: Colors.white12,
                        ),
                    alignment: FractionalOffset.center,
                    child: new TextFormField(
                      controller: _newPasswordController,
                      style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText: LocaleKeys.new_password.tr(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Align(
                      alignment: value == true
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, top: 2.0, bottom: 3.0),
                        child: Text(
                          errorMessagePassword,
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      )),
                  new Container(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 5.0, top: 5.0, bottom: 5.0),
                    margin: const EdgeInsets.only(
                        top: 2.0, left: 15, right: 15.0, bottom: 10.0),
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        border: new Border.all(
                          color: Colors.transparent,
                        ),
                        borderRadius: new BorderRadius.all(Radius.circular(5.0))
                        // color: Colors.white12,
                        ),
                    alignment: FractionalOffset.center,
                    child: new TextFormField(
                      controller: _confirmPasswordController,
                      style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText: LocaleKeys.confirm_password.tr(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () async {
                              if (!isLoginProgress) {
                                if (((_newPasswordController
                                    .text.isNotEmpty))) {
                                  if (_newPasswordController.text ==
                                      _confirmPasswordController.text) {
                                    _onSubmitClicked();
                                  } else {
                                    Utils.showDialogGeneralMessage(
                                        "Please Enter correct password ",
                                        context,
                                        false);
                                  }
                                } else {
                                  if (_newPasswordController.text.isEmpty) {
                                    setState(() {
                                      errorMessagePassword =
                                          LocaleKeys.password_required.tr();
                                    });
                                  } else {
                                    setState(() {
                                      errorMessagePassword = "";
                                    });
                                  }
                                }
                              }
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            child: Container(
                              width: 130,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFFb89669),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color(0xFFb89669),
                              ),
                              margin: const EdgeInsets.only(
                                  top: 20.0, left: 10.0, right: 10.0),
                              child: Center(
                                child: Text(
                                  LocaleKeys.submit.tr(),
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            )),
                        isLoginProgress
                            ? Center(
                                child: Container(
                                    width: 10,
                                    margin: const EdgeInsets.only(top: 20.0),
                                    child: Center(
                                        child: CupertinoActivityIndicator())))
                            : Container(
                                width: 10,
                              )
                      ]),
                ],
              ),
            )));
  }
}
