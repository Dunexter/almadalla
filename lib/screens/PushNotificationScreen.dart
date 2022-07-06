import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/PushNotificationsRegistrationModel.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

class PushNotificationScreen extends StatefulWidget {
  PushNotificationScreen({Key? key, required this.title, this.loginData})
      : super(key: key);
  final String title;
  final LoginData? loginData;
  @override
  _PushNotificationScreenState createState() => _PushNotificationScreenState();
}

class _PushNotificationScreenState extends State<PushNotificationScreen> {
  void _onSettingEnd(context) {
    Navigator.of(context).pop();
  }

  bool value = false;
  bool isLoginProgress = false;
  final _emailController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  bool enabledNotification = true;
  String? email;
  String? sms;
  String? emailInitialValue;
  String? smsInitialValue;
  String errorMessageMobileNumber = "";
  String errorMessageEmail = "";
  bool isvalid = false;
  void initState() {
    _statusChecking();
    super.initState();
  }

  Future<void> _statusChecking() async {
    email = await PushNotificationsRegistrationModel.oneSignalGetEmailID();
    setState(() {
      emailInitialValue = email;
    });
    print("email$emailInitialValue");
    if (emailInitialValue != null) {
      _emailController.text = emailInitialValue!.trim();
    } else {
      _emailController.text = "";
    }
    sms = await PushNotificationsRegistrationModel.oneSignalGetSMSNumber();
    setState(() {
      smsInitialValue = sms;
    });
    print("smsNumber$smsInitialValue");

    if (smsInitialValue != null) {
      _mobileNumberController.text = smsInitialValue!.trim();
    } else {
      _mobileNumberController.text = "";
    }
    bool? status =
        await PushNotificationsRegistrationModel.oneSignalPushDisabledStatus();
    print("status$status");
    if (status == false) {
      enabledNotification = true;
    } else {
      enabledNotification = false;
    }
  }

  Future<void> _onUpdateClicked() async {
    setState(() {
      isLoginProgress = true;
    });
    String? emailId = _emailController.text;
    print("----emailId---$emailId");
    String? mobile = _mobileNumberController.text;
    print("----mobile---$mobile");
    print("----enabledNotification--$enabledNotification");

    try {
      if (emailId.trim() != "") {
        await PushNotificationsRegistrationModel.oneSignalSetEmail(emailId);
      }
      if (mobile.trim() != "") {
        await PushNotificationsRegistrationModel.oneSignalSetSMSNumber(mobile);
      }

      await PushNotificationsRegistrationModel.oneSignalDisablePush(
          !enabledNotification);

      bool? response = await RestDatasource()
          .savePushNotificationRegistrationDetails(widget.loginData!);
      if (response == true) {
        SnackBar submitClaimErrorMessage = SnackBar(
            content: new Text(
          "Updated Successfully",
        ));
        ScaffoldMessenger.of(context).showSnackBar(submitClaimErrorMessage);
      } else {
        SnackBar submitClaimErrorMessage = SnackBar(
            content: new Text(
          "Update fail. Please try again later.",
        ));
        ScaffoldMessenger.of(context).showSnackBar(submitClaimErrorMessage);
      }
    } on PlatformException catch (err) {
      SnackBar submitClaimErrorMessage = SnackBar(
          content: new Text(
        "An error occurred. Please try again later. Error : ${err.message}",
      ));
      ScaffoldMessenger.of(context).showSnackBar(submitClaimErrorMessage);
    } catch (err) {
      SnackBar submitClaimErrorMessage = SnackBar(
          content: new Text(
        "An error occurred. Please try again later. Error : ${err.toString()}",
      ));
      ScaffoldMessenger.of(context).showSnackBar(submitClaimErrorMessage);
    }

    setState(() {
      isLoginProgress = false;
    });
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
                      LocaleKeys.push_notification.tr(),
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12.0, right: 12, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(LocaleKeys.allow_notification.tr(),
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            )),
                        Transform.scale(
                          scale: 1.5,
                          child: Switch(
                            value: enabledNotification,
                            activeColor: Color(0xFFc5a56a), //Colors.green,//
                            inactiveTrackColor: Colors.grey,
                            onChanged: (bool value) {
                              setState(() {
                                enabledNotification = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*Align(
                    alignment:
                        value == true ? Alignment.topRight : Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 12.0, right: 12.0),
                      child: Text(
                        LocaleKeys.email.tr(),
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
                      style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 0.0, top: 2.0, bottom: 3.0),
                        child: Text(
                          errorMessageEmail,
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      )),*/
                  /*Align(
                    alignment:
                        value == true ? Alignment.topRight : Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 12.0, right: 12.0),
                      child: Text(
                        LocaleKeys.sms.tr(),
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
                      controller: _mobileNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9]"))
                      ],
                      style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),*/
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 0.0, top: 2.0, bottom: 3.0),
                        child: Text(
                          errorMessageMobileNumber,
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      )),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () async {
                              bool canUpdate = true;
                              if (!isLoginProgress) {
                                isvalid = EmailValidator.validate(
                                    _emailController.text);
                                if (emailInitialValue != null &&
                                    emailInitialValue!.trim() != "") {
                                  if (!isvalid) {
                                    canUpdate = false;
                                    setState(() {
                                      errorMessageEmail =
                                          "Enter a valid Email Address";
                                    });
                                  } else {
                                    setState(() {
                                      errorMessageEmail = "";
                                    });
                                  }
                                } else {
                                  print("----------------------------1");
                                  if (_emailController.text.trim() != "") {
                                    print("----------------------------2");
                                    if (!isvalid) {
                                      print("----------------------------3");
                                      canUpdate = false;
                                      setState(() {
                                        errorMessageEmail =
                                            "Enter a valid Email Address";
                                      });
                                    } else {
                                      setState(() {
                                        errorMessageEmail = "";
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      errorMessageEmail = "";
                                    });
                                  }
                                }
                                if (smsInitialValue != null &&
                                    smsInitialValue!.trim() != "") {
                                  if (!_mobileNumberController.text
                                          .startsWith("971") ||
                                      _mobileNumberController.text.length !=
                                          12) {
                                    canUpdate = false;
                                    setState(() {
                                      errorMessageMobileNumber =
                                          "Enter a valid Mobile Number. Mobile number should start with 971 and number of digits should be 12";
                                    });
                                  } else {
                                    setState(() {
                                      errorMessageMobileNumber = "";
                                    });
                                  }
                                } else {
                                  print("----------------------------A");
                                  if (_mobileNumberController.text.trim() !=
                                      "") {
                                    print("----------------------------B");
                                    if (!_mobileNumberController.text
                                            .startsWith("971") ||
                                        _mobileNumberController.text.length !=
                                            12) {
                                      print("----------------------------C");
                                      canUpdate = false;
                                      setState(() {
                                        errorMessageMobileNumber =
                                            "Enter a valid Mobile Number. Mobile number should start with 971 and number of digits should be 12";
                                      });
                                    } else {
                                      setState(() {
                                        errorMessageMobileNumber = "";
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      errorMessageMobileNumber = "";
                                    });
                                  }
                                }

                                if (canUpdate) {
                                  _onUpdateClicked();
                                }

                                /*if (_emailController.text.isNotEmpty &&
                                    _mobileNumberController.text.isNotEmpty) {
                                  if (isvalid) {
                                    setState(() {
                                      errorMessageEmail = "";
                                    });
                                    if (_mobileNumberController.text
                                            .startsWith("971") &&
                                        _mobileNumberController.text.length ==
                                            12) {
                                      setState(() {
                                        errorMessageMobileNumber = "";
                                      });
                                      _onUpdateClicked();
                                    } else {
                                      setState(() {
                                        errorMessageMobileNumber =
                                            "Enter a valid Mobile Number. Mobile number should start with 971 and number of digits should be 12";
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      errorMessageEmail =
                                          "Enter a valid Email Address";
                                    });
                                  }
                                } else {
                                  if (email == null && sms == null) {
                                    setState(() {
                                      isLoginProgress = true;
                                    });
                                    bool? response = await RestDatasource()
                                        .savePushNotificationRegistrationDetails(
                                            widget.loginData!);
                                    if (response == true) {
                                      setState(() {
                                        isLoginProgress = false;
                                      });
                                      SnackBar submitClaimErrorMessage =
                                          SnackBar(
                                              content: new Text(
                                        "Updated Successfully",
                                      ));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              submitClaimErrorMessage);
                                    }
                                  } else {
                                    if (isvalid) {
                                      setState(() {
                                        errorMessageEmail = "";
                                      });
                                    } else {
                                      if (_emailController.text.isEmpty) {
                                        setState(() {
                                          errorMessageEmail =
                                              LocaleKeys.email_required.tr();
                                        });
                                      } else {
                                        if (isvalid) {
                                          setState(() {
                                            errorMessageEmail = "";
                                          });
                                        } else {
                                          setState(() {
                                            errorMessageEmail =
                                                "Enter a valid Email Address";
                                          });
                                        }
                                        setState(() {
                                          errorMessageEmail =
                                              "Enter a valid Email Address";
                                        });
                                      }
                                    }

                                    if (_mobileNumberController.text.isEmpty) {
                                      setState(() {
                                        errorMessageMobileNumber = LocaleKeys
                                            .mobile_number_required
                                            .tr();
                                      });
                                    } else {
                                      setState(() {
                                        errorMessageMobileNumber = "";
                                      });
                                    }
                                  }
                                }*/
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
