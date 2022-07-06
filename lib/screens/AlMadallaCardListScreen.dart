import 'package:almadalla/Util/Utils.dart';
import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/models/AlMadallaMemberModel.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/UserSettingsBloc.dart';
import 'package:almadalla/screens/AlMadallaCard.dart';
import 'package:almadalla/translation/local_keys.g.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AlMadallaCardListScreen extends StatefulWidget {
  AlMadallaCardListScreen(
      {Key? key, required this.title, required this.loginData})
      : super(key: key);

  final String title;
  final LoginData? loginData;

  @override
  _AlMadallaCardListScreenState createState() =>
      _AlMadallaCardListScreenState();
}

class _AlMadallaCardListScreenState extends State<AlMadallaCardListScreen> {
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
        body: Container(
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
                  LocaleKeys.al_madallah_card.tr(),
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
           Expanded(
               flex: 17,
            child:  Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, top: 5.0, right: 15.0,bottom: 10),
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
                        else
                          return getCardDataWidget(snapshot.data);
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
       // height: MediaQuery.of(context).size.height - 200,
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
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => AlMadallaCard(
                                      title: '',
                                      alMadallaCardFuture:
                                          alMadallaCardModel[index])));
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
                                            // flex: 8,
                                            child: InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (_) => AlMadallaCard(
                                                            title: '',
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
                      }),])
                )
              ],
            ))));
  }
}
