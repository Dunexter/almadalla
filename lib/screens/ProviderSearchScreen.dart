import 'package:almadalla/Util/Utils.dart';
import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/customwidgets/CustomDrawer.dart';
import 'package:almadalla/models/AlMadallaMemberModel.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/NetworkProviderModel.dart';
import 'package:almadalla/models/ParamsModel.dart';
import 'package:almadalla/models/ProviderSearchParams.dart';
import 'package:almadalla/models/UserSettingsBloc.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/screens/HealthCareProviderScreen.dart';
import 'package:almadalla/screens/LanguageBloc.dart';
import 'package:almadalla/screens/SettingsScreen.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProviderSearchPage extends StatefulWidget {
  ProviderSearchPage({Key? key, required this.title,required this.loginData}) : super(key: key);

  final String title;
  final LoginData? loginData;
  @override
  _ProviderSearchPageState createState() => _ProviderSearchPageState();
}

class _ProviderSearchPageState extends State<ProviderSearchPage> {

  List<NetworkProviderModel>? networkProviderModel;

  ParamsModel? _payerType;
  ParamsModel? _networkType;
  ParamsModel? _providerType;
  ParamsModel? _specialityType;
  ParamsModel? _cityType;
  ParamsModel? _locationType;
  String? _emiratesTypeValue;
  // void _onSearchTap(context) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(builder: (_) => HealthCareProviderPage(title: '')),
  //   );
  // }
  bool isLoginProgress = false;
  String? defaultPayerType;
  String? defaultNetworkType;
  Future<List<ParamsModel>?>? payer;
  Future<List<ParamsModel>?>? network;
  Future<List<ParamsModel>?>? providerType;
  Future<List<ParamsModel>?>? speciality;
  Future<List<ParamsModel>?>? city;
  Future<List<ParamsModel>?>? location;
  String errorMessagePayer = "";
  String errorMessageNetwork = "";
  bool isLoggedIn = false;
  void initState() {
    payer =
        RestDatasource().getProviderPayers(widget.loginData);
    network =
        RestDatasource().getProviderNetworks(widget.loginData);
    providerType =
        RestDatasource().getProviderTypes(widget.loginData);
    speciality =
        RestDatasource().getProviderSpecialities(widget.loginData);
    city =
        RestDatasource().getProviderCities(widget.loginData);
    location =
        RestDatasource().getProviderLocations(widget.loginData,"");
    super.initState();
    _checkLoginStatus();
  }
  Future _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token;
    token  = prefs.getString('token');
    print("Token$token");
    if (token != null) {
      print("token$token");
      if (mounted) {
        setState(() {
          isLoggedIn = true;
        });
      }
    }
  }
  Future<void> _onSearchClicked() async {
    setState(() {
      isLoginProgress = true;
    });
    ProviderSearchParams? providerSearchParams;
    providerSearchParams = new ProviderSearchParams();
    setState(() {
      if ( isLoggedIn == false) {
        if(_payerType == null){
        providerSearchParams?.payerKey = -1;
        }
        else{
          providerSearchParams?.payerKey = _payerType?.key;
        }
      }else {
        if(_payerType == null){
        providerSearchParams?.payerKey = userSettingsBloc!.getUserProfile()?.payerKey;
        }
      else{
        providerSearchParams?.payerKey = _payerType?.key;
      }}
      print("payerkey${providerSearchParams?.payerKey}");

      if (isLoggedIn == false) {
        if(_networkType == null){
        providerSearchParams?.networkKey = -1;}else{
          providerSearchParams?.networkKey = _networkType?.key;
        }
     }else{
       if(_networkType == null){
        providerSearchParams?.networkKey = userSettingsBloc!.getUserProfile()?.networkKey;
      }
      else{
        providerSearchParams?.networkKey = _networkType?.key;
      }}
      print("networkKey${providerSearchParams?.networkKey}");
      if (_providerType==null || _providerType?.name == "All") {
        providerSearchParams?.providerTypeKey = -1;
      } else {
        providerSearchParams?.providerTypeKey = _providerType?.key;
      }
      print("providerTypeKey${providerSearchParams?.providerTypeKey}");

      if (_specialityType==null||_specialityType?.name == "All") {
        providerSearchParams?.specialtyKey = -1;
      } else {
        providerSearchParams?.specialtyKey = _specialityType?.key;
      }
      print("specialtyKey${providerSearchParams?.specialtyKey}");
      if (_cityType==null||_cityType?.name == "All") {
        providerSearchParams?.cityKey = -1;
      } else {
        providerSearchParams?.cityKey = _cityType?.key;
      }

      print("cityKey${providerSearchParams?.cityKey}");
      if (_locationType==null||_locationType?.name == "All") {
        providerSearchParams?.locationKey = -1;
      } else {
        providerSearchParams?.locationKey = _locationType?.key;
      }

      print("locationKey${providerSearchParams?.locationKey}");
    });
    setState(() {
      isLoginProgress = true;
    });
    networkProviderModel = await RestDatasource()
        .searchNetworkProviders(widget.loginData, providerSearchParams);

    //if (networkProviderModel!.isNotEmpty) {
      setState(() {
        isLoginProgress = false;
        _locationType= null;
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => HealthCareProviderPage(
                  title: '', networkProviderModel: networkProviderModel)),
        );
      });
    // } else {
    //   setState(() {
    //     isLoginProgress = false;
    //   });
    //   Utils.showDialogGeneralMessage(
    //       "Please Search With Valid Data", context, false);
    // }
  }
  bool value = false;
  UserSettingsBloc? userSettingsBloc;
  LanguageBloc? bloc;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    userSettingsBloc = Provider.of<UserSettingsBloc>(context, listen: false);
    bloc = Provider.of<LanguageBloc>(context);
    defaultPayerType=  userSettingsBloc!.getUserProfile() != null
        ? userSettingsBloc!
        .getUserProfile()!
        .payer ??
        ''
        : '' ;
    defaultNetworkType=  userSettingsBloc!.getUserProfile() != null
        ? userSettingsBloc!
        .getUserProfile()!
        .network ??
        ''
        : '' ;
    int? val=bloc!.getLanguage() ;
    print("languageval$val");
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
              Navigator.of(context).pop();
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Text(
                    LocaleKeys.provider_search.tr(),
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                new Form(
                  key: _formKey,
                  child: Column(children: [
                    Align(
                      alignment: value == true? Alignment.topRight:Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.only(top: 15.0, left: 12.0,right: 12.0),
                        child: RichText(
                          text: TextSpan(
                              text:LocaleKeys.payer.tr(),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                    text: ' *',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 16.0))
                              ]),
                        ),
                      ),
                    ),
                    new Container(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      margin: const EdgeInsets.only(
                          top: 5.0, left: 15, right: 15.0, bottom: 10.0),
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
                      child: FutureBuilder<List<ParamsModel>?>(
                        future: payer, // async work
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ParamsModel>?> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Container(
                                  child: Center(
                                      child: CupertinoActivityIndicator()));
                            default:
                              if (snapshot.hasError)
                                return Text(LocaleKeys.try_again);
                              else
                                return getPayerDataWidget(snapshot.data);
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
                            top: 2.0,
                            bottom: 3.0
                          ),
                          child: Text(
                            errorMessagePayer,
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          ),
                        )),
                    Align(
                      alignment: value == true? Alignment.topRight:Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.only(top: 0.0, left: 12.0,right: 12.0),
                        child: RichText(
                          text: TextSpan(
                              text:LocaleKeys.network.tr(),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                    text: ' *',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 16.0))
                              ]),
                        ),
                      ),
                    ),
                    new Container(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      margin: const EdgeInsets.only(
                          top: 5.0, left: 15, right: 15.0, bottom: 10.0),
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
                    child: FutureBuilder<List<ParamsModel>?>(
                        future: network, // async work
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ParamsModel>?> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Container(
                                  child: Center(
                                      child: CupertinoActivityIndicator()));
                            default:
                              if (snapshot.hasError)
                                return Text(LocaleKeys.try_again);
                              else
                                return getNetworkDataWidget(snapshot.data);
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
                            top: 2.0,
                            bottom: 3.0
                          ),
                          child: Text(
                            errorMessageNetwork,
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          ),
                        )),

                    Align(
                      alignment: value == true? Alignment.topRight:Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.only(top: 0.0, left: 12.0,right: 12.0),
                        child: Text(
                          LocaleKeys.provider_type.tr(),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    new Container(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      margin: const EdgeInsets.only(
                          top: 5.0, left: 15, right: 15.0, bottom: 10.0),
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
                      child: FutureBuilder<List<ParamsModel>?>(
                        future: providerType, // async work
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ParamsModel>?> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Container(
                                  child: Center(
                                      child: CupertinoActivityIndicator()));
                            default:
                              if (snapshot.hasError)
                                return Text(LocaleKeys.try_again);
                              else
                                return getProviderTypeDataWidget(snapshot.data);
                          }
                        },
                      ),
                    ),
                    Align(
                      alignment: value == true? Alignment.topRight:Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.only(top: 0.0, left: 12.0,right: 12.0),
                        child: Text(
                          LocaleKeys.speciality.tr(),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    new Container(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      margin: const EdgeInsets.only(
                          top: 5.0, left: 15, right: 15.0, bottom: 10.0),
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
                      child: FutureBuilder<List<ParamsModel>?>(
                        future: speciality, // async work
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ParamsModel>?> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Container(
                                  child: Center(
                                      child: CupertinoActivityIndicator()));
                            default:
                              if (snapshot.hasError)
                                return Text(LocaleKeys.try_again);
                              else
                                return getSpecialityDataWidget(snapshot.data);
                          }
                        },
                      ),
                    ),
                    Align(
                      alignment: value == true? Alignment.topRight:Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.only(top: 0.0, left: 12.0,right:12.0),
                        child: Text(
                          LocaleKeys.city.tr(),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    new Container(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      margin: const EdgeInsets.only(
                          top: 5.0, left: 15, right: 15.0, bottom: 10.0),
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
                      child: FutureBuilder<List<ParamsModel>?>(
                        future: city, // async work
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ParamsModel>?> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Container(
                                  child: Center(
                                      child: CupertinoActivityIndicator()));
                            default:
                              if (snapshot.hasError)
                                return Text(LocaleKeys.try_again);
                              else
                                return getCityDataWidget(snapshot.data);
                          }
                        },
                      ),
                    ),
                    Align(
                      alignment: value == true? Alignment.topRight:Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.only(top: 0.0, left: 12.0,right: 12.0),
                        child: Text(
                          LocaleKeys.location.tr(),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    new Container(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                      margin: const EdgeInsets.only(
                          top: 5.0, left: 15, right: 15.0, bottom: 10.0),
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
                      child: FutureBuilder<List<ParamsModel>?>(
                        future: location, // async work
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ParamsModel>?> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Container(
                                  child: Center(
                                      child: CupertinoActivityIndicator()));
                            default:
                              if (snapshot.hasError)
                                return Text(LocaleKeys.try_again);
                              else
                                return getLocationDataWidget(snapshot.data);
                          }
                        },
                      ),
                    ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    InkWell(
                        onTap: () async {
                          if (!isLoginProgress) {
                         //   if ((_payerType != null && _networkType != null)) {
                              _onSearchClicked();
                            // } else {
                            //   if (_payerType == null) {
                            //     setState(() {
                            //       errorMessagePayer = LocaleKeys.please_select_payer.tr();
                            //     });
                            //   } else {
                            //     setState(() {
                            //       errorMessagePayer = "";
                            //     });
                            //   }
                            //   if (_networkType == null) {
                            //     setState(() {
                            //       errorMessageNetwork =LocaleKeys.please_select_network.tr();
                            //     });
                            //   } else {
                            //     setState(() {
                            //       errorMessageNetwork = "";
                            //     });
                            //   }
                            // }
                          }
                          //_onSearchTap(context);
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
                              top: 0.0, left: 10.0, right: 10.0,bottom: 30.0),
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
                            margin: const EdgeInsets.only(top: 5.0,bottom: 30),
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

  Widget getPayerDataWidget(List<ParamsModel>? param) {
    return DropdownButtonFormField<dynamic>(
      isExpanded: true,
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      value: _payerType,
      hint:  isLoggedIn == true? Text(defaultPayerType!,
          style: TextStyle(
            color: Colors.black,
          )):Text("None",
          style: TextStyle(
            color: Colors.black,
          )),
      items: param!.map((ParamsModel? paramsModel) {
        return DropdownMenuItem<ParamsModel?>(
          value: paramsModel,
          child: Text(
            paramsModel != null ? paramsModel.name ?? 'No data' : 'No data',
          ),
        );
      }).toList(),
      onChanged:isLoggedIn == false? (dynamic value) {
        setState(() {
          print("Value$value");

          _payerType = value;
          errorMessagePayer = "";
          print("Selected city is ----> $_payerType");
        });
      }:null,
    );
  }

  Widget getNetworkDataWidget(List<ParamsModel>? param) {
    return DropdownButtonFormField<dynamic>(
      isExpanded: true,
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      value: _networkType,
      hint: isLoggedIn == true? Text(defaultNetworkType!,
          style: TextStyle(
            color: Colors.black,
          )):Text("None",
          style: TextStyle(
            color: Colors.black,
          )),
      // Text(LocaleKeys.select_network.tr(),
      //     style: TextStyle(
      //       color: Colors.black,
      //     )),


      items: param!.map((ParamsModel? paramsModel) {
        return DropdownMenuItem<ParamsModel?>(
          value: paramsModel,
          child: Text(
            paramsModel != null ? paramsModel.name ?? 'No data' : 'No data',
          ),
        );
      }).toList(),
      onChanged: isLoggedIn == false?(dynamic value) {
        setState(() {
          print("Value$value");
          _networkType = value;
          errorMessageNetwork = "";
          print("Selected city is ----> $_networkType");
        });
      }:null,
    );
  }

  Widget getProviderTypeDataWidget(List<ParamsModel>? param) {
    if(param! .isNotEmpty){
    if(param[0].name !="All"){
      print("Not Equal--->");
      param.insert(0,ParamsModel(null,"All","All"));
    }}
    return DropdownButtonFormField<dynamic>(
      isExpanded: true,
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      value: _providerType,
      hint: Text(  LocaleKeys.all.tr(),
          style: TextStyle(
            color: Colors.black,
          )),
      items: param.map((ParamsModel? paramsModel) {
        return DropdownMenuItem<ParamsModel?>(
          value: paramsModel,
          child: Text(
            paramsModel != null ? paramsModel.name ?? 'No data' : 'No data',
          ),
        );
      }).toList(),
      onChanged: (dynamic value) {
        setState(() {
          print("Value$value");

          _providerType = value;
          print("Selected  ProviderType ----> $_providerType");
        });
      },
    );
  }

  Widget getSpecialityDataWidget(List<ParamsModel>? param) {
    if(param! .isNotEmpty){
    if(param[0].name !="All"){
      print("Not Equal--->");
      param.insert(0,ParamsModel(null,"All","All"));
    }}
    return DropdownButtonFormField<dynamic>(
      isExpanded: true,
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      value: _specialityType,
      hint: Text( LocaleKeys.all.tr(),
          style: TextStyle(
            color: Colors.black,
          )),
      items: param.map((ParamsModel? paramsModel) {
        return DropdownMenuItem<ParamsModel?>(
          value: paramsModel,
          child: Text(
            paramsModel != null ? paramsModel.name ?? 'No data' : 'No data',
          ),
        );
      }).toList(),
      onChanged: (dynamic value) {
        setState(() {
          print("Value$value");
          _specialityType = value;
          //   errorMessagePayer= "";
          print("Selected speciality is ----> $_specialityType");
        });
      },
    );
  }

  Widget getCityDataWidget(List<ParamsModel>? param) {
    if(param! .isNotEmpty){
    if(param[0].name !="All"){
      print("Not Equal--->");
      param.insert(0,ParamsModel(null,"All","All"));
    }}
    return DropdownButtonFormField<dynamic>(
      isExpanded: true,
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      value: _cityType,
      hint: Text( LocaleKeys.all.tr(),
          style: TextStyle(
            color: Colors.black,
          )),
      items: param.map((ParamsModel? paramsModel) {
        return DropdownMenuItem<ParamsModel?>(
          value: paramsModel,
          child: Text(
            paramsModel != null ? paramsModel.name ?? 'No data' : 'No data',
          ),
        );
      }).toList(),
      onChanged: (dynamic value) {
        setState(() {
          print("Value$value");
          _cityType = value;
          print("Selected City is ----> $_cityType");
        });
        _locationType = null;
        int? key =_cityType!.key;
        print("keyyy$key");
        location =
            RestDatasource().getProviderLocations(widget.loginData,key.toString());
      },
    );
  }

  Widget getLocationDataWidget(List<ParamsModel>? param) {
    if(param! .isNotEmpty){
    if(param[0].name !="All"){
      print("Not Equal--->");
      param.insert(0,ParamsModel(null,"All","All"));
    }}
    return DropdownButtonFormField<dynamic>(
      isExpanded: true,
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      value: _locationType,
      hint: Text( LocaleKeys.all.tr(),
          style: TextStyle(
            color: Colors.black,
          )),
      items: param.map((ParamsModel? paramsModel) {
        return DropdownMenuItem<ParamsModel?>(
          value: paramsModel,
          child: Text(
            paramsModel != null ? paramsModel.name ?? 'No data' : 'No data',
          ),
        );
      }).toList(),
      onChanged: (dynamic value) {
        setState(() {
          print("Value$value");
          _locationType = value;
          print("Selected Location is ----> $_locationType");
        });
        },

    );
  }
}
