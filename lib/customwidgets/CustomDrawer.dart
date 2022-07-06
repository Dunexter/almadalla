import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/models/UserProfile.dart';
import 'package:almadalla/models/UserSettingsBloc.dart';
import 'package:almadalla/screens/AlMadallaCard.dart';
import 'package:almadalla/screens/AlMadallaCardListScreen.dart';
import 'package:almadalla/screens/BankAccountsScreen.dart';
import 'package:almadalla/screens/ContactScreen.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/screens/DownloadsScreen.dart';
import 'package:almadalla/screens/LanguageBloc.dart';
import 'package:almadalla/screens/LoginPage.dart';
import 'package:almadalla/screens/MemberDetailsScreen.dart';
import 'package:almadalla/screens/MemberUtilizationsScreen.dart';
import 'package:almadalla/screens/ProviderSearchScreen.dart';
import 'package:almadalla/screens/RequestScreen.dart';
import 'package:almadalla/screens/SettingsScreen.dart';
import 'package:almadalla/screens/SubmitClaimsScreen.dart';
import 'package:almadalla/screens/TrackClaimScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:almadalla/screens/webpage.dart';
// This is a test page only

class CustomDrawer extends StatefulWidget {
  //CustomDrawer({Key? key, required this.title}) : super(key: key);

  //final String title;

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isLoggedIn = false;
  String? name;
  int? val;
  void initState() {
    _checkLoginStatus();
    super.initState();
  }

  bool value = false;
  Future _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token;
    token = prefs.getString('token');
    // name=prefs.getString('name');
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

  Future _logoutStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    Navigator.of(context).pop();
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new LoginPage(title: '')));
  }

  UserSettingsBloc? userSettingsBloc;
  LanguageBloc? bloc;
  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LoginPage(title: '')),
    );
  }

  _makingPhoneCall() async {
    const url = 'tel:80043444';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    userSettingsBloc = Provider.of<UserSettingsBloc>(context, listen: false);
    bloc = Provider.of<LanguageBloc>(context);
    int? val = bloc!.getLanguage();
    if (LocaleKeys.language.tr() == "arabic") {
      value = true;
    } else {
      value = false;
    }
    return Drawer(
      child: new ListView(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
                child: Column(children: <Widget>[
              Container(
                  height:
                      100.0, //LocaleKeys.language.tr()=="english"?100.0:200.0,
                  decoration: BoxDecoration(
                      color: Color(0xFFc5a56a),
                      border: Border.all(
                        color: Color(0xFFc5a56a),
                      ),
                      borderRadius: LocaleKeys.language.tr() == "english"
                          ? BorderRadius.only(
                              bottomRight: Radius.circular(80.0))
                          : BorderRadius.only(
                              bottomLeft: Radius.circular(80.0))),
                  child: Row(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            }, // handle your image tap here
                            child: Image.asset(
                              LocaleKeys.language.tr() == "english"
                                  ? 'assets/arrow-left.png'
                                  : 'assets/arrow-right.png',
                              color: Colors.white,
                              width: 25,
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 5.0),
                          child: Container(
                            child: Row(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/user.png',
                                  // color: Colors.white,
                                  width: 30,
                                ),
                                // RawMaterialButton(
                                //   onPressed: () {},
                                //   elevation: 2.0,
                                //   fillColor: Colors.white,
                                //   child: Image.asset(
                                //     'assets/bottom_menu_account.png',
                                //     color: Color(0xFFb7956c),
                                //     width: 15,
                                //     height: 15.0,
                                //   ),
                                //   padding: EdgeInsets.all(10.0),
                                //   shape: CircleBorder(),
                                // ),
                                isLoggedIn
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0, right: 10.0, top: 30.0),
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(LocaleKeys.my_account.tr(),
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  userSettingsBloc!
                                                              .getUserProfile() !=
                                                          null
                                                      ? userSettingsBloc!
                                                              .getUserProfile()!
                                                              .name ??
                                                          'No data'
                                                      : 'No data',
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                        ))
                                    : InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();

                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    LoginPage(title: '')),
                                          );
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                              left: 10.0,
                                              right: 10,
                                            ),
                                            child: Text(LocaleKeys.sign_in.tr(),
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold))))
                              ],
                            ),
                          ))
                    ],
                  )),
              Container(
                //color: Color(0xFFb7956c),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          value != false
                              ? ElevatedButton(
                                  onPressed: () async {
                                    bloc!.setLanguage(1);
                                    await context.setLocale(Locale('en'));
                                  },
                                  child: const Text(
                                    'English',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(130, 50),
                                    primary: Color(0xFFb89669),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    bloc!.setLanguage(2);
                                    await context.setLocale(Locale('ar'));
                                  },
                                  child: const Text(
                                    'عربي',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(130, 50),
                                    primary: Color(0xFFb89669),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                  ),
                                ),
                          ElevatedButton(
                            onPressed: () async {
                              _makingPhoneCall();
                            },
                            child: const Text(
                              'Call Center',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(130, 50),
                              primary: Color(0xFFb89669),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Image.asset(
                        'assets/drawer_provider.png',
                        width: 20.0,
                        height: 20.0,
                      ),
                      //Icon(Icons.add_shopping_cart,color: Colors.black,),
                      trailing: Image.asset(
                        "assets/${LocaleKeys.menu_list_arrow.tr()}",
                        width: 15.0,
                        height: 15.0,
                      ),
                      title: Text(
                        "Login to Insurance",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),

                      onTap: () async {
                        // String url =
                        //     'https://payer.almadallah.ae/Member/Link.aspx';
                        // if (await canLaunch(url)) {
                        //   await launch(url, forceSafariVC: false);
                        // } else {
                        //   print("No Supported Browser");
                        // }

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => webpage()));
                      },
                    ),
                    isLoggedIn
                        ? ListTile(
                            leading: Image.asset(
                              'assets/menu_home.png',
                              color: Color(0xFFc5a56a),
                              width: 20.0,
                              height: 20.0,
                            ),
                            trailing: Image.asset(
                              "assets/${LocaleKeys.menu_list_arrow.tr()}",
                              width: 15.0,
                              height: 15.0,
                            ),
                            title: Text(
                              LocaleKeys.home.tr(),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        DashBoardPage(title: 'Dashboard')),
                              );
                            },
                          )
                        : Container(height: 0, width: 0),
                    isLoggedIn
                        ? ListTile(
                            leading: Image.asset(
                              'assets/drawer_card.png',
                              width: 20.0,
                              height: 20.0,
                            ),
                            trailing: Image.asset(
                              "assets/${LocaleKeys.menu_list_arrow.tr()}",
                              width: 15.0,
                              height: 15.0,
                            ),
                            title: Text(
                              LocaleKeys.al_madallah_card.tr(),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => AlMadallaCardListScreen(
                                        title: '',
                                        loginData:
                                            userSettingsBloc!.getLoginData())),
                              );
                            },
                          )
                        : Container(height: 0, width: 0),
                    isLoggedIn
                        ? ListTile(
                            leading: Image.asset(
                              'assets/member-details.png',
                              color: Color(0xFFb7956c),
                              width: 20.0,
                              height: 20.0,
                            ),
                            trailing: Image.asset(
                              "assets/${LocaleKeys.menu_list_arrow.tr()}",
                              width: 15.0,
                              height: 15.0,
                            ),
                            title: Text(
                              LocaleKeys.member_details.tr(),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => MemberDetailsPage(
                                        title: '',
                                        loginData:
                                            userSettingsBloc!.getLoginData())),
                              );
                            },
                          )
                        : Container(height: 0, width: 0),
                    isLoggedIn
                        ? ListTile(
                            leading: Image.asset(
                              'assets/drawer_utilization.png',
                              width: 20.0,
                              height: 20.0,
                            ),
                            trailing: Image.asset(
                              "assets/${LocaleKeys.menu_list_arrow.tr()}",
                              width: 15.0,
                              height: 15.0,
                            ),
                            title: Text(
                              LocaleKeys.member_utilization.tr(),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => MemberUtilizationPage(
                                        title: '',
                                        loginData:
                                            userSettingsBloc!.getLoginData())),
                              );
                            },
                          )
                        : Container(height: 0, width: 0),
                    ListTile(
                      leading: Image.asset(
                        'assets/drawer_provider.png',
                        width: 20.0,
                        height: 20.0,
                      ),
                      //Icon(Icons.add_shopping_cart,color: Colors.black,),
                      trailing: Image.asset(
                        "assets/${LocaleKeys.menu_list_arrow.tr()}",
                        width: 15.0,
                        height: 15.0,
                      ),
                      title: Text(
                        LocaleKeys.provider_search.tr(),
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),

                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => ProviderSearchPage(
                                  title: '',
                                  loginData: userSettingsBloc!.getLoginData())),
                        );
                      },
                    ),
                    isLoggedIn
                        ? ListTile(
                            leading: Image.asset(
                              'assets/drawer_track.png',
                              width: 20.0,
                              height: 20.0,
                            ),
                            trailing: Image.asset(
                              "assets/${LocaleKeys.menu_list_arrow.tr()}",
                              width: 15.0,
                              height: 15.0,
                            ),
                            title: Text(
                              LocaleKeys.track_claims.tr(),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => TrackClaimsPage(
                                        title: '',
                                        loginData:
                                            userSettingsBloc!.getLoginData())),
                              );
                            },
                          )
                        : Container(height: 0, width: 0),
                    isLoggedIn
                        ? ListTile(
                            leading: Image.asset(
                              'assets/drawer_track.png',
                              width: 20.0,
                              height: 20.0,
                            ),
                            trailing: Image.asset(
                              "assets/${LocaleKeys.menu_list_arrow.tr()}",
                              width: 15.0,
                              height: 15.0,
                            ),
                            title: Text(
                              LocaleKeys.bank_accounts.tr(),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => BankAccountsPage(
                                    title: '',
                                    loginData: userSettingsBloc!.getLoginData(),
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(height: 0, width: 0),
                    isLoggedIn
                        ? ListTile(
                            leading: Image.asset(
                              'assets/drawer_submit.png',
                              width: 20.0,
                              height: 20.0,
                            ),
                            trailing: Image.asset(
                              "assets/${LocaleKeys.menu_list_arrow.tr()}",
                              width: 15.0,
                              height: 15.0,
                            ),
                            title: Text(
                              LocaleKeys.submit_claims.tr(),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => SubmitClaimsPage(
                                          title: '',
                                          loginData:
                                              userSettingsBloc!.getLoginData(),
                                        )),
                              );
                            },
                          )
                        : Container(height: 0, width: 0),
                    isLoggedIn
                        ? ListTile(
                            leading: Image.asset(
                              'assets/drawer_submit.png',
                              width: 20.0,
                              height: 20.0,
                            ),
                            trailing: Image.asset(
                              "assets/${LocaleKeys.menu_list_arrow.tr()}",
                              width: 15.0,
                              height: 15.0,
                            ),
                            title: Text(
                              LocaleKeys.requests.tr(),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => RequestScreen(
                                        title: '',
                                        loginData:
                                            userSettingsBloc!.getLoginData())),
                              );
                            },
                          )
                        : Container(height: 0, width: 0),
                    isLoggedIn
                        ? ListTile(
                            leading: Image.asset(
                              'assets/drawer_submit.png',
                              width: 20.0,
                              height: 20.0,
                            ),
                            trailing: Image.asset(
                              "assets/${LocaleKeys.menu_list_arrow.tr()}",
                              width: 15.0,
                              height: 15.0,
                            ),
                            title: Text(
                              LocaleKeys.downloads.tr(),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => DownloadsScreen(
                                        title: '',
                                        loginData:
                                            userSettingsBloc!.getLoginData())),
                              );
                            },
                          )
                        : Container(height: 0, width: 0),
                    isLoggedIn
                        ? ListTile(
                            leading: Image.asset(
                              'assets/drawer_settings.png',
                              width: 20.0,
                              height: 20.0,
                            ),
                            trailing: Image.asset(
                              "assets/${LocaleKeys.menu_list_arrow.tr()}",
                              width: 15.0,
                              height: 15.0,
                            ),
                            title: Text(
                              LocaleKeys.settings.tr(),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => SettingsPage(
                                        title: '',
                                        loginData:
                                            userSettingsBloc!.getLoginData())),
                              );
                            },
                          )
                        : Container(height: 0, width: 0),
                    ListTile(
                      leading: Image.asset(
                        'assets/drawer_contact.png',
                        width: 20.0,
                        height: 20.0,
                      ),
                      trailing: Image.asset(
                        "assets/${LocaleKeys.menu_list_arrow.tr()}",
                        width: 15.0,
                        height: 15.0,
                      ),
                      title: Text(
                        LocaleKeys.contact_us.tr(),
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => ContactPage(title: '')),
                        );
                      },
                    ),
                    isLoggedIn
                        ? ListTile(
                            leading: Image.asset(
                              'assets/log_out.png',
                              color: Color(0xFFb7956c),
                              width: 20.0,
                              height: 20.0,
                            ),
                            trailing: Image.asset(
                              "assets/${LocaleKeys.menu_list_arrow.tr()}",
                              width: 15.0,
                              height: 15.0,
                            ),
                            title: Text(
                              LocaleKeys.logout.tr(),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                            onTap: () {
                              _logoutStatus();
                            },
                          )
                        : Container(height: 0, width: 0),
                  ],
                ),
              ),
            ])),
          ),
        ],
      ),
    );
    // return Drawer(
    //   child: ListView(
    //     padding: EdgeInsets.zero,
    //     children: <Widget>[
    //       DrawerHeader(
    //         child: Text('Drawer Header'),
    //         decoration: BoxDecoration(
    //           color: Colors.blue,
    //         ),
    //       ),
    //       ListTile(
    //         title: Text('Item 1'),
    //         onTap: () {
    //           // Update the state of the app.
    //           // ...
    //         },
    //       ),
    //       ListTile(
    //         title: Text('Item 2'),
    //         onTap: () {
    //           // Update the state of the app.
    //           // ...
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }
}
