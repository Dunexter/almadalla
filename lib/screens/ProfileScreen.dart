import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/customwidgets/CustomDrawer.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/UserProfile.dart';
import 'package:almadalla/models/UserSettingsBloc.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/screens/LanguageBloc.dart';
import 'package:almadalla/screens/SettingsScreen.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key, required this.title,required this.loginData}) : super(key: key);

  final String title;
  final LoginData? loginData;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _onSettingEnd(context) {
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SettingsPage(title: '')),
    );*/
    Navigator.of(context).pop();
  }

  bool isLoginProgress = false;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  UserSettingsBloc? userSettingsBloc;
  bool value = false;
  LanguageBloc? bloc;
  String? name;
  String errorMessageUserName = "";
  String errorMessageEmail = "";
  Future<void> _onUpdateClicked() async {
    setState(() {
      isLoginProgress = true;
    });
    UserProfile? userProfile;
    userProfile = new UserProfile();
    userProfile.name =
        _usernameController.text.isNotEmpty ? _usernameController.text : "";
    print(" userProfile!. name${userProfile.name}");
    userProfile.emailID =
        _emailController.text.isNotEmpty ? _emailController.text : "";
    print(" userProfile!. emailID${userProfile.emailID}");
    userProfile.mobile =
        _mobileController.text.isNotEmpty ? _mobileController.text : "";
    print(" userProfile!. mobile${userProfile.mobile}");
    String? response =
        await RestDatasource().updateUserProfile(widget.loginData, userProfile);
    if (response != null && response.isNotEmpty) {
      setState(() {
        isLoginProgress = false;
      });
      userSettingsBloc!.setUserProfile(userProfile);
      SnackBar successMessage =
          SnackBar(content: new Text(LocaleKeys.updated_successfully.tr(),));
      ScaffoldMessenger.of(context).showSnackBar(successMessage);
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

        SnackBar userProfileErrorMessage =
        SnackBar(content: new Text(finalString!));
        ScaffoldMessenger.of(context).showSnackBar(userProfileErrorMessage);
      } else {
        String errorMessage = response.tr();
        print("msg$msg");
        SnackBar userProfileErrorMessage = SnackBar(content: new Text(errorMessage));
        ScaffoldMessenger.of(context).showSnackBar(userProfileErrorMessage);
      }
    }
  }

  UserProfile? userProfile;

  initState() {
    _getUserProfile();
    super.initState();
  }

  Future<UserProfile?> _getUserProfile() async {
    userProfile = await RestDatasource().getUserProfile(widget.loginData!);
    if (userProfile!.name != null) {
      _usernameController.text = userProfile!.name!;
    } else {
      _usernameController.text = "";
    }
    if (userProfile!.emailID != null) {
      _emailController.text = userProfile!.emailID!;
    } else {
      _emailController.text = "";
    }
    if (userProfile!.mobile != null) {
      _mobileController.text = userProfile!.mobile!;
    } else {
      _mobileController.text = "";
    }
    return userProfile;
  }

  @override
  Widget build(BuildContext context) {
    userSettingsBloc = Provider.of<UserSettingsBloc>(context, listen: false);
    bloc = Provider.of<LanguageBloc>(context);
    int? val=bloc!.getLanguage() ;
    if(LocaleKeys.language.tr()=="arabic"){
      value =true;
    }else{
      value =false;
    }
    // _usernameController.text=name!;
  //  _emailController.text=email!;
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

            // leading: Icon(Icons.arrow_back_ios,color: Colors.white,
            // ),
          ),
        ),
        // drawer: CustomDrawer(),
        body: GestureDetector(
    onTap: () {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
    }},
       child: SingleChildScrollView(
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
                  LocaleKeys.profile.tr(),
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Align(
                alignment: value == true? Alignment.topRight:Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.only(top: 15.0, left: 12.0,right: 12.0),
                  child: Text(
                    LocaleKeys.name.tr(),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              new Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                margin: const EdgeInsets.only(
                    top: 5.0, left: 15, right: 15.0, bottom: 10.0),
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
                  controller:_usernameController,
                  // onChanged: (text) {
                  //   print('Firstyy text field: $text');
                  //   nme=text;
                  // },
                  style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                  ),
                  //  keyboardType: TextInputType.emailAddress,
                ),
              ),
                  Align(
                      alignment: value == true? Alignment.topRight:Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, top: 2.0, bottom: 3.0),
                        child: Text(
                          errorMessageUserName,
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      )),
                  Align(
                    alignment: value == true? Alignment.topRight:Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.only(top: 0.0, left: 12.0,right: 12.0),
                  child: Text(
                    LocaleKeys.email_address.tr(),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              new Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                margin: const EdgeInsets.only(
                    top: 5.0, left: 15, right: 15.0, bottom: 10.0),
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
                    controller: _emailController,
                  // onChanged: (text) {
                  //   print('First text field: $text');
                  //   email=text;
                  // },
                  style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                  ),
                  Align(
                      alignment: value == true? Alignment.topRight:Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, top: 2.0, bottom: 3.0),
                        child: Text(
                          errorMessageEmail,
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      )),
                  Align(
                    alignment: value == true? Alignment.topRight:Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.only(top: 0.0, left: 12.0,right: 12.0),
                  child: Text(
                    LocaleKeys.mobile_number.tr(),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              new Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                margin: const EdgeInsets.only(
                    top: 5.0, left: 15, right: 15.0, bottom: 10.0),
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
                  enabled: false,
                  controller: _mobileController,
                  style: TextStyle(color: Colors.grey),
//                                initialValue: "user@ionicfirebaseapp.com",
                  decoration: new InputDecoration(
                    border: InputBorder.none,
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
                                if (((_usernameController.text.isNotEmpty) &&
                                    (_emailController.text.isNotEmpty))) {
                                  _onUpdateClicked();
                                } else {
                                  if (_usernameController.text.isEmpty) {
                                    setState(() {
                                      errorMessageUserName =
                                          LocaleKeys.username_required.tr();
                                    });
                                  } else {
                                    setState(() {
                                      errorMessageUserName = "";
                                    });
                                  }
                                  if (_emailController.text.isEmpty) {
                                    setState(() {
                                      errorMessageEmail =LocaleKeys.email_required.tr();
                                    });
                                  } else {
                                    setState(() {
                                      errorMessageEmail = "";
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
                                  LocaleKeys.update.tr(),
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
                      ])
            ],
          ),
        ))));
  }
}
