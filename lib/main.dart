// import 'package:almadalla/screens/LanguageBloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'screens/OnBoardingPage.dart';
//
// void main() {
//   SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp,
//         DeviceOrientation.portraitDown,
//       ]);
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   static void setLocale(BuildContext context,Locale locale){
//     _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
//     state.setLocale(locale);
//
//   }
//   // This widget is the root of your application.
//   Locale? _locale;
//   void setLocale(Locale locale){
//     setState(() {
//       _locale = locale;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<LanguageBloc>(builder: (context)=>LanguageBloc(),
//
//     child: Listener(
//       onPointerDown: (e){ Utils.resetTimer(); },
//       child: MaterialApp(
//         locale: _locale,
//         supportedLocales:[
//           Locale('en','US'),
//           Locale('ar','SA')
//         ] ,
//         localizationsDelegates: [
//           DemoLocalizations.delegate,
//           GlobalMaterialLocalizations.delegate,
//           GlobalWidgetsLocalizations.delegate,
//           GlobalCupertinoLocalizations.delegate,
//         ],
//         localeResolutionCallback: (deviceLocale,supportedLocales){
//           for(var locale in supportedLocales){
//             if(locale.languageCode == deviceLocale!.languageCode && locale.countryCode == deviceLocale!.countryCode){
//               return deviceLocale;
//             }
//           }
//           return supportedLocales.first;
//         },
//
//         debugShowCheckedModeBanner: false,
//         home: OnBoardingPage(),),
//     ),);
//     // return MaterialApp(
//     //   title: 'Almadalla Healthcare',
//     //   theme: ThemeData(
//     //     // This is the theme of your application.
//     //     //
//     //     // Try running your application with "flutter run". You'll see the
//     //     // application has a blue toolbar. Then, without quitting the app, try
//     //     // changing the primarySwatch below to Colors.green and then invoke
//     //     // "hot reload" (press "r" in the console where you ran "flutter run",
//     //     // or simply save your changes to "hot reload" in a Flutter IDE).
//     //     // Notice that the counter didn't reset back to zero; the application
//     //     // is not restarted.
//     //     primarySwatch: Colors.blue,
//     //   ),
//     //   home: OnBoardingPage(),
//     // );
//   }
// }

import 'package:almadalla/screens/LanguageBloc.dart';
import 'package:almadalla/screens/LoginPage.dart';
import 'package:almadalla/translation/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/Constants.dart';
import 'models/UserSettingsBloc.dart';
import 'screens/OnBoardingPage.dart';
import 'package:almadalla/screens/Selectionpage.dart';
import 'package:almadalla/screens/webpage.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  /*SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);*/
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  //OneSignal.shared.setAppId("7249e1e9-b7ff-4131-806c-4fc6079b1630");
  OneSignal.shared.setAppId(Constants.OneSignalPushNotificationAppID);

/*
  /// Get the Onesignal userId and update that into the firebase.
    /// So, that it can be used to send Notifications to users later.̥
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;    

    print("OneSignal USER ID ------------------------------------------>>>>>>>$osUserID<<--");
    // Store it into shared prefs, So that later we can use it.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('OnesignalUserId', osUserID!);
    print("OneSignal USER ID in pref----------------------------------->>>>>>>${prefs.getString('OnesignalUserId')}<<--");

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  prefs.setBool('OnesignalPushAccepted', false);
  print("OnesignalPushAccepted initial in pref----------------------------------->>>>>>>${prefs.getBool('OnesignalPushAccepted')}<<--");

*/

  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("One signal push Accepted permission: $accepted");
    /*prefs.setBool('OnesignalPushAccepted', accepted);
    //prefs.setInt('OneSignalNotificationPermissionStatusKey', '$accepted!');

    print("OnesignalPushAccepted in pref----------------------------------->>>>>>>${prefs.getBool('OnesignalPushAccepted')}<<--");
    print("OneSignalNotificationPermissionStatusKey in pref----------------------------------->>>>>>>${prefs.getString('OneSignalNotificationPermissionStatusKey')}<<--");*/
  });

  /*OneSignal.shared.getDeviceState().then((deviceState) {
     print("OneSignal device state ------------------------------------>>>> ${deviceState!.jsonRepresentation()}");
  });*/

  OneSignal.shared
      .setEmailSubscriptionObserver((OSEmailSubscriptionStateChanges changes) {
    print(
        "-------------------->>>O neSignal: email subscription changed: ${changes.jsonRepresentation()}");
  });

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: [
        Locale('en'),
        Locale('ar'),
      ],
      fallbackLocale: Locale('en'),
      assetLoader: CodegenLoader(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(locale);
  }

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

bool isShowPage = false;

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  void initState() {
    _checkLoginStatus();
    super.initState();
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  Future _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? status;
    status = prefs.getBool('pageStatus');
    print("status$status");
    if (status == true) {
      if (mounted) {
        setState(() {
          isShowPage = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
        //                                     <--- MultiProvider
        providers: [
          ChangeNotifierProvider<LanguageBloc>(
              create: (context) => LanguageBloc()),
          ChangeNotifierProvider<UserSettingsBloc>(
              create: (context) => UserSettingsBloc()),
        ],
        child: Listener(
          // onPointerDown: (e){ Utils.resetTimer(); },
          child: MaterialApp(
              navigatorKey: navigatorKey,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              home: isShowPage == false
                  ? OnBoardingPage()
                  : Selectionpage(
                      title: '',
                    ),
              routes: <String, WidgetBuilder>{
                "/LoginPage": (BuildContext context) =>
                    new Selectionpage(title: ""),
                "/webpage": (BuildContext context) =>
                    new Selectionpage(title: "")
                //add more routes here
              }),
        ));
  }
}
