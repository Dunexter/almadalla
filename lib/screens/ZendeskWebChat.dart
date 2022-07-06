import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/customwidgets/CustomDrawer.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/UserProfile.dart';
import 'package:almadalla/models/UserSettingsBloc.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/screens/SettingsScreen.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class ZendeskWebChat extends StatefulWidget {
  //ZendeskWebChat({Key? key, required this.title,required this.loginData}) : super(key: key);
  ZendeskWebChat({required this.title});

  final String title;
  //final LoginData? loginData;
  @override
  _ZendeskWebChatState createState() => _ZendeskWebChatState();
}

class _ZendeskWebChatState extends State<ZendeskWebChat> {
  void _onSettingEnd(context) {
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SettingsPage(title: '')),
    );*/
    Navigator.of(context).pop();
  }

  bool isLoginProgress = false;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  UserSettingsBloc? userSettingsBloc;

  String? name;
  String errorMessageUserName = "";
  String errorMessageEmail = "";

  final key = UniqueKey();

  dom.Document? document;
  String htmlData = '<html>' +
      '<head>' +
      '</head>' +
      '<script id="ze-snippet" src="https://static.zdassets.com/ekr/snippet.js?key=ba4bf50b-d699-4b14-b3a7-95e1a607723b"> </script>' +
      '<body>' +
      'Al madalla chat zendesk' +
      '</body>' +
      '</html>';

  init() {
    document = htmlparser.parse(htmlData);
  }

  UserProfile? userProfile;

  initState() {
    //_getUserProfile();
    super.initState();
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    userSettingsBloc = Provider.of<UserSettingsBloc>(context, listen: false);
    // _usernameController.text=name!;
    //  _emailController.text=email!;
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
        body: SingleChildScrollView(
            child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 20),
              height: MediaQuery.of(context).size.height * .90,
              child: WebView(
                initialUrl:
                    'https://static.zdassets.com/web_widget/latest/liveChat.html?v=10#key=f5tech.zendesk.com', //'http://172.104.183.232/testing/chat/',
                javascriptMode: JavascriptMode.unrestricted,
                key: key,

                onWebViewCreated: (controller) {
                  print("FInished onWebViewCreated ------>");
                  // here you can access the WebViewController
                 // controller.evaluateJavascript(
                   //   "document.getElementsByClassName('header')[0].style.display='none';");
                },
                onPageFinished: (finish) async {
                  await Future.delayed(Duration(seconds: 3));
                  print("FInished loading page ------>");
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
            ),
            isLoading
                ? Positioned.fill(
                    child: Align(
                        alignment: Alignment.center,
                        child: Container(
                            //width: 10,
                            margin: const EdgeInsets.only(top: 20.0),
                            child: Column(
                              mainAxisAlignment:MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                              CupertinoActivityIndicator(),
                              Text(LocaleKeys.wait.tr())
                            ]))),
                  )
                : Container(
                    width: 10,
                  )
          ],
        )

            /*Container(
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
                child: Column(children: [
                  Center(
                    child: Text(
                      //LocaleKeys.profile.tr(),
                      "Support",
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  /*Container(
                      height: 500,
                      color: Colors.blue,
                      /*child: Html(
                      data: htmlData,
                    ),*/
                      child: WebviewScaffold(
                        url: Uri.dataFromString(_loadHTML(),
                                mimeType: 'text/html')
                            .toString(),
                        withJavascript: true,
                      ))*/
                  //HtmlWidget(htmlData,webView: true,),
                  Container(
                    padding: EdgeInsets.only(bottom:20),
                    height: MediaQuery.of(context).size.height*.80,
                    child: WebView(
                      initialUrl: 'https://static.zdassets.com/web_widget/latest/liveChat.html?v=10#key=f5tech.zendesk.com',//'http://172.104.183.232/testing/chat/',
                      javascriptMode: JavascriptMode.unrestricted,
                    ),
                  )
                ]))*/
            ));
  }

  String _loadHTML() {
    return '<html>' +
        '<head>' +
        '</head>' +
        '<script id="ze-snippet" src="https://static.zdassets.com/ekr/snippet.js?key=ba4bf50b-d699-4b14-b3a7-95e1a607723b"> </script>' +
        '<body>' +
        'Al madalla chat zendesk' +
        '</body>' +
        '</html>';
  }
}
