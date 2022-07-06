import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/customwidgets/CustomDrawer.dart';
import 'package:almadalla/models/UserSettingsBloc.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/screens/LanguageBloc.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'ProfileScreen.dart';
import 'SettingsScreen.dart';

class ForgotUserNamePage extends StatefulWidget {
  ForgotUserNamePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ForgotUserNamePageState createState() => _ForgotUserNamePageState();
}

class _ForgotUserNamePageState extends State<ForgotUserNamePage> {
  void _onResetPasswordBack(context) {
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SettingsPage(title: '')),
    );*/
    Navigator.of(context).pop();
  }
  String? _memberType;
  List<String> _member = [
    'Member'
  ];

  bool isLoginProgress = false;
  final _emiratesIdController =  TextEditingController();
  final _emailController = TextEditingController();
  String errorMessageEmiratesId = "";
  String errorMessageEmail = "";
  UserSettingsBloc? userSettingsBloc;
  bool value = false;
  LanguageBloc? bloc;

  Future<void> _onSubmitClicked() async {
    setState(() {
      isLoginProgress = true;
    });

    String email =
        _emailController.text.isNotEmpty ? _emailController.text : "";
    String emiratesId =
        _emiratesIdController.text.isNotEmpty ? _emiratesIdController.text : "";
    String? response = await RestDatasource().forgotUsername(email, emiratesId);
    if (response!.isNotEmpty && response == "success") {
      _emiratesIdController.clear();
      _emailController.clear();
      setState(() {
        isLoginProgress = false;
      });
      SnackBar successMessage = SnackBar(content: new Text("Username has been sent to your email.Please Check your email"));
      ScaffoldMessenger.of(context).showSnackBar(successMessage);
    } else {
      setState(() {
        isLoginProgress = false;
      });
      String? msg = response;
      String? finalString = "";
      if (response.contains(',')) {
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
        SnackBar forgotUsernameErrorMessage = SnackBar(content: new Text(errorMessage));
        ScaffoldMessenger.of(context).showSnackBar(forgotUsernameErrorMessage);
      }
    }
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
              _onResetPasswordBack(context);
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
            child:Container(
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
    child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  LocaleKeys.forgot_username.tr(),
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0,top:15,right: 15.0),child: Text(LocaleKeys.i_am.tr(),style: TextStyle(
                        fontSize: 15.0,

                        color: Colors.black
                    ),),),
                    new Container(
                      width: 270,
                      height: 50,
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 0.0,),
                      margin: const EdgeInsets.only(
                          top: 5.0, left: 15, right: 15.0, bottom: 5.0),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          border: new Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius:
                          new BorderRadius.all(Radius.circular(5.0))
                        // color: Colors.white12,
                      ),
                      alignment: FractionalOffset.center,
                      child: DropdownButtonFormField<dynamic>(
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                        ),
                        value: _memberType,
                        // hint: Text('-- Select Member --',
                        //     style: TextStyle(
                        //       color: Colors.black,
                        //     )),
                        hint: RichText(
                          text: TextSpan(
                              text: LocaleKeys.member.tr(),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                          ),
                        ),

                        // this is the magic
                        items: _member
                            .map<DropdownMenuItem<dynamic>>((dynamic value) {
                          return DropdownMenuItem<dynamic>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (dynamic value) {
                          setState(() {
                            print("Value$value");

                            _memberType = value;
                          });
                        },
                        // validator: (value) =>
                        //     value == null ? 'Please Select Country' : null,
                      ),
                    ),
                  ],
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
                child:_memberType== null || _memberType == "Member"? new TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '###-####-#######-#',
                      filter: {
                        "#": RegExp(r'[0-9]'),
                      },
                    ),
                  ],
                    controller: _emiratesIdController,
                  style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: LocaleKeys.emirates_number.tr(),
                  ),
                ):new TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '###-####-#######-#',
                      filter: {
                        "#": RegExp(r'[0-9]'),
                      },
                    ),
                  ],
                  controller: _emiratesIdController,
                  style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText:  LocaleKeys.registration_code.tr(),
                  ),
                ),
              ),
                  Align(
                      alignment: value == true? Alignment.topRight:Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, top: 2.0, bottom: 3.0),
                        child: Text(
                          errorMessageEmiratesId,
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
                  controller: _emailController,
                  style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText:LocaleKeys.email_address.tr(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
                  Align(alignment: value == true? Alignment.topRight:Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, top: 2.0, bottom: 3.0),
                        child: Text(
                          errorMessageEmail,
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      )),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                  onTap: () async {
                              if (!isLoginProgress) {
                                if (((_emiratesIdController.text.isNotEmpty) &&
                                    (_emailController.text.isNotEmpty))) {
                                  _onSubmitClicked();
                                } else {
                                  if (_emiratesIdController.text.isEmpty) {
                                    setState(() {
                                      errorMessageEmiratesId =
                                          LocaleKeys.emiratesId_required.tr();
                                    });
                                  } else {
                                    setState(() {
                                      errorMessageEmiratesId = "";
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
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color(0xFFb89669),
                    ),
                    margin: const EdgeInsets.only(
                        top: 20.0, left: 10.0, right: 10.0),
                    child: Center(
                      child: Text(
                        LocaleKeys.submit.tr(),
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
          ),)
        )));
  }
}
