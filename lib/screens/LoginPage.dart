import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/models/AlMadallaMemberModel.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/UserProfile.dart';
import 'package:almadalla/models/UserSettingsBloc.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/screens/ForgotUserNameScreen.dart';
import 'package:almadalla/screens/LanguageBloc.dart';
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

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoginProgress = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String errorMessageUserName = "";
  String errorMessagePassword = "";
  bool value = false;
  UserSettingsBloc? userSettingsBloc;
  bool checkboxValue = false;
  LanguageBloc? bloc;
  bool _checkbox = false;
  Future<void> _onLoginClicked(
      context, UserSettingsBloc? userSettingsBloc) async {
    setState(() {
      isLoginProgress = true;
    });

    String username = _usernameController.text;
    String password = _passwordController.text;

    LoginData? loginData = await RestDatasource().login(username, password);
    userSettingsBloc!.setLoginData(loginData);

    if (loginData != null &&
        loginData.accessToken != null &&
        loginData.accessToken?.trim() != "") {
      UserProfile? userProfile =
          await RestDatasource().getUserProfile(loginData);

      print("User profile is ---------> $userProfile");
      userSettingsBloc.setUserProfile(userProfile);

      // Always check for error message in all API calls
      if (userProfile != null && userProfile.message == null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", loginData.accessToken!);
        prefs.setString("name", userProfile.name!);
        if (_checkbox) {
          prefs.setString("username", _usernameController.text);
          prefs.setString("password", _passwordController.text);
          prefs.setBool("checkbox", _checkbox);
        }
        setState(() {
          isLoginProgress = false;
        });

        //Set One Signal Data to API @Harris
        await RestDatasource()
            .savePushNotificationRegistrationDetails(loginData);

        Navigator.of(context)
            .push(
          MaterialPageRoute(builder: (_) => DashBoardPage(title: 'Dashboard')),
        )
            .then((value) {
          print("Login page force rfresh called ......>>");
          setState(() {});
        });
      } else {
        setState(() {
          isLoginProgress = false;
        });
        //"Show Error Message userProfile.message"
        SnackBar userProfileErrorMessage =
            SnackBar(content: new Text(userProfile!.message.toString()));
        ScaffoldMessenger.of(context).showSnackBar(userProfileErrorMessage);
      }
    } else {
      print("Login failed...");
      setState(() {
        isLoginProgress = false;
      });
      //"Show Error Message loginData.errorDescription"
      SnackBar loginFailed =
          SnackBar(content: new Text(loginData!.errorDescription.toString()));
      ScaffoldMessenger.of(context).showSnackBar(loginFailed);
    }
  }

  void _onResetPassword(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ResetPasswordPage(title: '')),
    );
  }

  void initState() {
    final newVersion = NewVersion(
      //iOSId: 'com.almadallaGroup.Almadalla%26timestamp%3D${DateTime.now().millisecondsSinceEpoch}',
      iOSId: 'com.almadallaGroup.Almadalla',
      //iOSId: 'com.almadallaGroup.Almadalla',
      androidId: 'com.almadallah.almadallah',
    );
    advancedStatusCheck(newVersion);

    _checkLoginStatus();
    super.initState();
  }

  Future _checkLoginStatus() async {
    SharedPreferences prefrences = await SharedPreferences.getInstance();
    prefrences.remove("token");
    String? username = prefrences.getString('username');
    String? password = prefrences.getString('password');
    checkboxValue = (prefrences.getBool('checkbox') != null
        ? prefrences.getBool('checkbox')
        : false)!;
    print("checkboxValue$checkboxValue");

    if (username != null) {
      _usernameController.text = username;
      // _passwordController.text=password;
    }
    if (password != null) {
      _passwordController.text = password;
    }
    setState(() {
      _checkbox = checkboxValue;
    });
    prefrences.remove("checkbox");
    prefrences.remove("username");
    prefrences.remove("password");
  }

  basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  advancedStatusCheck(NewVersion newVersion) async {
    final status = 
    await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint('status.localVersion ----- > ${status.localVersion}');
      debugPrint('status.storeVersion ------> ${status.storeVersion}');
      debugPrint('status.canUpdate ------> ${status.canUpdate}');
      try {
        if (status.localVersion != status.storeVersion &&
            (double.parse(status.storeVersion) >
                double.parse(status.localVersion))) {
          debugPrint(status.releaseNotes);
          debugPrint(status.appStoreLink);
          debugPrint('status.localVersion ----- > ${status.localVersion}');
          debugPrint('status.storeVersion ------> ${status.storeVersion}');
          debugPrint(
              'status.canUpdate ---------> ${status.canUpdate.toString()}');
          newVersion.showUpdateDialog(
            // allowDismissal: false,
            context: context,
            versionStatus: status,
            dialogTitle: 'Update Available',
            dialogText:
                'You can now update this app from ${status.localVersion} to ${status.storeVersion}',
          );
        } else {
          debugPrint('No UPDATEEEEEEEEE');
        }
      } on Exception catch (exception) {
        debugPrint('exception-----> ${exception.toString()}');
      } catch (error) {
        debugPrint('error-----> ${error.toString()}');
      }
    }
  }

  _makingPhoneCall() async {
    const url = 'tel:80043444';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    userSettingsBloc = Provider.of<UserSettingsBloc>(context, listen: false);
    bloc = Provider.of<LanguageBloc>(context);
    int? val = bloc!.getLanguage();
    if (LocaleKeys.language.tr() == "arabic") {
      value = true;
      print("arabic");
    } else {
      value = false;
    }

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
            drawer: CustomDrawer(),
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
                              Image.asset(
                                'assets/logo.png',
                                width: 100.0,
                                height: 100.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                    top: 10.0,
                                    bottom: 5.0),
                                child: new TextFormField(
                                  controller: _usernameController,
                                  style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                                  decoration: new InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    // border: new OutlineInputBorder(
                                    //   borderRadius: const BorderRadius.all(
                                    //     const Radius.circular(0.0),
                                    //   ),
                                    //   borderSide: new BorderSide(
                                    //     color:Colors.white,
                                    //     width: 1.0,
                                    //   ),),
                                    focusedBorder: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(5.0),
                                      ),
                                      borderSide: new BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                    enabledBorder: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(5.0),
                                      ),
                                      borderSide: new BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                    //contentPadding: new EdgeInsets.symmetric(vertical: 20.0,),
                                    hintText: LocaleKeys.name.tr(),
                                    hintStyle: TextStyle(
                                        fontSize: 18.0, color: Colors.black87),
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                              Align(
                                  alignment: value == true
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0,
                                        right: 12.0,
                                        top: 2.0,
                                        bottom: 3.0),
                                    child: Text(
                                      errorMessageUserName,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.red),
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                    top: 5.0,
                                    bottom: 5.0),
                                child: new TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                                  decoration: new InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    focusedBorder: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(5.0),
                                      ),
                                      borderSide: new BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                    enabledBorder: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(5.0),
                                      ),
                                      borderSide: new BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                    hintText: LocaleKeys.password.tr(),
                                    hintStyle: TextStyle(
                                        fontSize: 18.0, color: Colors.black87),
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                              Align(
                                  alignment: value == true
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0,
                                        right: 12.0,
                                        top: 2.0,
                                        bottom: 3.0),
                                    child: Text(
                                      errorMessagePassword,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.red),
                                    ),
                                  )),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _checkbox,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _checkbox = value!;
                                      });
                                    },
                                  ),
                                  Text(LocaleKeys.remember_me.tr()),
                                ],
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          _onResetPassword(context);
                                        },
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        child: Container(
                                          width: 150,
                                          margin: const EdgeInsets.only(
                                              top: 5.0,
                                              left: 10.0,
                                              right: 10.0),
                                          child: Center(
                                            child: Text(
                                              LocaleKeys.forgot_password.tr(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        )),
                                    InkWell(
                                        onTap: () async {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    ForgotUserNamePage(
                                                        title: '')),
                                          );
                                        },
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        child: Container(
                                          width: 150,
                                          margin: const EdgeInsets.only(
                                              top: 5.0,
                                              left: 10.0,
                                              right: 10.0),
                                          child: Center(
                                            child: Text(
                                              LocaleKeys.forgot_username.tr(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        )),
                                  ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: () async {
                                        if (!isLoginProgress) {
                                          if (((_usernameController
                                                  .text.isNotEmpty) &&
                                              (_passwordController
                                                  .text.isNotEmpty))) {
                                            _onLoginClicked(
                                                context, userSettingsBloc);
                                          } else {
                                            if (_usernameController
                                                .text.isEmpty) {
                                              setState(() {
                                                errorMessageUserName =
                                                    LocaleKeys.username_required
                                                        .tr();
                                              });
                                            } else {
                                              setState(() {
                                                errorMessageUserName = "";
                                              });
                                            }
                                            if (_passwordController
                                                .text.isEmpty) {
                                              setState(() {
                                                errorMessagePassword =
                                                    LocaleKeys.password_required
                                                        .tr();
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
                                        width: 150,
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0xFFb7956c),
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          color: Color(0xFFb7956c),
                                        ),
                                        margin: const EdgeInsets.only(
                                            top: 20.0, left: 10.0, right: 10.0),
                                        child: Center(
                                          child: Text(
                                            LocaleKeys.log_in.tr(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )),
                                  isLoginProgress
                                      ? Center(
                                          child: Container(
                                              width: 10,
                                              margin: const EdgeInsets.only(
                                                  top: 20.0),
                                              child: Center(
                                                  child:
                                                      CupertinoActivityIndicator())))
                                      : Container(
                                          width: 10,
                                        )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                    top: 15.0,
                                    bottom: 5.0),
                                child: InkWell(
                                    onTap: () async {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                SignUpPage(title: '')),
                                      );
                                    },
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
                                          LocaleKeys.not_registered.tr(),
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Color(0xFFb7956c)),
                                        )),
                                      ),
                                    )),
                              ),
                              // WebPush to new window Starts
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                    top: 5.0,
                                    bottom: 5.0),
                                child: InkWell(
                                    onTap: () async {
                                      // Navigator.of(context).push(
                                      //   MaterialPageRoute(
                                      //       builder: (_) =>
                                      //           SignUpPage(title: '')),
                                      // );
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => webpage()));
                                    },
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
                                          'Login To Insurance',
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Color(0xFFb7956c)),
                                        )),
                                      ),
                                    )),
                              ),
                              // WebPush to new windows Ends
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                    top: 5.0,
                                    bottom: 5.0),
                                child: Container(
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      onTap: () {
                                        //  launch("tel:80043444");
                                        _makingPhoneCall();
                                      },
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
                                          LocaleKeys.contact_call_centre.tr(),
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Color(0xFFb7956c)),
                                        )),
                                      ),
                                    )),
                              ),
                            ],
                          ))))),
            ),
          )
        ]));
  }
}
