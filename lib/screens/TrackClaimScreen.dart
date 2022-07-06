import 'package:almadalla/Util/Utils.dart';
import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/customwidgets/CustomDrawer.dart';
import 'package:almadalla/models/AlMadallaMemberModel.dart';
import 'package:almadalla/models/ClaimsModel.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/SearchClaimsParams.dart';
import 'package:almadalla/models/UserSettingsBloc.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/screens/LanguageBloc.dart';
import 'package:almadalla/screens/SettingsScreen.dart';
import 'package:almadalla/screens/TrackClaimSearchScreen.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
class TrackClaimsPage extends StatefulWidget {
  TrackClaimsPage({Key? key, required this.title,required this.loginData}) : super(key: key);

  final String title;
  final LoginData? loginData;
  @override
  _TrackClaimsPageState createState() => _TrackClaimsPageState();
}

class _TrackClaimsPageState extends State<TrackClaimsPage> {
  void _onSettingEnd(context) {
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SettingsPage(title: '')),
    );*/
    Navigator.of(context).pop();
  }
  String? name;
  Future<List<ClaimsModel>?>? trackClaimFuture;
  final _usernameController = TextEditingController();
  bool isLoginProgress = false;
  String errorMessageMember = "";
  String errorMessageClaim = "";
 // Future<AlMadallaMemberModel?>? alMadallaCardFuture;
  AlMadallaMemberModel? alMadallaCardModel;
  int? memberKey;
  String? formattedFromDate;
  String? fromDate;
  String? formattedToDate;
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _selectClaimType;
  final _dateController = TextEditingController();
  String? _selectClaimActionType;
  String? _modeOptionType;
  AlMadallaMemberModel? _memberKey;
  String? _emiratesTypeValue;
  UserSettingsBloc? userSettingsBloc;
  bool value = false;
  LanguageBloc? bloc;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  //String? todayDateFormat = DateFormat('dd-MMM-yyyy','en').format(DateTime.now());
  //String todayDateFormat = DateFormat('dd- MMM-yyyy').format(DateTime.now());
  //DateFormat('dd- MMM-yyyy ').format(DateTime.now());
  DateTime now = DateTime.now();
  DateTime  currentTime = new DateTime( DateTime.now().year,  DateTime.january);
  List<String> _member = [
    'All',
  ];
  List<String> _claimType = [
    'Direct','Reimbursement','Pre Authorization'
  ];
  List<String> _claimAction = [
    'All','Approved','Partially Paid','Pending','Rejected'
  ];

  List<String> _modeOption = [
    'All','Processing','Paid','No Payment {Rejected}','Returned'
  ];
  Future<List<AlMadallaMemberModel>?>? alMadallaCardFuture;
  void initState() {
    alMadallaCardFuture =
        RestDatasource().getAlMadallaMemberDetailsList(widget.loginData);
    super.initState();
  }

  Future<void> _onSearchClicked() async {
    setState(() {
      isLoginProgress = true;
    });

    SearchClaimsParams? searchClaimsParams;
    searchClaimsParams = new SearchClaimsParams();
    searchClaimsParams.memberKey = _memberKey!.memberKey;
    print("memberKey${searchClaimsParams.memberKey}");
    searchClaimsParams.fromDate = _fromDate != null
        ? formattedFromDate
        :DateFormat('dd-MMM-yyyy','en').format(currentTime);
    print("fromDate${searchClaimsParams.fromDate}");
    searchClaimsParams.toDate =
        _toDate != null ? formattedToDate :DateFormat('dd-MMM-yyyy','en').format(now);

    print("toDate${searchClaimsParams.toDate}");

    if(_selectClaimType == null){
      searchClaimsParams.claimType = "1";
    }else{
      if (_selectClaimType == "Direct") {
      searchClaimsParams.claimType = "1";
    } else if (_selectClaimType == "Reimbursement") {
      searchClaimsParams.claimType = "2";
    } else {
      searchClaimsParams.claimType = "3";
    }}

    if (_selectClaimActionType == "Approved") {
      searchClaimsParams.claimAction = "1";
    } else if (_selectClaimActionType == "Partially Paid") {
      searchClaimsParams.claimAction = "2";
    } else if (_selectClaimActionType == "Pending") {
      searchClaimsParams.claimAction = "3";
    } else if (_selectClaimActionType == "Rejected") {
      searchClaimsParams.claimAction = "4";
    } else {
      searchClaimsParams.claimAction = "";
    }

    if (_modeOptionType == "Processing") {
      searchClaimsParams.status = "1";
    } else if (_modeOptionType == "Paid") {
      searchClaimsParams.status = "2";
    } else if (_modeOptionType == "No Payment {Rejected}") {
      searchClaimsParams.status = "3";
    } else if (_modeOptionType == "Returned") {
      searchClaimsParams.status = "4";
    } else {
      searchClaimsParams.status = "";
    }

    print("claimType${searchClaimsParams.claimType}");
    print("claimAction${searchClaimsParams.claimAction}");
    print("status${searchClaimsParams.status}");
    searchClaimsParams.claimRef =
        _usernameController.text.isNotEmpty ? _usernameController.text : "";
    print("claimRef${searchClaimsParams.claimRef}");
    searchClaimsParams.showDependantClaims = true;


    trackClaimFuture =
        RestDatasource().trackClaims(widget.loginData, searchClaimsParams);
  //  if (trackClaimFuture!.isNotEmpty) {
      setState(() {
        isLoginProgress = false;
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => TrackClaimSearchPage(
                  title: '', trackClaimFuture: trackClaimFuture, name:
              name)),
        );
      });
   // }
    // else {
    //   setState(() {
    //     isLoginProgress = false;
    //   });
    //   Utils.showDialogGeneralMessage(
    //       "Please Search With Valid Data", context, false);
    // }
  }
  void _onFromDateClick() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:_fromDate == null? new DateTime(
        DateTime.now().year,
         DateTime.january,
      ):DateTime(
        _fromDate!.year,
        _fromDate!.month,
        _fromDate!.day,
      ),
      // new DateTime(
      //     DateTime.now().year, DateTime.january),
      firstDate:DateTime(1899),
      lastDate: DateTime.now(),//DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _fromDate) {
      setState(() {
        _fromDate = pickedDate;
        formattedFromDate = DateFormat('dd-MMM-yyyy','en').format(_fromDate!);
      });
      print("selectedDatee$_fromDate");
    }
  }

  void _onToDateClick() async {
    final DateTime? pickedToDate = await
    showDatePicker(
      context: context,
      initialDate: _toDate == null? new DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ):DateTime(
        _toDate!.year,
        _toDate!.month,
        _toDate!.day,
      ),
      // new DateTime(
      //     DateTime.now().year,),
      firstDate:DateTime(1899),
      lastDate: DateTime.now(),//DateTime(2100),
    );

    if (pickedToDate != null && pickedToDate != _toDate) {
      setState(() {
        _toDate = pickedToDate;
        formattedToDate = DateFormat('dd-MMM-yyyy','en').format(_toDate!);
      });
      print("selectedDatee$_toDate");
    }
  }

  @override
  Widget build(BuildContext context) {
    userSettingsBloc = Provider.of<UserSettingsBloc>(context, listen: false);
    bloc = Provider.of<LanguageBloc>(context);
    int? val=bloc!.getLanguage() ;
    if(LocaleKeys.language.tr()=="arabic"){
      value =true;
    }else{
      value =false;
    }
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

            // leading: Icon(Icons.arrow_back_ios,color: Colors.white,
            // ),
          ),
        ),
        // drawer: CustomDrawer(),
        body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child:Container(
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Text(
                    LocaleKeys.track_claims.tr(),
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                new Form(
                  key: _formKey,
                  child: Column(children: [
                    new Container(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 15, right: 15.0, bottom: 10.0),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          border: new Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(5.0))
                          // color: Colors.white12,
                          ),
                      alignment: FractionalOffset.center,
                      child: FutureBuilder<List<AlMadallaMemberModel>?>(
                        future:
                        alMadallaCardFuture, // async work
                        builder: (BuildContext context,
                            AsyncSnapshot<List<AlMadallaMemberModel>?>
                            snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Expanded(
                                  flex: 6,
                                  child: Center(
                                      child:
                                      CupertinoActivityIndicator()));
                            default:
                              if (snapshot.hasError)
                                return Text(LocaleKeys.try_again);
                              else
                                return getMemberDataWidget(
                                    snapshot.data);
                          }
                        },
                      ),
                    ),
                    Align(
                        alignment: value == true? Alignment.topRight:Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12.0,
                              right: 12.0,
                              top: 0.0,
                              bottom: 2.0
                          ),
                          child: Text(
                            errorMessageMember,
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          ),
                        )),
                    new Container(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 5.0, top: 0.0, bottom: 5.0),
                      margin: const EdgeInsets.only(
                          top: 0.0, left: 15, right: 15.0, bottom: 10.0),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          border: new Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(5.0))
                          // color: Colors.white12,
                          ),
                      alignment: FractionalOffset.center,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _fromDate != null
                                  ? Text("${formattedFromDate}")

                                  : Text("${DateFormat('dd-MMM-yyyy','en').format(currentTime)}"),
                              IconButton(
                                onPressed: () {
                                  _onFromDateClick();
                                },
                                icon: Image.asset(
                                  'assets/calendar.png',
                                  width: 20.0,
                                  height: 20.0,
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                    new Container(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 15, right: 15.0, bottom: 10.0),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          border: new Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(5.0))
                          // color: Colors.white12,
                          ),
                      alignment: FractionalOffset.center,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _toDate != null
                                  ? Text("${formattedToDate}"):
                           Text("${DateFormat('dd-MMM-yyyy','en').format(now)}"),

                              IconButton(
                                onPressed: () {
                                  _onToDateClick();
                                },
                                icon: Image.asset(
                                  'assets/calendar.png',
                                  width: 20.0,
                                  height: 20.0,
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                    new Container(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 15, right: 15.0, bottom: 10.0),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          border: new Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(5.0))
                          // color: Colors.white12,
                          ),
                      alignment: FractionalOffset.center,
                      child: DropdownButtonFormField<dynamic>(
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                        ),
                        value: _selectClaimType,
                        hint: Text("Direct",
                            //"----" +LocaleKeys.select.tr() +"----",
                            style: TextStyle(
                              color: Colors.black,
                            )),

                        // this is the magic
                        items: _claimType
                            .map<DropdownMenuItem<dynamic>>((dynamic value) {
                          return DropdownMenuItem<dynamic>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (dynamic value) {
                          setState(() {
                            print("Value$value");

                            _selectClaimType = value;
                          });
                        },
                        // validator: (value) =>
                        //     value == null ? 'Please Select Country' : null,
                      ),
                    ),

                    // Align(
                    //     alignment: Alignment.topLeft,
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(
                    //           left: 12.0,
                    //           right: 0.0,
                    //           top: 2.0,
                    //           bottom: 3.0
                    //       ),
                    //       child: Text(
                    //         errorMessageClaim,
                    //         style: TextStyle(fontSize: 12, color: Colors.red),
                    //       ),
                    //     )),
                    new Container(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 5.0, top: 0.0, bottom: 5.0),
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 15, right: 15.0, bottom: 10.0),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          border: new Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(5.0))
                          // color: Colors.white12,
                          ),
                      alignment: FractionalOffset.center,
                      child: new TextFormField(
                        controller: _usernameController,
                        style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                        decoration: new InputDecoration(
                          hintText:LocaleKeys.claim_reference.tr(),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    new Container(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 15, right: 15.0, bottom: 10.0),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          border: new Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(5.0))
                          // color: Colors.white12,
                          ),
                      alignment: FractionalOffset.center,
                      child: DropdownButtonFormField<dynamic>(
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                        ),
                        value: _selectClaimActionType,
                        hint: Text(LocaleKeys.all.tr(),
                           // "----" +LocaleKeys.select.tr() +"----",
                            style: TextStyle(
                              color: Colors.black,
                            )),

                        // this is the magic
                        items: _claimAction
                            .map<DropdownMenuItem<dynamic>>((dynamic value) {
                          return DropdownMenuItem<dynamic>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (dynamic value) {
                          setState(() {
                            print("Value$value");

                            _selectClaimActionType = value;
                          });
                        },
                        // validator: (value) =>
                        //     value == null ? 'Please Select Country' : null,
                      ),
                    ),


                    _selectClaimType=="Reimbursement"? new Container(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      margin: const EdgeInsets.only(
                          top: 10.0, left: 15, right: 15.0, bottom: 10.0),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          border: new Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius:
                          new BorderRadius.all(Radius.circular(5.0))
                        // color: Colors.white12,
                      ),
                      alignment: FractionalOffset.center,
                      child: DropdownButtonFormField<dynamic>(
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                        ),
                        value: _modeOptionType,
                        hint: Text(LocaleKeys.all.tr(),
                            style: TextStyle(
                              color: Colors.black,
                            )),

                        // this is the magic
                        items: _modeOption
                            .map<DropdownMenuItem<dynamic>>((dynamic value) {
                          return DropdownMenuItem<dynamic>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (dynamic value) {
                          setState(() {
                            print("Value$value");

                            _modeOptionType = value;
                          });
                        },
                        // validator: (value) =>
                        //     value == null ? 'Please Select Country' : null,
                      ),
                    ):Container(),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                    InkWell(
                        onTap: () async {
                          if (!isLoginProgress) {
                            if ((_memberKey != null )) {
                              errorMessageMember = "";
                              _onSearchClicked();
                            } else {
                              if (_memberKey == null) {
                                setState(() {
                                  errorMessageMember = LocaleKeys.please_select_member.tr();
                                });
                              } else {
                                setState(() {
                                  errorMessageMember = "";
                                });
                              }
                              // if (_selectClaimType == null) {
                              //   setState(() {
                              //     errorMessageClaim = LocaleKeys.please_select_claim_type.tr();
                              //   });
                              // } else {
                              //   setState(() {
                              //     errorMessageClaim = "";
                              //   });
                              // }
                            }
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
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xFFb89669),
                          ),
                          margin: const EdgeInsets.only(
                              top: 20.0, left: 10.0, right: 10.0,bottom: 30.0),
                          child: Center(
                            child: Text(
                                LocaleKeys.search.tr(),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
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
                    )]),
                  ]),
                )
              ],
            ),
          ),
        )));
  }

  Widget getMemberDataWidget(List<AlMadallaMemberModel>? alMadallaCardModel) {
    // name=alMadallaCardModel != null
    //     ? alMadallaCardModel.nameEnglish ?? 'No data'
    //     : 'No data';
    //
    // memberKey = alMadallaCardModel?.memberKey;

    return DropdownButtonFormField<dynamic>(
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      value: _memberKey,
      hint: RichText(
        text: TextSpan(
            text: LocaleKeys.select_member.tr(),
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red, fontSize: 16.0))
            ]),
      ),

      items: alMadallaCardModel!.map((AlMadallaMemberModel? paramsModel) {
        return DropdownMenuItem<AlMadallaMemberModel?>(
          value: paramsModel,
          child: Text(
            paramsModel != null
                ? paramsModel.nameEnglish ?? 'No data'
                : 'No data',
          ),
        );
      }).toList(),
      // items: _member.map<DropdownMenuItem<dynamic>>((dynamic value) {
      //   return DropdownMenuItem<dynamic>(
      //     value: value,
      //     child: Text(
      //       alMadallaCardModel != null
      //           ? alMadallaCardModel.nameEnglish ?? 'No data'
      //           : 'No data',
      //     ),
      //   );
      // }).toList(),
      onChanged: (dynamic value) {
        setState(() {
          print("Value$value");

          _memberKey = value;
          errorMessageMember = "";
        });
      },
    );
  }

}

