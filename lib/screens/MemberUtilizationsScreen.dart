import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/customwidgets/CustomDrawer.dart';
import 'package:almadalla/models/AlMadallaMemberModel.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/MemberUtilizationModel.dart';
import 'package:almadalla/models/UserSettingsBloc.dart';
import 'package:almadalla/screens/ChangePasswordScreen.dart';
//import 'package:almadalla/screens/CustomException.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/screens/LoginPage.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';


import 'MemberUtilizationDetailScreen.dart';
import 'ProfileScreen.dart';

class MemberUtilizationPage extends StatefulWidget {
  MemberUtilizationPage({Key? key, required this.title,required this.loginData}) : super(key: key);

  final String title;
  final LoginData? loginData;
  @override
  _MemberUtilizationPageState createState() => _MemberUtilizationPageState();
}

class _MemberUtilizationPageState extends State<MemberUtilizationPage> {
  //Future<AlMadallaMemberModel?>? alMadallaCardFuture;
  void _onChangePasswordEnd(context) {
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChangePasswordPage(title: '')),
    );*/
    Navigator.of(context).pop();
  }
  Future<List<AlMadallaMemberModel>?>? alMadallaCardFuture;
  void initState() {
    alMadallaCardFuture =
          RestDatasource().getAlMadallaMemberDetailsList(widget.loginData);
    super.initState();
  }
  UserSettingsBloc? userSettingsBloc;
  @override
  Widget build(BuildContext context) {
    userSettingsBloc = Provider.of<UserSettingsBloc>(context, listen: false);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
              LocaleKeys.member_utilization.tr(),
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
                      AsyncSnapshot<List<AlMadallaMemberModel>?> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Container(
                            child: Center(child: CupertinoActivityIndicator()));
                      default:
                        if (snapshot.hasError)
                          return Text(
                            LocaleKeys.try_again.tr(),
                          );
                        /*if (snapshot.error is CustomException) {
                            CustomException customException =
                            snapshot.error as CustomException;
                            return showError(customException.toString());
                        }
                        if (snapshot.error is BadRequestException) {
                          BadRequestException badRequestException =
                          snapshot.error as BadRequestException;
                          return showErrorText(badRequestException.toString());
                        }
                        if (snapshot.error is UnauthorisedException) {
                          UnauthorisedException unauthorisedException =
                          snapshot.error as UnauthorisedException;
                          return showErrorText(unauthorisedException.toString());
                        }
                        else*/
                      else return getCardDataWidget(snapshot.data);
                    }
                  },
                ),
              )),


            ],
          ),
        ));
  }

  Widget showError(message) {
    return AlertDialog(
        title: Text("Session Expired!"),
        content: Text("Session Expired.Please Login"),
        actions: <Widget>[
          TextButton(
            child: Text("ok"),
            onPressed: () => {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new LoginPage(
                            title: '',
                          )))
            },
          ),
        ]);
  }

  Widget showErrorText(message) {
    return Center(
      child: Text('$message'),
    );
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
                    child: ListTile(
                      leading: Text(LocaleKeys.select_member.tr(),
                          style: TextStyle(fontSize: 15.0)),
                    )),
                Container(
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
                                    builder: (_) => MemberUtilizationdetailPage(
                                        title: '',
                                        loginData:
                                            userSettingsBloc!.getLoginData(),
                                        alMadallaCardFuture:
                                            alMadallaCardModel[index])),
                              );
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(top: 10,bottom: 10),
                                      child: Row(children: <Widget>[
                                        Expanded(
                                            flex: 8,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                              ),
                                              child: Text(
                                                  alMadallaCardModel != null
                                                      ? alMadallaCardModel[
                                                                  index]
                                                              .nameEnglish ??
                                                          'No data'
                                                      : 'No data',
                                                  style: TextStyle(
                                                      fontSize: 15.0)),
                                            )),
                                        Expanded(
                                             flex: 2,
                                            child: InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (_) => MemberUtilizationdetailPage(
                                                            title: '',
                                                            loginData:
                                                                userSettingsBloc!
                                                                    .getLoginData(),
                                                            alMadallaCardFuture:
                                                                alMadallaCardModel[
                                                                    index])),
                                                  );
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 20),
                                                  child: Image.asset(
                                                    'assets/search.png',
                                                    width: 15.0,
                                                    height: 15.0,
                                                  ),
                                                ))),
                                      ]))
                                ],
                              ),
                            ));
                      })]),
                )
              ],
            ))));
  }
}
