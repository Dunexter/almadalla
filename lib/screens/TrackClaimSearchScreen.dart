import 'package:almadalla/Util/Utils.dart';
import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/customwidgets/CustomDrawer.dart';
import 'package:almadalla/models/AlMadallaMemberModel.dart';
import 'package:almadalla/models/ClaimsModel.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/screens/ChangePasswordScreen.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/screens/HealthCareProviderLocationMap.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import 'ProfileScreen.dart';
import 'package:easy_localization/easy_localization.dart';

class TrackClaimSearchPage extends StatefulWidget {
  TrackClaimSearchPage(
      {Key? key, required this.title, required this.trackClaimFuture,required this.name})
      : super(key: key);

  final String title;
  final String? name;
  Future<List<ClaimsModel>?>? trackClaimFuture;

  @override
  _TrackClaimSearchPageState createState() => _TrackClaimSearchPageState();
}

class _TrackClaimSearchPageState extends State<TrackClaimSearchPage> {

  Future<AlMadallaMemberModel?>? alMadallaCardFuture;
  void _onChangePasswordEnd(context) {
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChangePasswordPage(title: '')),
    );*/
    Navigator.of(context).pop();
  }


  String? name;
  String? cardNo;
  String? claimType;
  String? claimReference;
  String? serviceDate;
  String? providerName;
  String? claimAmount;
  String? approvedAmount;
  String? claimAction;
  String? status;
  String? remark;

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),

            ),
            height:MediaQuery.of(context).size.height *0.65,
           width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 50, left: 5),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height *0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: SingleChildScrollView(
                        child: Container(
                          // height: 100,
                          child: Padding(
                              padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                              child: Column(children: [
                              Padding(
                              padding: EdgeInsets.only(top: 15,left:10,right: 10),
                               child: Row(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Text(LocaleKeys.cliam_name.tr(),),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Text(name!),
                                    ),
                                  ],
                                ),),
                                Padding(
                                  padding: EdgeInsets.only(top: 15,left:10,right: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Text(LocaleKeys.card_no.tr()),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(cardNo!),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15,left: 10,right: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Text(LocaleKeys.claim_type.tr()),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(claimType!),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15,left: 10,right: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Text(LocaleKeys.claim_reference.tr()),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(claimReference!),
                                      ),
                                      // Text(iban!),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15,left: 10,right: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Text(LocaleKeys.service_date.tr()),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(serviceDate!),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15,left: 10,right: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Text(LocaleKeys.provider_name.tr(),),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(providerName!),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15,left: 10,right: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Text( LocaleKeys.claim_amount.tr(),),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(claimAmount!),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(top: 15,left: 10,right: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Text(LocaleKeys.approved_amount.tr()),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(approvedAmount!),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15,left: 10,right: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Text(LocaleKeys.claim_action.tr()),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(claimAction!),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15,left: 10,right: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Text(  LocaleKeys.status.tr()),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(status!),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15,left: 10,right: 10,bottom: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Text(LocaleKeys.remarks.tr()),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: ReadMoreText(
                                              remark!,
                                           style: TextStyle(
                                               color: Colors.black),
                                            trimLines: 5,
                                            colorClickableText:Color(0xFFc5a56a),
                                            trimMode: TrimMode.Line,
                                            trimCollapsedText: 'Show more',
                                             trimExpandedText: 'Show less',
                                            moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                                          ),
                                      ),
                                    ],
                                  ),
                                ),


                              ])),
                        ),
                      ),
                    )),
                Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    color: Color(0xFFc5a56a),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                            LocaleKeys.claim_details.tr(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, right: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        //  ),
                      ),
                    )),
              ],
            ),
          ),
        );
      },
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
              Padding(
                padding: const EdgeInsets.only(bottom:10.0),
                child: Center(
                  child: Text(
                    LocaleKeys.claimList.tr(),
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              //getSearchDataWidget(widget.trackClaimFuture),
              FutureBuilder<List<ClaimsModel>?>(
                future: widget.trackClaimFuture, // async work
                builder: (BuildContext context,
                    AsyncSnapshot<List<ClaimsModel>?> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Expanded(
                          flex: 6,
                          child: Center(child: CupertinoActivityIndicator()));
                    default:
                      if (snapshot.hasError)
                        return Text(LocaleKeys.try_again);
                      else
                        return getSearchDataWidget(snapshot.data);
                  }
                },
              ),
            ],
          ),
        ));
  }

  Widget getSearchDataWidget(List<ClaimsModel>? param) {

    return Expanded(
      child:param!.length >0? ListView.builder(
          itemCount: param.length,
          itemBuilder: (BuildContext context, int index) {

      return InkWell(
          onTap: () {
            name = widget.name != null
                ? widget.name
                : 'No data';
            cardNo = param[index].cardNo != null
                ? param[index].cardNo ?? 'No data'
                : 'No data';
            claimType = param[index].claimType != null
                ? param[index].claimType ?? 'No data'
                : 'No data';
            claimReference = param[index].claimRef != null
                ? param[index].claimRef ?? 'No data'
                : 'No data';
            serviceDate =   param[index].serviceDate  != null
                ? Utils.getDateFormatted(
                param[index].serviceDate)
                : 'No data';
            providerName = param[index].provider != null
                ? param[index].provider ?? 'No data'
                : 'No data';
            claimAmount = param[index].claimedCost != null
                ? param[index].claimedCost.toString()
                : 'No data';
            approvedAmount=param[index].claimedCost != null
                ? param[index].claimedCost.toString()
                : 'No data';
            claimAction=param[index].claimaction != null
                ? param[index].claimaction.toString()
                : 'No data';
            status=param[index].status != null
                ? param[index].status.toString()
                : 'No data';
            remark=param[index].remarks != null
                ? param[index].remarks.toString()
                : 'No data';
            _showDialog();



          },
            child: Container(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),

                  child:Padding(
                    padding: EdgeInsets.only(top: 10,left: 10.0,bottom: 10,right: 10.0),
                              child: Column(
                                children: <Widget>[
                                  Row(children: <Widget>[
                                  Expanded(
                                  flex: 2,

                               child:   Text(
                                      LocaleKeys.provider_name.tr(),
                                      style: TextStyle(
                                          //  fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),),
                    Expanded(
                        flex: 2,

                       child: Text(
                                      //"Rak Insurance",
                                      param[index].provider != null
                                          ? param[index].provider ?? 'No data'
                                          : 'No data',
                                      style: TextStyle(
                                          // fontSize: 13.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),)
                                  ]),
                                  Row(children: <Widget>[
                                    Expanded(
                                        flex: 2,
                                 child:   Text(
                                      LocaleKeys.service_date.tr(),
                                      style: TextStyle(
                                          //fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),),
                                    Expanded(
                                        flex: 2,
                                   child: Text(
                                      param[index].serviceDate != null
                                          ? Utils.getDateFormatted(
                                              param[index].serviceDate)
                                          : 'No data',
                                      style: TextStyle(
                                          //fontSize: 13.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),)
                                  ]),
                                  Row(children: <Widget>[
                                    Expanded(
                                        flex: 2,
                                 child:   Text(
                                      LocaleKeys.claim_amount.tr(),
                                      style: TextStyle(
                                          //  fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),),
                                    Expanded(
                                        flex: 2,
                                  child:  Text(
                                      param[index].claimedCost != null
                                          ? param[index].claimedCost.toString()
                                          : 'No data',
                                      style: TextStyle(
                                          //fontSize: 13.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),)
                                  ]),
                                  Row(children: <Widget>[
                                    Expanded(
                                        flex: 2,
                                   child: Text(
                                      LocaleKeys.approved_amount.tr(),
                                      style: TextStyle(
                                          // fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),),
                                    Expanded(
                                        flex: 2,
                                   child: Text(
                                      param[index].approvedCost != null
                                          ? param[index].approvedCost.toString()
                                          : 'No data',
                                      style: TextStyle(
                                          //  fontSize: 13.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),)
                                  ]),
                                  Row(children: <Widget>[
                                    Expanded(
                                        flex: 2,
                                  child:  Text(
                                      LocaleKeys.status.tr(),
                                      style: TextStyle(
                                          // fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),),
                                    Expanded(
                                        flex: 2,
                                  child:  Text(
                                      param[index].status != null
                                          ? param[index].status ?? 'No data'
                                          : 'No data',
                                      style: TextStyle(
                                          //  fontSize: 13.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),)
                                  ]),
                                  // Row(children: <Widget>[
                                  //   Expanded(
                                  //     flex: 2,
                                  //     child:  Text(
                                  //      "Remark",
                                  //       style: TextStyle(
                                  //         // fontSize: 13.0,
                                  //           fontWeight: FontWeight.bold,
                                  //           color: Colors.black),
                                  //     ),),
                                  //   Expanded(
                                  //     flex: 2,
                                  //     child:  Text(
                                  //       param[index].remarks != null
                                  //           ? param[index].remarks ?? 'No data'
                                  //           : 'No data',
                                  //       style: TextStyle(
                                  //         //  fontSize: 13.0,
                                  //           fontWeight: FontWeight.normal,
                                  //           color: Colors.black),
                                  //     ),)
                                  // ]),

                                ],
                              )
                  )

                          // child:Expanded(
                  //     flex: 6,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //           flex : 4,
                  //           child: Padding(
                  //             padding: const EdgeInsets.only(left: 10.0,right: 10),
                  //             child: Row(
                  //               children: [
                  //                 Expanded(
                  //                   flex : 2,
                  //                   child: Column(
                  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //                     crossAxisAlignment: CrossAxisAlignment.start,
                  //                     children: [
                  //                       Text(
                  //                         LocaleKeys.provider_name.tr(),
                  //                         style: TextStyle(
                  //                           //  fontSize: 13.0,
                  //                             fontWeight: FontWeight.bold,
                  //                             color: Colors.black),
                  //
                  //                       ),
                  //                       Text(
                  //                         LocaleKeys.service_date.tr(),
                  //                         style: TextStyle(
                  //                             //fontSize: 13.0,
                  //                             fontWeight: FontWeight.bold,
                  //                             color: Colors.black),
                  //
                  //                       ),
                  //                       Text(
                  //                         LocaleKeys.claim_amount.tr(),
                  //                         style: TextStyle(
                  //                           //  fontSize: 13.0,
                  //                             fontWeight: FontWeight.bold,
                  //                             color: Colors.black),
                  //
                  //                       ),
                  //                       Text(
                  //                         LocaleKeys.approved_amount.tr(),
                  //                         style: TextStyle(
                  //                            // fontSize: 13.0,
                  //                             fontWeight: FontWeight.bold,
                  //                             color: Colors.black),
                  //
                  //                       ),
                  //                       Text(
                  //                         LocaleKeys.status.tr(),
                  //                         style: TextStyle(
                  //                            // fontSize: 13.0,
                  //                             fontWeight: FontWeight.bold,
                  //                             color: Colors.black),
                  //
                  //                       ),
                  //
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 Expanded(
                  //                   flex : 3,
                  //                   child: Padding(
                  //                     padding: const EdgeInsets.only(left: 10,right: 10),
                  //                     child: Column(
                  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //                       crossAxisAlignment: CrossAxisAlignment.start,
                  //                       children: [
                  //                         Text(
                  //                           //"Rak Insurance",
                  //                           param[index].provider != null
                  //                               ? param[index].provider ?? 'No data'
                  //                               : 'No data',
                  //                           style: TextStyle(
                  //                              // fontSize: 13.0,
                  //                               fontWeight: FontWeight.normal,
                  //                               color: Colors.black),
                  //                         ),
                  //                         Text(
                  //                           param[index].serviceDate != null
                  //                               ? Utils.getDateFormatted(
                  //                               param[index].serviceDate)
                  //                               : 'No data',
                  //                           style: TextStyle(
                  //                               //fontSize: 13.0,
                  //                               fontWeight: FontWeight.normal,
                  //                               color: Colors.black),
                  //                         ),
                  //                         Text(
                  //                           param[index].claimedCost != null
                  //                               ? param[index].claimedCost.toString()
                  //                               : 'No data',
                  //                           style: TextStyle(
                  //                               //fontSize: 13.0,
                  //                               fontWeight: FontWeight.normal,
                  //                               color: Colors.black),
                  //                         ),
                  //                         Text(
                  //                           param[index].approvedCost != null
                  //                               ? param[index].approvedCost.toString()
                  //                               : 'No data',
                  //                           style: TextStyle(
                  //                             //  fontSize: 13.0,
                  //                               fontWeight: FontWeight.normal,
                  //                               color: Colors.black),
                  //                         ),
                  //                         Text(
                  //                           param[index].status != null
                  //                               ? param[index].status ?? 'No data'
                  //                               : 'No data',
                  //                           style: TextStyle(
                  //                             //  fontSize: 13.0,
                  //                               fontWeight: FontWeight.normal,
                  //                               color: Colors.black),
                  //                         ),
                  //
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //
                  //       ],
                  //     )
                  //
                  // )
                // child: ListTile(
                //   title: Container(
                //     child: Padding(
                //       padding: const EdgeInsets.only(left: 10),
                //       child: Row(
                //         children: [
                //           Expanded(
                //             flex: 2,
                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.start,
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //             Padding(
                //             padding: const EdgeInsets.only(top: 5),
                //               child:  Text(
                //                   LocaleKeys.provider_name.tr(),
                //                   style: TextStyle(
                //                       fontSize: 13.0,
                //                       fontWeight: FontWeight.bold,
                //                       color: Colors.black),
                //                 ),),
                //              Padding(
                //             padding: const EdgeInsets.only(top: 5),
                //                child:  Text(
                //                   LocaleKeys.service_date.tr(),
                //                   style: TextStyle(
                //                       fontSize: 13.0,
                //                       fontWeight: FontWeight.bold,
                //                       color: Colors.black),
                //                 ),),
                //            Padding(
                //             padding: const EdgeInsets.only(top: 5),
                //                child: Text(
                //                   LocaleKeys.claim_amount.tr(),
                //                   style: TextStyle(
                //                       fontSize: 13.0,
                //                       fontWeight: FontWeight.bold,
                //                       color: Colors.black),
                //                 ),),
                //            Padding(
                //              padding: const EdgeInsets.only(top: 5),
                //               child:  Text(
                //                   LocaleKeys.approved_amount.tr(),
                //                   style: TextStyle(
                //                       fontSize: 13.0,
                //                       fontWeight: FontWeight.bold,
                //                       color: Colors.black),
                //                 ),),
                //             Padding(
                //               padding: const EdgeInsets.only(top: 5,bottom: 5),
                //                 child:Text(
                //                   LocaleKeys.status.tr(),
                //                   style: TextStyle(
                //                       fontSize: 13.0,
                //                       fontWeight: FontWeight.bold,
                //                       color: Colors.black),
                //                 ),),
                //               ],
                //             ),
                //           ),
                //           Expanded(
                //             flex: 2,
                //             child: Padding(
                //               padding: const EdgeInsets.only(left: 10),
                //               child: Column(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.start,
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //               Padding(
                //               padding: const EdgeInsets.only(top: 5),
                //                child:   Text(
                //                     param[index].provider != null
                //                         ? param[index].provider ?? 'No data'
                //                         : 'No data',
                //                     style: TextStyle(
                //                         fontSize: 13.0,
                //                         fontWeight: FontWeight.normal,
                //                         color: Colors.black),
                //                   ),),
                //               Padding(
                //                 padding: const EdgeInsets.only(top: 5),
                //                 child:  Text(
                //                     param[index].serviceDate != null
                //                         ? Utils.getDateFormatted(
                //                             param[index].serviceDate)
                //                         : 'No data',
                //                     style: TextStyle(
                //                         fontSize: 13.0,
                //                         fontWeight: FontWeight.normal,
                //                         color: Colors.black),
                //                   ),),
                //               Padding(
                //                 padding: const EdgeInsets.only(top: 5),
                //                child:Text(
                //                     param[index].claimedCost != null
                //                         ? param[index].claimedCost.toString()
                //                         : 'No data',
                //                     style: TextStyle(
                //                         fontSize: 13.0,
                //                         fontWeight: FontWeight.normal,
                //                         color: Colors.black),
                //                   ),),
                //               Padding(
                //                 padding: const EdgeInsets.only(top: 5),
                //                 child:Text(
                //                     param[index].approvedCost != null
                //                         ? param[index].approvedCost.toString()
                //                         : 'No data',
                //                     style: TextStyle(
                //                         fontSize: 13.0,
                //                         fontWeight: FontWeight.normal,
                //                         color: Colors.black),
                //                   )),
                //               Padding(
                //                 padding: const EdgeInsets.only(top: 5,bottom: 5),
                //                  child: Text(
                //                     param[index].status != null
                //                         ? param[index].status ?? 'No data'
                //                         : 'No data',
                //                     style: TextStyle(
                //                         fontSize: 13.0,
                //                         fontWeight: FontWeight.normal,
                //                         color: Colors.black),
                //                   ),),
                //                   // Text(
                //                   //   param[index].provider != null
                //                   //       ? param[index].provider ?? 'No data'
                //                   //       : 'No data',
                //                   //   style: TextStyle(
                //                   //       fontSize: 13.0,
                //                   //       fontWeight: FontWeight.normal,
                //                   //       color: Colors.black),
                //                   // )
                //                 ],
                //               ),
                //             ),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ),
            ));
          }): Align(
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
                        TextSpan(text:LocaleKeys.no_data_found.tr(),),
                      ]))),
            ),
      //),
    );
  }
}
