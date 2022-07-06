import 'package:almadalla/customwidgets/CustomDrawer.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/UserSettingsBloc.dart';
import 'package:almadalla/screens/ChangePasswordScreen.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/screens/PushNotificationScreen.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/material.dart';

import 'ProfileScreen.dart';
import 'package:easy_localization/easy_localization.dart';
class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key, required this.title,required this.loginData}) : super(key: key);

  final String title;
  final LoginData? loginData;
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UserSettingsBloc? userSettingsBloc;
  void _onProfileEnd(context, LoginData? loginData) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProfilePage(title: '',loginData: loginData)),
    );
  }

  void _onChangePasswordEnd(context) {
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChangePasswordPage(title: '')),
    );*/
    Navigator.of(context).pop();
  }

  void _onChangePasswordTap(context,LoginData? loginData) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChangePasswordPage(title: '',loginData: loginData)),
    );
    
  }
  void _onChangeNotificationTap(context,LoginData? loginData) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PushNotificationScreen(title: '',loginData: loginData)),
    );

  }
  @override
  Widget build(BuildContext context) {
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
                  _onChangePasswordEnd(context);
                })),
        //drawer: CustomDrawer(),
        body: Container(
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
               LocaleKeys.settings.tr(),
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              InkWell(
                  onTap: () async {
                    _onProfileEnd(context,widget.loginData);
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFb89669),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color(0xFFb89669),
                    ),
                    margin: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: Center(
                      child: Text(
                        LocaleKeys.profile.tr(),
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  )),
              InkWell(
                  onTap: () async {
                    _onChangePasswordTap(context,widget.loginData);
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFb89669),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color(0xFFb89669),
                    ),
                    margin: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: Center(
                      child: Text(
                        LocaleKeys.change_password.tr(),
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  )),

              InkWell(
                  onTap: () async {
                    _onChangeNotificationTap(context,widget.loginData);
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFb89669),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color(0xFFb89669),
                    ),
                    margin: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: Center(
                      child: Text(
                        LocaleKeys.push_notification.tr(),
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  )),
            ],
          ),
        ));
  }
}
