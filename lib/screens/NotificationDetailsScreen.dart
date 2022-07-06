import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/models/AlMadallaMemberModel.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/PushNotificationsDetailsModel.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationDetailsScreen extends StatefulWidget {
  NotificationDetailsScreen(
      {Key? key, required this.title, required this.loginData})
      : super(key: key);
  final String title;
  final LoginData? loginData;

  @override
  _NotificationDetailsScreenState createState() =>
      _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  void _onBackButtonPressed(context) {
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChangePasswordPage(title: '')),
    );*/
    Navigator.of(context).pop();
  }

  Future<List<AlMadallaMemberModel>?>? memberDetailsFuture;
  void initState() {
    memberDetailsFuture =
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
                  _onBackButtonPressed(context);
                })),
        //drawer: CustomDrawer(),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left:5, right:5),
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
                  LocaleKeys.notifications.tr(),
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              /*widget.networkProviderModel!=null && widget.networkProviderModel!.isNotEmpty
                  ? Align(
                      alignment: LocaleKeys.language.tr()=="arabic" ? Alignment.topRight:Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 10.0),
                        child: Text(
                          LocaleKeys.locations.tr(),
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        ),
                      ))
                  : Container(),*/

              //getSearchDataWidget(widget.networkProviderModel),

              Expanded(
                child: FutureBuilder<List<AlMadallaMemberModel>?>(
                  future: memberDetailsFuture, // async work
                  builder: (BuildContext context,
                      AsyncSnapshot<List<AlMadallaMemberModel>?> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Container(
                            child:
                                Center(child: CupertinoActivityIndicator()));
                      default:
                        if (snapshot.hasError)
                          return Text(
                            LocaleKeys.try_again.tr(),
                          );
                        else {
                          if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                            /*return //Expanded(
                             // child: SingleChildScrollView(
                                 Container(
                                  height: MediaQuery.of(context).size.height,
                                            width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                  for (var i in snapshot.data!)
                                    getNotificationsListDataWidget(i)
                                    ],
                                  ),
                               // ),
                              //),
                            );   */

                            return getNotificationsListDataWidget(
                                snapshot.data);
                          } else
                            return Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: RichText(
                                      text: TextSpan(
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black),
                                          children: <TextSpan>[
                                        TextSpan(
                                          text: LocaleKeys.no_data_found.tr(),
                                        ),
                                      ]))),
                            );
                        }

                      //else return Text(snapshot.data![0].memberKey.toString());
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }

  Widget getNotificationsListDataWidget(
      List<AlMadallaMemberModel>? alMadallaMemberModelList) {
    Future<List<PushNotificationsDetailsModel>?>?
        pushNotificationsDetailsModelListFuture;
    pushNotificationsDetailsModelListFuture = RestDatasource()
        .getPushNotificationsDetailsForUser(
            widget.loginData, alMadallaMemberModelList);
    return FutureBuilder<List<PushNotificationsDetailsModel>?>(
      future: pushNotificationsDetailsModelListFuture, // async work
      builder: (BuildContext context,
          AsyncSnapshot<List<PushNotificationsDetailsModel>?> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
                child: Center(child: CupertinoActivityIndicator()));
          default:
            if (snapshot.hasError)
              return Text(
                LocaleKeys.try_again.tr(),
              );

            //else return getCardDataWidget(snapshot.data);
            //else return Text(snapshot.data![0].memberKey.toString());

            List<PushNotificationsDetailsModel>?
                pushNotificationsDetailsModelList = snapshot.data;

            if (pushNotificationsDetailsModelList != null &&
                pushNotificationsDetailsModelList.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: ListTile(
                            title: Container(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, top: 10.0, bottom: 10),
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                180,
                                            child: Text(
                                              pushNotificationsDetailsModelList[
                                                              index]
                                                          .notificationText !=
                                                      null
                                                  ? pushNotificationsDetailsModelList[
                                                          index]
                                                      .notificationText
                                                      .toString()
                                                  : 'No data',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight.bold),
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(
                                                    top: 5.0),
                                            child: Text(
                                                pushNotificationsDetailsModelList[
                                                                index]
                                                            .notificationDate !=
                                                        null
                                                    ? pushNotificationsDetailsModelList[
                                                            index]
                                                        .notificationDate
                                                        .toString()
                                                    : 'No data',
                                                style: TextStyle(
                                                    fontSize: 12)),
                                          ),
                                        ],
                                      ),
                                    ))),
                          ),
                        ),
                      ),
                    );
                  });
            } else
              return Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                            children: <TextSpan>[
                          TextSpan(
                            text: LocaleKeys.no_data_found.tr(),
                          ),
                        ]))),
              );
        }
      },
    );
  }
}
