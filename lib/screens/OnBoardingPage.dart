import 'package:almadalla/screens/LoginPage.dart';
import 'package:almadalla/screens/Selectionpage.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'LanguageBloc.dart';
import 'language.dart';
import 'package:almadalla/screens/SecondarySplash.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) =>
              Selectionpage(title: '')), // it was LoginPage(title: '') earlier
    );
  }

  bool _display = true;
  void initState() {
    _checkPageStatus();
    super.initState();
  }

  Future _checkPageStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("pageStatus", _display);
  }

  LanguageBloc? bloc;
  Widget _buildFullscrenImage(String assetName) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        // borderRadius: BorderRadius.all(Radius.circular(100.0)),
        image: DecorationImage(
          image: AssetImage("assets/$assetName" + "_bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      //color: Colors.red,
      child: Center(
        child: Container(
          height: assetName == 'language'
              ? MediaQuery.of(context).size.height * .3
              : MediaQuery.of(context).size.height * .4,
          //  width: 100,//double.infinity,
          child: Image.asset(
            'assets/$assetName.png',
            alignment: Alignment.center,
          ),
        ),
      )
      /*child: Center(
        child: assetName == 'language'
            ? Padding(
              padding: const EdgeInsets.only(bottom:0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom:20),
                    width: MediaQuery.of(context).size.width * .8,
                    child: Image.asset(
                          'assets/logo_long.png',
                          alignment: Alignment.center,
                        ),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * .3,
                      //  width: 100,//double.infinity,
                      child: Image.asset(
                        'assets/$assetName.png',
                        alignment: Alignment.center,
                      ),
                    ),
                ],
              ),
            )
            : Container(
                height: MediaQuery.of(context).size.height * .4,
                //  width: 100,//double.infinity,
                child: Image.asset(
                  'assets/$assetName.png',
                  alignment: Alignment.center,
                ),
              ),
      )*/
      ,
    );
  }

  /*Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }*/

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<LanguageBloc>(context);
    int? lang = bloc!.getLanguage();
    void _changeLang(language _language) {
      Locale _temp;
      switch (_language.languagecode) {
        case 'en':
          _temp = Locale(_language.languagecode, 'en');
          break;
        case 'ar':
          _temp = Locale(_language.languagecode, 'ar');
          break;
        default:
          _temp = Locale(_language.languagecode, 'US');
      }
      MyApp.setLocale(context, _temp);
    }

    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(home: SecondarySplash());
        } else {
          // Loading is done, return the intro:
          return introScreens();
        }
      },
    );
  }

  Widget introScreens() {
    const bodyStyle = TextStyle(fontSize: 19.0, color: Color(0xFFa27b4b));
    const titleStyle = TextStyle(
        fontSize: 30.0, fontWeight: FontWeight.w600, color: Color(0xFFa27b4b));

    const pageDecoration = const PageDecoration(
      titleTextStyle: titleStyle,
      bodyTextStyle: bodyStyle,
      //descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      //pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      /*globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: _buildImage('flutter.png', 100),
          ),
        ),
      ),
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const Text(
            'Let\s go right away!',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),*/
      pages: [
        /*PageViewModel(
          title: "Fractional shares",
          body:
              "Instead of having to buy an entire share, invest any amount you want.",
          image: _buildImage('introscreen1.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Learn as you go",
          body:
              "Download the Stockpile app and master the market with our mini-lesson.",
          image: _buildImage('introscreen2.png'),
          decoration: pageDecoration,
        ),*/
        /*PageViewModel(
          title: "Kids and teens",
          body:
              "Kids and teens can track their stocks 24/7 and place trades that you approve.",
          image: _buildImage('img3.jpg'),
          decoration: pageDecoration,
        ),*/
        PageViewModel(
          title:
              "Submit Reimbursement Claim\nتقديم مطالبة السداد", //"Full Screen Page",
          body:
              "", //"Almadalla healthcare has a strong medical background team, supporting memebers and",
          //"Pages can be full screen as well.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id euismod lectus, non tempor felis. Nam rutrum rhoncus est ac venenatis.",
          image: _buildFullscrenImage('skip1'),
          decoration: pageDecoration.copyWith(
              contentMargin: const EdgeInsets.symmetric(horizontal: 16),
              fullScreen: true,
              bodyFlex: 15,
              imageFlex: 1,
              bodyAlignment: Alignment.center,
              descriptionPadding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height * .5),
              titleTextStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
              bodyTextStyle: TextStyle(color: Colors.black87, fontSize: 18.0)),
        ),
        /*PageViewModel(
          title: "Live Chat\nدردشة مباشرة", //"Full Screen Page",
          body:
              "", //"Almadalla healthcare has a strong medical background team, supporting memebers and",
          //"Pages can be full screen as well.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id euismod lectus, non tempor felis. Nam rutrum rhoncus est ac venenatis.",
          image: _buildFullscrenImage('skip2'),
          decoration: pageDecoration.copyWith(
              contentMargin: const EdgeInsets.symmetric(horizontal: 16),
              fullScreen: true,
              bodyFlex: 9,
              imageFlex: 1,
              bodyAlignment: Alignment.center,
              descriptionPadding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height * .6),
              titleTextStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
              bodyTextStyle: TextStyle(color: Colors.black87, fontSize: 18.0)),
        ),*/
        /*PageViewModel(
          title: "Tele Consultation\nاستشارة عن بعد", //"Full Screen Page",
          body:
              "", //"Almadalla healthcare has a strong medical background team, supporting memebers and",
          //"Pages can be full screen as well.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id euismod lectus, non tempor felis. Nam rutrum rhoncus est ac venenatis.",
          image: _buildFullscrenImage('skip3'),
          decoration: pageDecoration.copyWith(
              contentMargin: const EdgeInsets.symmetric(horizontal: 16),
              fullScreen: true,
              bodyFlex: 9,
              imageFlex: 1,
              bodyAlignment: Alignment.center,
              descriptionPadding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height * .6),
              titleTextStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
              bodyTextStyle: TextStyle(color: Colors.black87, fontSize: 18.0)),
        ),*/
        PageViewModel(
          title: "Push Notification\nاشعارات مباشرة", //"Full Screen Page",
          body:
              "", //"Almadalla healthcare has a strong medical background team, supporting memebers and",
          //"Pages can be full screen as well.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id euismod lectus, non tempor felis. Nam rutrum rhoncus est ac venenatis.",
          image: _buildFullscrenImage('skip4'),
          decoration: pageDecoration.copyWith(
              contentMargin: const EdgeInsets.symmetric(horizontal: 16),
              fullScreen: true,
              bodyFlex: 9,
              imageFlex: 1,
              bodyAlignment: Alignment.center,
              descriptionPadding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height * .6),
              titleTextStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
              bodyTextStyle: TextStyle(color: Colors.black87, fontSize: 18.0)),
        ),
        PageViewModel(
          useScrollView: false,
          titleWidget: Container(
            padding: const EdgeInsets.only(bottom: 12),
            width: MediaQuery.of(context).size.width * .8,
            child: Image.asset(
              'assets/logo_long.png',
              alignment: Alignment.center,
            ),
          ), //"Welcome", //"Full Screen Page",
          body: "Select Language",
          //"Pages can be full screen as well.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id euismod lectus, non tempor felis. Nam rutrum rhoncus est ac venenatis.",
          image: _buildFullscrenImage('language'),
          decoration: pageDecoration.copyWith(
            //contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 9,
            imageFlex: 1,
            //titlePadding: EdgeInsets.only(top: 0, bottom: 6)
            //descriptionPadding: EdgeInsets.only(top: 5),
            descriptionPadding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * .38),
          ),
          footer: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    bloc!.setLanguage(1);
                    //_changeLang(language(1, "English","en"));
                    await context.setLocale(Locale('en'));

                    _onIntroEnd(context);

                    //introKey.currentState?.animateScroll(0);
                  },
                  child: const Text(
                    'English',
                    style: TextStyle(color: Colors.white, fontSize: 19),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(150, 50),
                    primary: Color(0xFFb89669),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bloc!.setLanguage(2);
                    await context.setLocale(Locale('ar'));
                    //_changeLang(language(2, "عربى","ar",));
                    //introKey.currentState?.animateScroll(0);
                    _onIntroEnd(context);
                  },
                  child: const Text(
                    'عربي',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(150, 50),
                    primary: Color(0xFFb89669),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        /*PageViewModel(
          title: "Another title page",
          body: "Another beautiful body text for this example onboarding",
          image: _buildImage('img2.jpg'),
          footer: ElevatedButton(
            onPressed: () {
              introKey.currentState?.animateScroll(0);
            },
            child: const Text(
              'FooButton',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          decoration: pageDecoration,
        ),*/
        /*PageViewModel(
          title: "Title of last page - reversed",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Click on ", style: bodyStyle),
              Icon(Icons.edit),
              Text(" to edit a post", style: bodyStyle),
            ],
          ),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 4,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          image: _buildImage('introscreen2.png'),
          reverse: true,
        ),*/
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      showDoneButton: false,
      showNextButton: true,

      skipFlex: 0,
      nextFlex: 0,
      //rtl: true, // Display as right-to-left

      skip: Text(LocaleKeys.skip.tr(),
          style: TextStyle(color: Color(0xFFb89669))),
      next: const Icon(Icons.arrow_forward, color: Color(0xFFb89669)),
      done: Text(LocaleKeys.done.tr(),
          style: TextStyle(color: Color(0xFFb89669))),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(11.0, 11.0),
        color: Color(0xFFb89669),
        activeColor: Color(0xFFb89669),
        activeSize: Size(22.0, 11.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      /*dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),*/
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.
    await Future.delayed(Duration(milliseconds: 4500));
  }
}
