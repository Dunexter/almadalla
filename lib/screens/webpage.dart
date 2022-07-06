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
import 'package:almadalla/screens/LoginPage.dart';
import 'package:almadalla/screens/SettingsScreen.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class webpage extends StatefulWidget {
  @override
  _webpageState createState() => _webpageState();
}

class _webpageState extends State<webpage> {
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

  Future _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token;
    token = prefs.getString('token');
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
      if (isLoggedIn == false) {
        if (_payerType == null) {
          providerSearchParams?.payerKey = -1;
        } else {
          providerSearchParams?.payerKey = _payerType?.key;
        }
      } else {
        if (_payerType == null) {
          providerSearchParams?.payerKey =
              userSettingsBloc!.getUserProfile()?.payerKey;
        } else {
          providerSearchParams?.payerKey = _payerType?.key;
        }
      }
      print("payerkey${providerSearchParams?.payerKey}");

      if (isLoggedIn == false) {
        if (_networkType == null) {
          providerSearchParams?.networkKey = -1;
        } else {
          providerSearchParams?.networkKey = _networkType?.key;
        }
      } else {
        if (_networkType == null) {
          providerSearchParams?.networkKey =
              userSettingsBloc!.getUserProfile()?.networkKey;
        } else {
          providerSearchParams?.networkKey = _networkType?.key;
        }
      }
      print("networkKey${providerSearchParams?.networkKey}");
      if (_providerType == null || _providerType?.name == "All") {
        providerSearchParams?.providerTypeKey = -1;
      } else {
        providerSearchParams?.providerTypeKey = _providerType?.key;
      }
      print("providerTypeKey${providerSearchParams?.providerTypeKey}");

      if (_specialityType == null || _specialityType?.name == "All") {
        providerSearchParams?.specialtyKey = -1;
      } else {
        providerSearchParams?.specialtyKey = _specialityType?.key;
      }
      print("specialtyKey${providerSearchParams?.specialtyKey}");
      if (_cityType == null || _cityType?.name == "All") {
        providerSearchParams?.cityKey = -1;
      } else {
        providerSearchParams?.cityKey = _cityType?.key;
      }

      print("cityKey${providerSearchParams?.cityKey}");
      if (_locationType == null || _locationType?.name == "All") {
        providerSearchParams?.locationKey = -1;
      } else {
        providerSearchParams?.locationKey = _locationType?.key;
      }

      print("locationKey${providerSearchParams?.locationKey}");
    });
    setState(() {
      isLoginProgress = true;
    });

    //if (networkProviderModel!.isNotEmpty) {
    setState(() {
      isLoginProgress = false;
      _locationType = null;
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
    defaultPayerType = userSettingsBloc!.getUserProfile() != null
        ? userSettingsBloc!.getUserProfile()!.payer ?? ''
        : '';
    defaultNetworkType = userSettingsBloc!.getUserProfile() != null
        ? userSettingsBloc!.getUserProfile()!.network ?? ''
        : '';
    int? val = bloc!.getLanguage();
    print("languageval$val");
    if (LocaleKeys.language.tr() == "arabic") {
      value = true;
    } else {
      value = false;
    }
    return Scaffold(
        backgroundColor: Color(0xFFeeede7),
        // appBar: AppBar(
        //   title: Text("Test Screen"),
        //   titleTextStyle: TextStyle(color: Colors.black),
        //   backgroundColor: Color(0xFFeeede7),
        //   actions: <Widget>[
        //     FlatButton(
        //       textColor: Color(0xFFeeede7),
        //       onPressed: () {},
        //       child: Text(
        //         "Go to \nSelf Funded",
        //         style: TextStyle(fontSize: 10),
        //         textAlign: TextAlign.center,
        //       ),
        //       shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
        //     ),
        //   ],
        // ),
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('   Welcome To Insurance Portal'),
            // centerTitle: true,
            titleTextStyle: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
            backgroundColor: Color(0xFFeeede7),
            elevation: 0,
            actions: <Widget>[
              FlatButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(
                                title: '',
                              )));
                },
                textColor: Colors.black,
                child: Text(
                  "Go to \nSelf Funded Portal",
                  style: TextStyle(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              )
            ]
            // iconTheme: IconThemeData(color: Colors.black),
            // leading: IconButton(
            //     icon: Icon(Icons.arrow_back_ios),
            //     color: Colors.black87,
            //     onPressed: () async {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => LoginPage(
            //                     title: '',
            //                   )));
            //     }
            //     // {
            //     //   Navigator.of(context).pop();
            //     // },

            //     // leading: Icon(Icons.arrow_back_ios,color: Colors.white,
            //     // ),
            //     ),
            ),

        //drawer: CustomDrawer(),
        body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Scaffold(
              body: Container(
                child: Center(
                    child: WebView(
                  initialUrl: 'https://payer.almadallah.ae/w1.aspx',
                  javascriptMode: JavascriptMode.unrestricted,
                )),
              ),
            )
            // Container(
            //   height: MediaQuery.of(context).size.height,
            //   width: MediaQuery.of(context).size.width,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(50),
            //     // borderRadius: BorderRadius.all(Radius.circular(100.0)),
            //     image: DecorationImage(
            //       image: AssetImage("assets/login.jpg"),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            //   child: SingleChildScrollView(
            //     child: Column(
            //       children: [
            //         Center(
            //           child: SafeArea(
            //             child: WebView(
            //               initialUrl: 'https://payer.almadallah.ae/w1.aspx',
            //               javascriptMode: JavascriptMode.unrestricted,
            //             ),
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // )
            ));
  }
}
