import 'package:almadalla/Util/Utils.dart';
import 'package:almadalla/customwidgets/CustomDrawer.dart';

import 'package:almadalla/models/AlMadallaMemberModel.dart';
import 'package:almadalla/screens/ChangePasswordScreen.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ProfileScreen.dart';
import 'package:easy_localization/easy_localization.dart';

class MemberDataPage extends StatefulWidget {
  MemberDataPage(
      {Key? key, required this.title, required this.alMadallaCardFuture})
      : super(key: key);

  final String title;
  AlMadallaMemberModel? alMadallaCardFuture;
  @override
  _MemberDataPagePageState createState() => _MemberDataPagePageState();
}

class _MemberDataPagePageState extends State<MemberDataPage> {
  void _onChangeDetailsEnd(context) {
    Navigator.of(context).pop();
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
                  _onChangeDetailsEnd(context);
                })),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            image: DecorationImage(
              image: AssetImage("assets/login.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Center(
                child: Text(
                  LocaleKeys.member_details.tr(),
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
                  child: Container(
                      // width: MediaQuery.of(context).size.width,
                      //height: 100,
                      child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      child: Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFc5a56a),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                    ),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, top: 40, right: 15.0),
                                    child: Text(LocaleKeys.employee_iD.tr()),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, top: 30, bottom: 10),
                                          //child: Text( LocaleKeys.member_details.tr()),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, right: 15.0),
                                          child: Text(
                                            widget.alMadallaCardFuture != null
                                                ? widget.alMadallaCardFuture!
                                                        .employeeID ??
                                                    'No data'
                                                : 'No data',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  color: Color(0xFFc5a56a),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: new Divider(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: new Divider(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.49,
                                    color: Color(0xFFc5a56a),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, right: 15.0),
                                          child: Text(LocaleKeys.card_no.tr()),
                                        ),
                                      ],
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: Text(
                                    widget.alMadallaCardFuture != null
                                        ? widget.alMadallaCardFuture!.cardNo ??
                                            'No data'
                                        : 'No data',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.49,
                                color: Color(0xFFc5a56a),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: new Divider(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: new Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  color: Color(0xFFc5a56a),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Text(LocaleKeys.policy_no.tr()),
                                  ),
                                  // Text("Policy No"),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: Text(
                                          widget.alMadallaCardFuture != null
                                              ? widget.alMadallaCardFuture!
                                                      .policyNo ??
                                                  'No data'
                                              : 'No data',
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  color: Color(0xFFc5a56a),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: new Divider(
                                      color: Colors.white,
                                    ),
                                  )),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: new Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  color: Color(0xFFc5a56a),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Text(LocaleKeys.name_english.tr()),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 15.0),
                                      child: Text(
                                        widget.alMadallaCardFuture != null
                                            ? widget.alMadallaCardFuture!
                                                    .nameEnglish ??
                                                'No data'
                                            : 'No data',
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.49,
                                color: Color(0xFFc5a56a),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: new Divider(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: new Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  color: Color(0xFFc5a56a),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Text(LocaleKeys.name_arabic.tr()),
                                  ),
                                  //Text("Name in Arabic"),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 15.0),
                                      child: Text(
                                        widget.alMadallaCardFuture != null
                                            ? widget.alMadallaCardFuture!
                                                    .nameArabic ??
                                                'No data'
                                            : 'No data',
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.49,
                                color: Color(0xFFc5a56a),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15.0),
                                  child: new Divider(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: new Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  color: Color(0xFFc5a56a),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Text(LocaleKeys.gender.tr()),
                                  ),
                                  //Text("Gender"),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: Text(
                                          widget.alMadallaCardFuture != null
                                              ? widget.alMadallaCardFuture!
                                                      .gender ??
                                                  'No data'
                                              : 'No data',
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  color: Color(0xFFc5a56a),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: new Divider(
                                      color: Colors.white,
                                    ),
                                  )),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: new Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  color: Color(0xFFc5a56a),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Text(LocaleKeys.relationship.tr()),
                                  ),
                                  //Text("Relationship"),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: Text(
                                          widget.alMadallaCardFuture != null
                                              ? widget.alMadallaCardFuture!
                                                      .relationship ??
                                                  'No data'
                                              : 'No data',
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  color: Color(0xFFc5a56a),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: new Divider(
                                      color: Colors.white,
                                    ),
                                  )),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: new Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  // decoration: BoxDecoration(
                                  //   color: Color(0xFFc5a56a),
                                  //   borderRadius: BorderRadius.only(
                                  //     bottomLeft: Radius.circular(15.0),
                                  //   ),
                                  // ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  color: Color(0xFFc5a56a),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                    ),
                                    child: Text(LocaleKeys.date_birth.tr()),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                        ),
                                        child: /*widget.alMadallaCardFuture !=
                                                null
                                            ? FutureBuilder<String>(
                                                future: _getFormattedDate(widget
                                                    .alMadallaCardFuture!.dob),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<String>
                                                        snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Text(
                                                        '${snapshot.data}');
                                                  } else {
                                                    return Text('No data');
                                                  }
                                                },
                                              )
                                            : Text('No data'),*/

                                        Text(
                                          widget.alMadallaCardFuture != null
                                              ? Utils.getDateFormatted(
                                                  widget.alMadallaCardFuture!.dob)
                                                  
                                              : 'No data',
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  color: Color(0xFFc5a56a),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: new Divider(
                                      color: Colors.white,
                                    ),
                                  )),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: new Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  color: Color(0xFFc5a56a),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                    ),
                                    child: Text("Category"),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                        ),
                                        child: Text(
                                          widget.alMadallaCardFuture != null
                                              ? widget.alMadallaCardFuture!
                                                      .category ??
                                                  'No data'
                                              : 'No data',
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  color: Color(0xFFc5a56a),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: new Divider(
                                      color: Colors.white,
                                    ),
                                  )),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: new Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  color: Color(0xFFc5a56a),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                    ),
                                    child: Text("Emirates ID Number"),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                        ),
                                        child: Text(
                                          widget.alMadallaCardFuture != null
                                              ? widget.alMadallaCardFuture!
                                                      .emiratesIDNo ??
                                                  'No data'
                                              : 'No data',
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  color: Color(0xFFc5a56a),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: new Divider(
                                      color: Colors.white,
                                    ),
                                  )),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: new Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  color: Color(0xFFc5a56a),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                    ),
                                    child: Text("Payer"),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                        ),
                                        child: Text(
                                          widget.alMadallaCardFuture != null
                                              ? widget.alMadallaCardFuture!
                                                      .payer ??
                                                  'No data'
                                              : 'No data',
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  color: Color(0xFFc5a56a),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: new Divider(
                                      color: Colors.white,
                                    ),
                                  )),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: new Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  color: Color(0xFFc5a56a),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                    ),
                                    child: Text("Policy Start Date "),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                        ),
                                        child: Text(
                                          widget.alMadallaCardFuture != null
                                              ? Utils.getDateFormatted(widget
                                                  .alMadallaCardFuture!
                                                  .policyStartDate)
                                              : 'No data',
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  color: Color(0xFFc5a56a),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: new Divider(
                                      color: Colors.white,
                                    ),
                                  )),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: new Divider(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFc5a56a),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15.0),
                                    ),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.49,
                                  // color: Color(0xFFc5a56a),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0, bottom: 40),
                                    child: Text("Policy End Date"),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0,
                                            right: 15.0,
                                            bottom: 40),
                                        child: Text(
                                          widget.alMadallaCardFuture != null
                                              ? Utils.getDateFormatted(widget
                                                  .alMadallaCardFuture!
                                                  .policyEndDate)
                                              : 'No data',
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),

                          // Row(
                          //   children: [
                          //     Container(
                          //         decoration: BoxDecoration(
                          //           color: Color(0xFFc5a56a),
                          //           borderRadius: BorderRadius.only(
                          //             bottomLeft: Radius.circular(15.0),
                          //           ),
                          //         ),
                          //         width:
                          //             MediaQuery.of(context).size.width * 0.49,
                          //         child: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           children: [
                          //             Padding(
                          //               padding: const EdgeInsets.only(
                          //                   left: 15.0,
                          //                   bottom: 40,
                          //                   right: 15.0),
                          //               child: Text(LocaleKeys.member_id.tr()),
                          //             ),
                          //             //  Text("Member ID"),
                          //           ],
                          //         )),
                          //     Padding(
                          //       padding: const EdgeInsets.only(
                          //           left: 15.0, bottom: 40, right: 15.0),
                          //       child: Text(
                          //         widget.alMadallaCardFuture != null
                          //             ? widget.alMadallaCardFuture!.memberKey
                          //                 .toString()
                          //             : 'No data',
                          //       ),
                          //     )
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ))),
            ],
          ),
        ));
  }

  _getFormattedDate(String? date) {
    return Utils.getDateFormattedArabic(date);
  }
}
