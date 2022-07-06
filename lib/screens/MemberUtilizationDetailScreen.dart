import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/customwidgets/CustomDrawer.dart';
import 'package:almadalla/models/AlMadallaMemberModel.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/MemberUtilizationModel.dart';
import 'package:almadalla/screens/ChangePasswordScreen.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'MemberDetails.dart';
import 'ProfileScreen.dart';
import 'package:easy_localization/easy_localization.dart';

class MemberUtilizationdetailPage extends StatefulWidget {
  MemberUtilizationdetailPage(
      {Key? key,
      required this.title,
      required this.loginData,
      required this.alMadallaCardFuture})
      : super(key: key);
  AlMadallaMemberModel? alMadallaCardFuture;
  final String title;
  final LoginData? loginData;

  @override
  _MemberUtilizationdetailPageState createState() =>
      _MemberUtilizationdetailPageState();
}

class _MemberUtilizationdetailPageState
    extends State<MemberUtilizationdetailPage> {
  //AlMadallaMemberModel? alMadallaCardFuture;
 // MemberUtilizationModel? memberUtilizationModel;
  Future<List<MemberUtilizationModel>?>? memberUtilizationModel;

  void _onChangePasswordEnd(context) {
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChangePasswordPage(title: '')),
    );*/
    Navigator.of(context).pop();
  }
  void initState() {
    memberUtilizationModel =  RestDatasource()
        .getMemberUtilizations(widget.loginData, widget.alMadallaCardFuture);
    super.initState();
  }
  // Future<MemberUtilizationModel?>? getMemberUtilizationDetails() async {
  //   // alMadallaCardFuture =
  //   //     await RestDatasource().getAlMadallaMemberDetails(widget.loginData);
  //   memberUtilizationModel =  RestDatasource()
  //       .getMemberUtilizations(widget.loginData, widget.alMadallaCardFuture);
  //
  // }
  //
  // void initState() {
  //   super.initState();
  // }

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
        //  height: MediaQuery.of(context).size.height,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  widget.alMadallaCardFuture != null
                      ? widget.alMadallaCardFuture!.nameEnglish ?? 'No data'
                      : 'No data',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            Expanded(
             flex: 17,
             child: Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, top: 5.0, right: 15.0,bottom: 10.0),
                child: FutureBuilder<List<MemberUtilizationModel>?>(
                  future: memberUtilizationModel, // async work
                  builder: (BuildContext context,
                      AsyncSnapshot<List<MemberUtilizationModel>?> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Container(
                            child: Center(child: CupertinoActivityIndicator()));
                      default:
                        if (snapshot.hasError)
                          return Text(LocaleKeys.try_again);
                        else
                          return getMemberUtilizationWidget(snapshot.data);
                    }
                  },
                ),
              ))
            ],
          ),
        ));
  }

  Widget getMemberUtilizationWidget(List<MemberUtilizationModel>? memberUtilization) {
    return SingleChildScrollView (
    child:Container(
        width: MediaQuery.of(context).size.width,
       // height: MediaQuery.of(context).size.height,
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFc5a56a),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      topLeft: Radius.circular(15.0),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0),

                    // color: Color(0xFFb7956c),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 7,
                          child: Align(
                          alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(left:5.0,right: 5.0),
                                  child:Text(
                                    LocaleKeys.policy.tr(),
                                    style: TextStyle(
                                        fontSize: 13.0, color: Colors.black),
                                  ),),
                          ),),
                        Expanded(
                          flex: 5,
                          child: Align(
                          alignment: Alignment.center,
                            child: Text(
                              LocaleKeys.amount.tr(),
                              style:
                                  TextStyle(fontSize: 13.0, color: Colors.black),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Align(
                          alignment: Alignment.center,
                            child: Text(
                              //LocaleKeys.utilized.tr() + "\n"+ LocaleKeys.amount.tr() ,
                              LocaleKeys.amount_utilized.tr(),
                              softWrap: true,
                              style:
                                  TextStyle(fontSize: 13.0, color: Colors.black),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Align(
                          alignment: Alignment.center,
                            child: Text(
                              //LocaleKeys.balance.tr() + "\n"+ LocaleKeys.amount.tr() ,
                              LocaleKeys.amount_balance.tr(),
                              style:
                                  TextStyle(fontSize: 13.0, color: Colors.black),
                            ),
                          ),
                        )
                        //   ],
                            // ))
                      ],
                    ),
                  ),
                ),

              Container(
                //  height: MediaQuery.of(context).size.height,
               child: Column(
              children: [
                ListView.builder(
                    itemCount: memberUtilization!.length,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return  Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                              padding: EdgeInsets.only(top: 10,bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child:

                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                          padding: EdgeInsets.only(left:5.0,right: 5.0),
                                          child:Text(
                                            memberUtilization != null
                                                ? memberUtilization[index].policySubLimit  ??
                                                'No data'
                                                : 'No data',
                                            style: TextStyle(
                                                fontSize: 13.0, color: Colors.black),
                                          )

                                      ),
                                    ),),
                                  Expanded(
                                    flex: 6,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 0.0, right: 0.0),
                                        child: Text(
                                          memberUtilization != null
                                              ? memberUtilization[index].amount.toString()
                                              : 'No data',
                                          style:
                                          TextStyle(fontSize: 13.0, color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 0.0, right: 0.0),
                                        child: Text(
                                          memberUtilization != null
                                              ?memberUtilization[index].utilizedAmount.toString()
                                              : 'No data',
                                          style: TextStyle(
                                              fontSize: 13.0, color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 7,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                            padding:
                                            EdgeInsets.only(left: 0.0, right: 5.0),
                                            child: Text(
                                              memberUtilization != null
                                                  ? memberUtilization[index].balanceAmount
                                                  .toString()
                                                  : 'No data',
                                              style: TextStyle(
                                                  fontSize: 13.0, color: Colors.black),
                                            )),
                                      ))],
                              ))
                      );})
              ],
              )

    )
              ],
            ))));
  }
}
