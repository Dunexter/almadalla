import 'package:almadalla/Util/Utils.dart';
import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/models/AlMadallaMemberModel.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/UserSettingsBloc.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'LanguageBloc.dart';
// import 'package:almadalla/translation/local_keys.g.dart';
// import 'package:easy_localization/easy_localization.dart';

// This screen shoul dnot change direction, hence not used easy_localization @Harris

class AlMadallaCard extends StatefulWidget {
  AlMadallaCard(
      {Key? key, required this.title, required this.alMadallaCardFuture})
      : super(key: key);

  final String title;
  AlMadallaMemberModel? alMadallaCardFuture;
  @override
  _AlMadallaCardState createState() => _AlMadallaCardState();
}

class _AlMadallaCardState extends State<AlMadallaCard> {
 // Future<AlMadallaMemberModel?>? alMadallaCardFuture;
  void initState() {
    // alMadallaCardFuture =
    //     RestDatasource().getAlMadallaMemberDetailsListCard(widget.loginData) ;

    super.initState();
  }


  bool value = false;
  void _onChangePasswordEnd(context) {
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChangePasswordPage(title: '')),
    );*/
    Navigator.of(context).pop();
  }

  UserSettingsBloc? userSettingsBloc;
  LanguageBloc? bloc;
  @override
  Widget build(BuildContext context) {
    userSettingsBloc = Provider.of<UserSettingsBloc>(context, listen: false);
    bloc = Provider.of<LanguageBloc>(context);
    /*int? val=bloc!.getLanguage() ;
    if(val ==2){
      value =true;
    }else{
      value =false;
    }*/

    String? val=Utils.getLanguage();
    print("Utils.getLanguage() --> $val");
    if(val =="arabic"){
      value =true;
    }else{
      value =false;
    }

    return  Scaffold(
        backgroundColor: Color(0xFFeeede7),
        appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: Color(0xFFeeede7),
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            leading:  value ==true? IconButton(
                alignment: Alignment.centerRight,
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.black87,
                onPressed: () {
                  _onChangePasswordEnd(context);
                }):IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.black87,
                onPressed: () {
                  _onChangePasswordEnd(context);
                })
        ),
        //drawer: CustomDrawer(),
        body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
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
              child:

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child:   value ==true? Text(
                      "بطاقة المظلة",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ):Text(
                      "Almadallah Card",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  ),
                  InkWell(
                      onTap: () {},
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 15.0, right: 15.0),
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Container(
                                width: MediaQuery.of(context).size.height * .7,
                                //height: 100,
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: ClipPath(
                                            clipper: ShapeBorderClipper(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                              topRight: Radius.circular(15.0),
                                              topLeft: Radius.circular(15.0),
                                            ))),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                                /*width: MediaQuery.of(context)
                                                    .size
                                                    .width,*/
                                                //height: 40,
                                                // color: Color(0xFFb7956c),

                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: Image(
                                                        image: AssetImage(
                                                            'assets/logo.png')),
                                                  ),
                                                )),
                                          ),
                                        ),
                                    getCardDataWidget(widget.alMadallaCardFuture),
                                        // FutureBuilder<AlMadallaMemberModel?>(
                                        //   future:
                                        //       alMadallaCardFuture, // async work
                                        //   builder: (BuildContext context,
                                        //       AsyncSnapshot<AlMadallaMemberModel?>
                                        //           snapshot) {
                                        //     switch (snapshot.connectionState) {
                                        //       case ConnectionState.waiting:
                                        //         return Expanded(
                                        //             flex: 6,
                                        //             child: Center(
                                        //                 child:
                                        //                     CupertinoActivityIndicator()));
                                        //       default:
                                        //         if (snapshot.hasError)
                                        //           return Text("hhh");
                                        //         else
                                        //           return getCardDataWidget(
                                        //               snapshot.data);
                                        //     }
                                        //   },
                                        // ),
                                        Expanded(
                                          flex: 2,
                                          child: Center(
                                            child: Text(
                                              "Note: Pre-approval required for: Dental, Maternity, Optical, Inpatient and Hearing Aids\nToll Free Number: 80043444",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Color(0xFFb7956c)),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
                                      ],
                                    ))),
                          ))),
                ],
              ),
            )));
  }

  Widget getCardDataWidget(AlMadallaMemberModel? alMadallaCardModel) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Expanded(
        flex: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex : 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex : 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Payer:",
                            style:GoogleFonts.poppins(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "Name:",
                            style: GoogleFonts.poppins(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "DOB:",
                            style: GoogleFonts.poppins(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "Card No:",
                            style: GoogleFonts.poppins(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "Emirates ID:",
                            style: GoogleFonts.poppins(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "Employee ID:",
                            style:GoogleFonts.poppins(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex : 3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              //"Rak Insurance",
                              alMadallaCardModel != null
                                  ? alMadallaCardModel.payer ?? 'No data'
                                  : 'No data',
                              style: GoogleFonts.poppins(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              //"Sheikh Ali Khan",
                              //alMadallaCardModel!.nameEnglish ?? 'No data',
                              alMadallaCardModel != null
                                  ? alMadallaCardModel.nameEnglish ?? 'No data'
                                  : 'No data',
                              style:GoogleFonts.poppins(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              //"01-Jan-1983",
                              //alMadallaCardModel.dob ?? 'No data',
                              alMadallaCardModel != null
                                  ? Utils.getDateFormatted(
                                      alMadallaCardModel.dob)
                                  : 'No data',
                              style: GoogleFonts.poppins(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              //"1267256",
                              //alMadallaCardModel.cardNo ?? 'No data',
                              alMadallaCardModel != null
                                  ? alMadallaCardModel.cardNo ?? 'No data'
                                  : 'No data',
                              style:GoogleFonts.poppins(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              //"784199300000006",
                              //alMadallaCardModel.emiratesIDNo ?? 'No data',
                              alMadallaCardModel != null
                                  ? alMadallaCardModel.emiratesIDNo ?? 'No data'
                                  : 'No data',
                              style:GoogleFonts.poppins(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              //"ACT-EID003",
                              //alMadallaCardModel.employeeID ?? 'No data',
                              alMadallaCardModel != null
                                  ? alMadallaCardModel.employeeID ?? 'No data'
                                  : 'No data',
                              style: GoogleFonts.poppins(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex : 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex : 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Policy No:",
                              style: GoogleFonts.poppins(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Category:",
                              style: GoogleFonts.poppins(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Network:",
                              style: GoogleFonts.poppins(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w700,),
                            ),
                            Text(
                              "Effective Date:",
                              style: GoogleFonts.poppins(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w700,

                              ),
                            ),
                            Text(
                              "Expiry Date:",
                              style:GoogleFonts.poppins(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "",
                              style:GoogleFonts.poppins(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                            ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex : 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              //"IF1001EA",
                              alMadallaCardModel != null
                                  ? alMadallaCardModel.policyNo ?? 'No data'
                                  : 'No data',
                              style: GoogleFonts.poppins(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              //"Category A",
                              alMadallaCardModel != null
                                  ? alMadallaCardModel.category ?? 'No data'
                                  : 'No data',
                              style:GoogleFonts.poppins(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              //"GN+",
                              alMadallaCardModel != null
                                  ? alMadallaCardModel.network ?? 'No data'
                                  : 'No data',
                              style: GoogleFonts.poppins(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              //"01-Jan-2021",
                              alMadallaCardModel != null
                                  ? Utils.getDateFormatted(
                                      alMadallaCardModel.policyStartDate)
                                  : 'No data',
                              style: GoogleFonts.poppins(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              //"31-May-2021",
                              alMadallaCardModel != null
                                  ? Utils.getDateFormatted(
                                      alMadallaCardModel.policyEndDate)
                                  : 'No data',
                              style:GoogleFonts.poppins(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "",
                              style:GoogleFonts.poppins(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )));
  }
}
