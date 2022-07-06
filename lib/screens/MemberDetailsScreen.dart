import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/customwidgets/CustomDrawer.dart';
import 'package:almadalla/models/AlMadallaMemberModel.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/screens/ChangePasswordScreen.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'MemberDetails.dart';
import 'ProfileScreen.dart';
import 'package:easy_localization/easy_localization.dart';
class MemberDetailsPage extends StatefulWidget {
  MemberDetailsPage({Key? key, required this.title,required this.loginData}) : super(key: key);

  final String title;
  final LoginData? loginData;
  @override
  _MemberDetailsPageState createState() => _MemberDetailsPageState();
}

class _MemberDetailsPageState extends State<MemberDetailsPage> {
  //Future<AlMadallaMemberModel?>? alMadallaCardFuture;
  Future<List<AlMadallaMemberModel>?>? alMadallaCardFuture;
  void _onChangePasswordEnd(context) {
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChangePasswordPage(title: '')),
    );*/
    Navigator.of(context).pop();
  }

  void initState() {
    alMadallaCardFuture =
        RestDatasource().getAlMadallaMemberDetailsList(widget.loginData);
    super.initState();
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
        body:  Container(
          //height: MediaQuery.of(context).size.height,
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
                  LocaleKeys.member_details.tr(),
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            Expanded(
            flex: 17,
             child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, top: 5.0, right: 15.0,bottom: 10),
                child: FutureBuilder<List<AlMadallaMemberModel>?>(
                      future: alMadallaCardFuture, // async work
                      builder: (BuildContext context,
                          AsyncSnapshot<List<AlMadallaMemberModel>?>
                          snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Container(
                                child: Center(
                                    child:
                                    CupertinoActivityIndicator()));
                          default:
                            if (snapshot.hasError)
                              return Text(LocaleKeys.try_again.tr(),);
                            else
                              return getCardDataWidget(
                                  snapshot.data);
                        }
                      },
                    ),

                  ))
            ],
          ),
        ));
  }
  Widget getCardDataWidget(List<AlMadallaMemberModel>? alMadallaCardModel) {
    return SingleChildScrollView(
      child:Container(
        width: MediaQuery.of(context).size.width,

        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
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
                    height: 50,
                    // color: Color(0xFFb7956c),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 3,
                            child: Padding(
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: Text(LocaleKeys.card_no.tr(),
                                    style: TextStyle(fontSize: 15.0)))),
                        Expanded(
                            flex: 4,
                            child: Text(LocaleKeys.member_name.tr(),
                                style: TextStyle(fontSize: 15.0))),
                        Expanded(
                            flex: 4,
                            child: Text(LocaleKeys.policy_no.tr(),
                                style: TextStyle(fontSize: 15.0))),
                      ],
                    )
                    ),
                Container(
                //  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      ListView.builder(
                          physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                              itemCount: alMadallaCardModel!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => MemberDataPage(
                                                title: '',
                                                alMadallaCardFuture:
                                                    alMadallaCardModel[index])),
                                      );
                                    },
                                    child: Container(

                                        child: Column(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(top: 10,bottom: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                    flex: 3,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 5,
                                                        right: 10,
                                                      ),
                                                      child: Text(
                                                          alMadallaCardModel != null
                                                              ? alMadallaCardModel[
                                                                          index]
                                                                      .cardNo ??
                                                                  'No data'
                                                              : 'No data',
                                                          style: TextStyle(
                                                              fontSize: 15.0)),
                                                    )),
                                                Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                    alMadallaCardModel != null
                                                        ? alMadallaCardModel[index]
                                                                .nameEnglish ??
                                                            'No data'
                                                        : 'No data',
                                                    style: TextStyle(fontSize: 15.0),
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 3,
                                                  child:Text(
                                                          alMadallaCardModel != null
                                                              ? alMadallaCardModel[
                                                                          index]
                                                                      .policyNo ??
                                                                  'No data'
                                                              : 'No data',
                                                          style: TextStyle(
                                                              fontSize: 15.0),
                                                        ),


                                                    ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 10,right: 10
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  MemberDataPage(
                                                                      title: '', alMadallaCardFuture:
                                                                  alMadallaCardModel[index])),
                                                        );
                                                      },
                                                      child: Image.asset(
                                                        'assets/search.png',
                                                        width: 15.0,
                                                        height: 15.0,
                                                      ),
                                                    ))
                                              ],
                                            ))
                                      ],
                                    )));
                              })

                    ],
                  ),
                )


              ],
            ))));
  }


}
