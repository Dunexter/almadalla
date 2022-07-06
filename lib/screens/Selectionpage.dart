import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/models/AlMadallaMemberModel.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/UserProfile.dart';
import 'package:almadalla/models/UserSettingsBloc.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/screens/ForgotUserNameScreen.dart';
import 'package:almadalla/screens/LanguageBloc.dart';
import 'package:almadalla/screens/LoginPage.dart';
import 'package:almadalla/screens/ResetPasswordScreen.dart';
import 'package:almadalla/screens/SignUpScreen.dart';
import 'package:almadalla/screens/webpage.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../customwidgets/CustomDrawer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:delayed_display/delayed_display.dart';

class Selectionpage extends StatefulWidget {
  Selectionpage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SelectionpageState createState() => _SelectionpageState();
}

class _SelectionpageState extends State<Selectionpage> {
  // Save page start
  bool pageReady = false;

  _checkPages() async {
    SharedPreferences local = await SharedPreferences.getInstance();
    if (local.getString('page-selected') != null) {
      if (local.getString('page-selected') == "1") {
        //navigate to Loginpage

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>  webpage()),
        );
      } else {
        //Navigate to Home
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage(
                    title: '',
                  )),
        );
      }
    } else {
      setState(() {
        pageReady = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPages();
  }

  savePage(String type) async {
    if (type == "1") {
      SharedPreferences local = await SharedPreferences.getInstance();
      local.setString('page-selected', type);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => webpage()),
      );
    } else {
      SharedPreferences local = await SharedPreferences.getInstance();
      local.setString('page-selected', type);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(
                    title: '',
                  )),
      );
    }
  }

//10-06-2022

  // Save Page Ends

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Stack(children: <Widget>[
          Scaffold(
            backgroundColor: Color(0xFFeeede7),
            appBar: AppBar(
              title: Text(widget.title),
              backgroundColor: Color(0xFFeeede7),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
            ),
            //drawer: CustomDrawer(),
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
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(50),
                  //   // borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  //   image: DecorationImage(
                  //     image: AssetImage("assets/login.jpg"),
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  child: SingleChildScrollView(
                      child: Form(
                          key: _formKey,
                          child: Center(
                              child: Column(
                            children: [
                              DelayedDisplay(
                                delay: Duration(milliseconds: 1200),
                                slidingBeginOffset: const Offset(0.0, 0.0),
                                child: Image.asset(
                                  'assets/logo.png',
                                  width: 100.0,
                                  height: 100.0,
                                ),
                              ),
                              DelayedDisplay(
                                delay: Duration(milliseconds: 1200),
                                slidingBeginOffset: const Offset(0.0, 0.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      top: 150.0,
                                      bottom: 5.0),
                                  child: InkWell(
                                      onTap: () {
                                        savePage("1");
                                      },
                                      // async {
                                      //   Navigator.of(context).push(
                                      //     MaterialPageRoute(
                                      //         builder: (_) =>
                                      //             LoginPage(title: '')),
                                      //   );
                                      // },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: 300,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(0.0),
                                              border: Border.all(
                                                  width: 2,
                                                  color: Color(0xFFb7956c),
                                                  style: BorderStyle.solid)),
                                          child: Center(
                                              child: Text(
                                            ('Insurance'),
                                            //LocaleKeys.not_registered.tr(),
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Color(0xFFb7956c)),
                                          )),
                                        ),
                                      )),
                                ),
                              ),
                              // WebPush to new window Starts
                              DelayedDisplay(
                                delay: Duration(milliseconds: 1200),
                                slidingBeginOffset: const Offset(0.0, 0.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      top: 25.0,
                                      bottom: 5.0),
                                  child: InkWell(
                                      onTap: () {
                                        savePage("2");
                                      },
                                      // async {
                                      //   // Navigator.of(context).push(
                                      //   //   MaterialPageRoute(
                                      //   //       builder: (_) =>
                                      //   //           SignUpPage(title: '')),
                                      //   // );
                                      //   Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //           builder: (context) => webpage()));
                                      // },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: 300,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(0.0),
                                              border: Border.all(
                                                  width: 2,
                                                  color: Color(0xFFb7956c),
                                                  style: BorderStyle.solid)),
                                          child: Center(
                                              child: Text(
                                            'Self Funded',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Color(0xFFb7956c)),
                                          )),
                                        ),
                                      )),
                                ),
                              ),
                              // WebPush to new windows Ends
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //       left: 10.0,
                              //       right: 10.0,
                              //       top: 5.0,
                              //       bottom: 5.0),
                              //   child: Container(
                              //       alignment: Alignment.center,
                              //       child: InkWell(
                              //         onTap: () {
                              //           //  launch("tel:80043444");
                              //           _makingPhoneCall();
                              //         },
                              //         child: Container(
                              //           width: 300,
                              //           height: 50,
                              //           decoration: BoxDecoration(
                              //               borderRadius:
                              //                   BorderRadius.circular(0.0),
                              //               border: Border.all(
                              //                   width: 2,
                              //                   color: Color(0xFFb7956c),
                              //                   style: BorderStyle.solid)),
                              //           child: Center(
                              //               child: Text(
                              //             LocaleKeys.contact_call_centre.tr(),
                              //             style: TextStyle(
                              //                 fontSize: 15.0,
                              //                 color: Color(0xFFb7956c)),
                              //           )),
                              //         ),
                              //       )),
                              // ),
                            ],
                          ))))),
            ),
          )
        ]));
  }
}
