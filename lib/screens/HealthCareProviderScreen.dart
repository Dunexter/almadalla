import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/customwidgets/CustomDrawer.dart';
import 'package:almadalla/models/NetworkProviderModel.dart';
import 'package:almadalla/screens/ChangePasswordScreen.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/screens/HealthCareProviderLocationMap.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ProfileScreen.dart';
import 'package:easy_localization/easy_localization.dart';

class HealthCareProviderPage extends StatefulWidget {
  HealthCareProviderPage(
      {Key? key, required this.title, required this.networkProviderModel})
      : super(key: key);
  List<NetworkProviderModel>? networkProviderModel;
  final String title;

  @override
  _HealthCareProviderPageState createState() => _HealthCareProviderPageState();
}

class _HealthCareProviderPageState extends State<HealthCareProviderPage> {
  void _onChangePasswordEnd(context) {
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChangePasswordPage(title: '')),
    );*/
    Navigator.of(context).pop();
  }

  Future<void> _onTapLocation(context, String providerName, String providerCity,
      String providerLocation) async {
    //get location of the healthCareName.  

    String address =
        providerName + ", " + providerCity + ", " + providerLocation;

    print("Location address =>>> $address");
    /*List latLong = await RestDatasource().getGoogleLocationFromAdress(address);
    double latitude = latLong[0];
    double longitude = latLong[1];*/

    double latitude = 0.0;
    double longitude = 0.0;

    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => HealthCareProviderLocationMap(
                title: '',
                healthCareName: providerName,
                address: address,
                //latitude: latitude,
                //longitude: longitude,
              )),
    );
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
                  LocaleKeys.our_healthcare_providers.tr(),
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              widget.networkProviderModel!.isNotEmpty
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
                  : Container(),
              //getSearchDataWidget(widget.networkProviderModel),
              // FutureBuilder<List<NetworkProviderModel>?>(
              //   future: widget. networkProviderModel, // async work
              //   builder: (BuildContext context,
              //       AsyncSnapshot<List<NetworkProviderModel>?>
              //       snapshot) {
              //     switch (snapshot.connectionState) {
              //       case ConnectionState.waiting:
              //         return Expanded(
              //             flex: 6,
              //             child: Center(
              //                 child:
              //                 CupertinoActivityIndicator()));
              //       default:
              //         if (snapshot.hasError)
              //           return Text('Try try again');
              //         else
              //           return getSearchDataWidget(
              //               snapshot.data);
              //     }
              //   },
              // ),
              getSearchDataWidget(widget.networkProviderModel),
              // Expanded(
              //   child: Padding(
              //     padding:
              //         const EdgeInsets.only(left: 15.0, right: 10.0, top: 10.0),
              //     // height: MediaQuery.of(context).size.height,
              //     child: ListView.builder(
              //         itemCount: 10,
              //         itemBuilder: (BuildContext context, int index) {
              //           return InkWell(
              //             onTap: () {},
              //             child: Container(
              //               height: 90.0,
              //               child: Card(
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(5.0),
              //                 ),
              //                 child: ListTile(
              //                     leading: Padding(
              //                       padding: const EdgeInsets.only(
              //                         left: 25.0,
              //                       ),
              //                       child: Image.asset(
              //                         'assets/location.png',
              //                         width: 15.0,
              //                         height: 15.0,
              //                       ),
              //                     ),
              //                     title: Container(
              //                         child: Row(
              //                       children: [
              //                         Padding(
              //                             padding: const EdgeInsets.only(
              //                                 left: 0.0, top: 10.0),
              //                             child: Container(
              //                               child: Column(
              //                                 crossAxisAlignment:
              //                                     CrossAxisAlignment.start,
              //                                 children: [
              //                                   Text("Abu Dhabi Knee & Sports",
              //                                       style: TextStyle(
              //                                           fontSize: 12,
              //                                           fontWeight:
              //                                               FontWeight.bold)),
              //                                   Padding(
              //                                     padding:
              //                                         const EdgeInsets.only(
              //                                             top: 5.0),
              //                                     child: Text(
              //                                         "Abu Dhabi, Electra ",
              //                                         style: TextStyle(
              //                                             fontSize: 12)),
              //                                   ),
              //                                   Padding(
              //                                       padding:
              //                                           const EdgeInsets.only(
              //                                               top: 5.0),
              //                                       child: Text(
              //                                           "02-6317774/4929572",
              //                                           style: TextStyle(
              //                                               fontSize: 12,
              //                                               fontWeight:
              //                                                   FontWeight
              //                                                       .bold))),
              //                                 ],
              //                               ),
              //                             ))
              //                       ],
              //                     )),
              //                     trailing: InkWell(
              //                       onTap: () {
              //                         _onTapLocation(
              //                             context, "Abu Dhabi Knee & Sports",9.931233, 76.267303);
              //                       },
              //                       child: Padding(
              //                         padding: const EdgeInsets.only(
              //                           left: 10.0,
              //                         ),
              //                         child: Image.asset(
              //                           'assets/angle-right.png',
              //                           width: 18.0,
              //                           height: 18.0,
              //                         ),
              //                       ),
              //                     )),
              //               ),
              //             ),
              //           );
              //         }),
              //   ),
              // )
            ],
          ),
        ));
  }

  Widget getSearchDataWidget(List<NetworkProviderModel>? param) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 10.0, top: 10.0),
        child: param!.length > 0
            ? ListView.builder(
                itemCount: param.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      _onTapLocation(
                            context,
                            param[index].name != null
                                ? param[index].name.toString()
                                : 'No data',
                            param[index].city != null
                                ? param[index].city.toString()
                                : 'No data',
                            param[index].location != null
                                ? param[index].location.toString()
                                : 'No data');

                    },
                    child: Container(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.only(
                                left: 25.0,
                              ),
                              child: Image.asset(
                                'assets/location.png',
                                width: 15.0,
                                height: 15.0,
                              ),
                            ),
                            title: Container(
                                child: Row(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, top: 10.0, bottom: 10),
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                180,
                                            child: Text(
                                              param[index].name != null
                                                  ? param[index].name.toString()
                                                  : 'No data',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Text(
                                                param[index].location != null
                                                    ? param[index]
                                                        .location
                                                        .toString()
                                                    : 'No data',
                                                style: TextStyle(fontSize: 12)),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5.0),
                                            child: Text(
                                                param[index].city != null
                                                    ? param[index]
                                                        .city
                                                        .toString()
                                                    : 'No data',
                                                style: TextStyle(fontSize: 12)),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),

                                              child:InkWell(
                                                  onTap: (){
                                                    launch('tel:+${param[index]
                                                        .fax
                                                        .toString()}');

                                                   // launch("tel:800 43444");
                                                  },
                                                child: Text(
                                                    param[index].fax != null
                                                        ? param[index]
                                                            .fax
                                                            .toString()
                                                        : '',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold))
                                              )
                                              // child: Text(
                                              //     param[index].fax != null
                                              //         ? param[index]
                                              //             .fax
                                              //             .toString()
                                              //         : 'No data',
                                              //     style: TextStyle(
                                              //         fontSize: 12,
                                              //         fontWeight:
                                              //             FontWeight.bold))

                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            )),
                            trailing: InkWell(

                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10.0,
                                ),
                                child: Image.asset(
                                  LocaleKeys.language.tr()=="arabic" ?'assets/angle-left.png':'assets/angle-right.png',
                                  width: 18.0,
                                  height: 18.0,
                                ),
                              ),
                            )),
                      ),
                    ),
                  );
                })
            : Align(
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
              ),
      ),
    );
  }
}
