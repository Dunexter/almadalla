import 'package:almadalla/Util/Utils.dart';
import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/customwidgets/CustomDrawer.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/UserProfile.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/screens/SettingsScreen.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:email_validator/email_validator.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  void _onSettingEnd(context) {
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SettingsPage(title: '')),
    );*/
    Navigator.of(context).pop();
  }
  bool isLoginProgress = false;
  //final mask =  MaskTextInputFormatter(mask: '000-0000-0000000-0');
  //new MaskedTextController(mask: '000-0000-0000000-0');
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _emiratesIdController = TextEditingController();
  String errorMessageEmiratesId = "";
  String errorMessageEmail = "";
  String errorMessageUsername = "";
  String errorMessageMobileNumber = "";
  String errorMessageMobileNumberLength="";
  String errorMessagedob = "";
  bool _checkbox = false;
  DateTime? _fromDate;
  String? formattedFromDate;
  String? mdFileName;
  bool emailValid= true;
  bool isvalid = false;
  String? todayDateFormat = DateFormat('dd- MMM-yyyy','en').format(DateTime.now());
  void _onFromDateClick() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _fromDate == null? new DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ):DateTime(
        _fromDate!.year,
        _fromDate!.month,
        _fromDate!.day,
      ),
      firstDate:DateTime(1900),
      lastDate: DateTime.now(),/*new DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),*/
    );
    if (pickedDate != null && pickedDate != _fromDate) {
      setState(() {
        _fromDate = pickedDate;
        formattedFromDate = DateFormat('dd-MMM-yyyy','en').format(_fromDate!);
      });
      print("selectedDatee$_fromDate");
    }
  }

  Future<void> _onSubmitClicked() async {
    setState(() {
      isLoginProgress = true;
    });
 String emiratesId=   _emiratesIdController.text.replaceAll("-", "");
    UserProfile? userProfile;
    userProfile = new UserProfile();
    userProfile.emailID =
        _emailController.text.isNotEmpty ? _emailController.text : "";
    print("--emailID--${userProfile.emailID}");
    userProfile.name =
        _usernameController.text.isNotEmpty ? _usernameController.text : "";
    print("--name--${userProfile.name}");
    userProfile.emiratesIDNo =
        _emiratesIdController.text.isNotEmpty ? emiratesId : "";
    print("--emiratesIDNo--${userProfile.emiratesIDNo}");
    userProfile.mobile = _mobileNumberController.text.isNotEmpty
        ? _mobileNumberController.text
        : "";
    print("--mobile--${userProfile.mobile}");
    userProfile.dob = formattedFromDate != null ?formattedFromDate : "";
    print("--dob--${userProfile.dob}");
    String? response = await RestDatasource().register(userProfile);
    if (response != null && response == "success") {
      setState(() {
        isLoginProgress = false;
      });
      SnackBar registerSuccessErrorMessage =
          SnackBar(content: new Text("Registered Successfully"));
      ScaffoldMessenger.of(context).showSnackBar(registerSuccessErrorMessage);
    } else {
      setState(() {
        isLoginProgress = false;
      });
      String? msg = response;
      String? finalString = "";
      if (response!.contains(',')) {
        String regex = ",";
        String result = response.replaceAll(regex, "");
        List<String> values = result.split(" ");
        print("values$values");
        for (int i = 0; i < values.length; i++) {
          finalString = finalString! + " " + values[i].tr();
        }
        print("finalString$finalString");
        //   String first =  result.split(" ").first;
        //   print("first$first");
        //    String last=  result.split(" ").last;
        //   print("last$last");
        //   String convertFirst=first.tr();
        //  String convertLast=  last.tr();
        //
        // String finalString = convertFirst + " ," + convertLast;

        SnackBar registerErrorMessage =
            SnackBar(content: new Text(finalString!));
        ScaffoldMessenger.of(context).showSnackBar(registerErrorMessage);
      } else {
        String errorMessage = response.tr();
        print("msg$msg");
        SnackBar registerErrorMessage =
            SnackBar(content: new Text(errorMessage));
        ScaffoldMessenger.of(context).showSnackBar(registerErrorMessage);
      }
    }
  }

  policyDialog(mdFileName) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        height: 560.0,
        width: 300.0,
        child: Stack(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 40),
                child: Container(
                  width: double.infinity,
                  height: 560,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: SingleChildScrollView(
                    child: Html(
                      data: """
        <p>These Conditions of Use and Disclaimer (the "Conditions") set out important information about Almadallah Mobile Application hosted under the URL www.almadallah.ae (the "Mobile Application"). Please read it carefully as it affects your rights and liabilities under law. If you do not agree with the Conditions, please do not use the Mobile Application.</p>
        <h3 style='color:#045874;' class="">Use of the Mobile Application</h3>
         <ul >
        <li  style=" padding:0px 5px 5px 10px;"> This Mobile Application is provided to you for your use subject to these Conditions. By using the Mobile Application you agree with Almadallah Healthcare Management FZ LLC ("Almadallah" or "we" as the context requires) to be bound by these Conditions.</li>
        <li style=" padding:0px 5px 5px 10px;">Almadallah may update these Conditions from time to time, for legal or regulatory reasons, or to allow the proper operation of the Mobile Application. If you continue to use the Mobile Application after the date on which the change comes into effect, your use of the Mobile Application indicates your agreement to be bound by the new Conditions.</li>
        <li style=" padding:0px 5px 5px 10px;"> As a condition of your use of the Mobile Application or any services on it, you warrant to Almadallah that you will not use the Mobile Application for any purpose that is unlawful or prohibited by these Conditions or any other terms, conditions or notices appearing anywhere on the Mobile Application. In particular, you agree not to:
        <ul style="list-style-type:circle">
        <li style=" padding:5px 5px 5px 10px;">Use the Mobile Application to defame, abuse, harass, stalk, threaten or otherwise offend others.</li>
        <li style=" padding:5px 5px 5px 10px;">Publish, distribute, email, transmit or disseminate any material which is unlawful, obscene, defamatory, indecent, offensive or inappropriate.</li>
         <li style="  padding:5px 5px 5px 10px;">Use any automated scripting tools or software.</li>
        <li style=" padding:5px 5px 5px 10px;">Engage in or promote any surveys, contests, pyramid schemes, chain letters, unsolicited e-mailing or spamming via the Mobile Application..</li>
        <li style=" padding:5px 5px 5px 10px;">Impersonate any person or entity.</li>
        <li style="  padding:5px 5px 5px 10px;">Upload, post, e-mail, transmit or otherwise make available using the Mobile Application any material that you do not have a right to make available under any law or contractual obligation or which contains viruses, or other computer codes, files or programs designed to interrupt, limit or destroy the functionality of other computer software or hardware.</li>
 
        <li style="  padding:5px 5px 5px 10px;">Breach any applicable laws or regulations.</li>
         </ul></li>
        </ul>
        <h3 style='color:#045874;' class="">Intellectual Property</h3>
        <p> The content of the Mobile Application is protected by copyright, trade-marks, database rights and other intellectual property rights. You may retrieve and display content from the Mobile Application on a computer screen, store such content in electronic form on disk (but not on a server or other storage device connected to a network) or print one copy of such content for your own personal, non-commercial use, provided you keep intact all and any copyright and proprietary notices. You may not otherwise reproduce, modify, copy or distribute or use for commercial purposes any of the materials or content on the Mobile Application without written permission from Almadallah.</p>
         <h3 style='color:#045874;' class="">Disclaimer</h3>
             <ul>
        <li style=" padding:0px 5px 5px 10px;">   Almadallah cannot promise that the Mobile Application will be fault-free. If a fault occurs with the Mobile Application you should report it to [info@almadallah.ae] and we will attempt to correct the fault as soon as we can. Your access to the Mobile Application may be occasionally restricted to allow for repairs, maintenance or the introduction of new content. We will attempt to restore access as soon as we reasonably can.</li>
        <li style=" padding:0px 5px 5px 10px;"> Liability</li>
        <ul  font-size: 40px; style="list-style-type:circle">
        <li style=" padding:5px 5px 5px 10px;">The Mobile Application may provide content from other internet sites or resources and while Almadallah will endeavor to ensure that material included on the Mobile Application is correct, reputable and of high quality, we do not make any warranties or guarantees in relation to that content.</li>
        <li style=" padding:5px 5px 5px 10px;">We will not be responsible for any losses whatsoever that you may suffer, whether direct, indirect or consequential, as a result of or as a consequence of your use of the Mobile Application.</li>
        <li style="padding:5px 5px 5px 10px;">This Clause (Liability) shall not limit or affect our liability if something we do negligently causes death or personal injury.</li>
        </ul></li>
        <li style=" padding:0px 5px 5px 10px;" >We make no promise that the materials on the Mobile Application are appropriate or available for use in locations outside the United Arab Emirates, and accessing the Mobile Application from territories where its contents are illegal or unlawful is prohibited. If you choose to access the Mobile Application from elsewhere, you do so, on your own initiative and risk and are responsible for compliance with local laws.</li>
        </ul>
        <h3 style='color:#045874;' class="">General</h3>
        <ul>
        <li style=" padding:0px 5px 5px 10px;" >  We collect information provided by you while accessing the Mobile Application.</li>
        <li style=" padding:0px 5px 5px 10px;">  These Conditions will be subject to the laws of the Emirate of Dubai and the United Arab Emirates. If you want to take court proceedings, you must do so in Dubai.</li>
        <li style=" padding:0px 5px 5px 10px;">The Mobile Application is owned and operated by Almadallah Healthcare Management FZ LLC.</li>
  
        </ul>
                """,
                    ),
                  ),


                  // child: FutureBuilder(
                  //   future: Future.delayed(Duration(milliseconds: 150))
                  //       .then((value) {
                  //     return rootBundle.loadString('assets/$mdFileName');
                  //   }),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       return Markdown(
                  //         data: snapshot.data.toString(),
                  //         styleSheet: MarkdownStyleSheet(
                  //           listIndent: 5,
                  //          // textAlign: WrapAlignment.center,
                  //           h1Align: WrapAlignment.start, h1: TextStyle(color: Colors.cyan, fontSize: 18),
                  //         h2:TextStyle(color: Colors.black,),
                  //        // orderedListAlign:  WrapAlignment.center,
                  //           listBullet: TextStyle(color: Colors.black, fontSize:22),
                  //           unorderedListAlign: WrapAlignment.start,
                  //         ),
                  //       );
                  //     }
                  //     return Center(
                  //       child: CircularProgressIndicator(),
                  //     );
                  //   },
                  // ),
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
                alignment: Alignment.center,
                child: Text(
                  LocaleKeys.terms.tr(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
                      LocaleKeys.create_account.tr(),
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0, top: 15,right: 15.0),
                          child: Text(
                            LocaleKeys.i_am.tr(),
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.black),
                          ),
                        ),
                        new Container(
                            width: 270,
                            height: 50,
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                            margin: const EdgeInsets.only(
                                top: 15.0, left: 15, right: 15.0, bottom: 10.0),
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
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: new Text(
                                LocaleKeys.member.tr(),
                                style: TextStyle(color: Colors.black),
                              ),
                            )),
                      ],
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
                        borderRadius: new BorderRadius.all(Radius.circular(5.0))
                        // color: Colors.white12,
                        ),
                    alignment: FractionalOffset.center,
                    child: new TextFormField(
                      controller: _usernameController,
                      inputFormatters: [
                        //FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s"))
                        FilteringTextInputFormatter.deny(RegExp(r"\s"))
                      ],
                      style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText:LocaleKeys.username.tr(),
                        hintStyle:
                            TextStyle(fontSize: 18.0, color: Colors.black54),
                      ),
                    ),
                  ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 0.0, top: 2.0, bottom: 3.0),
                      child: Text(
                        errorMessageUsername,
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    )),
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
                        borderRadius: new BorderRadius.all(Radius.circular(5.0))
                        // color: Colors.white12,
                        ),
                    alignment: FractionalOffset.center,
                    child: new TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText:LocaleKeys.email_address.tr(),
                        hintStyle:
                            TextStyle(fontSize: 18.0, color: Colors.black54),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 0.0, top: 2.0, bottom: 3.0),
                      child: Text(
                        errorMessageEmail,
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    )),
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
                        borderRadius: new BorderRadius.all(Radius.circular(5.0))
                        // color: Colors.white12,
                        ),
                    alignment: FractionalOffset.center,
                    child: new TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _emiratesIdController,
                      inputFormatters: [
                        MaskTextInputFormatter(
                          mask: '###-####-#######-#',
                          filter: {
                            "#": RegExp(r'[0-9]'),
                          },
                        ),
                      ],
                      style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText:LocaleKeys.emirates_number.tr(),
                        hintStyle:
                            TextStyle(fontSize: 18.0, color: Colors.black54),
                      ),
                    ),
                  ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 0.0, top: 2.0, bottom: 3.0),
                      child: Text(
                        errorMessageEmiratesId,
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    )),
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
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _fromDate != null
                                ? Text("${formattedFromDate}")
                                : Text( LocaleKeys.date_birth.tr(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15.0)),
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
                      )),
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 0.0, top: 2.0, bottom: 3.0),
                      child: Text(
                        errorMessagedob,
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    )),
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
                        borderRadius: new BorderRadius.all(Radius.circular(5.0))
                        // color: Colors.white12,
                        ),
                    alignment: FractionalOffset.center,
                    child: new TextFormField(
                      controller:_mobileNumberController ,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r"[0-9]"))                              
                              ],
                      style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText:LocaleKeys.mobile_number.tr(),
                        hintStyle:
                            TextStyle(fontSize: 18.0, color: Colors.black54),
                      ),
                    ),
                  ),
             Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 0.0, top: 2.0, bottom: 3.0),
                      child: Text(
                        errorMessageMobileNumber,
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 10.0, right:20.0,top: 10),
                    child: Text(
                        LocaleKeys.note.tr(),
                        style: TextStyle(
                          color: Color(0xFFc5a56a),
                          fontSize: 15.0,
                          fontStyle: FontStyle.italic,
                        )),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 5.0, top: 15),
                      child: Row(
                        children: [
                          Checkbox(
                            value:this. _checkbox,
                            onChanged: (bool? value) {
                              setState(() {
                                this._checkbox = value!;
                              });
                            },
                          ),

                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only( top: 10),
                            child:RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                text:  LocaleKeys.agree.tr(),
                                style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black54),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return policyDialog(
                                          'policy.md',
                                        );
                                      },
                                    );
                                  },
                                
                              ),
                            ),),
                      ),
                          // Text(
                          //     LocaleKeys.agree.tr() +"\n"+LocaleKeys.condition.tr(),
                          //     style: TextStyle(
                          //         color: Colors.black, fontSize: 15.0)),
                        ],
                      )),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () async {
                                setState(() {
                                  if (!isLoginProgress) {
                                    isvalid = EmailValidator.validate(_emailController.text);
                                    if (((_usernameController
                                            .text.isNotEmpty) && (_emailController.text.isNotEmpty ) &&
                                        (_emiratesIdController
                                            .text.isNotEmpty) &&
                                        (formattedFromDate != null) &&
                                        (_mobileNumberController.text.isNotEmpty) )) {

                                              setState(() {
                                          errorMessageUsername = "";
                                         // errorMessageEmail = "";
                                          errorMessageEmiratesId = "";
                                          errorMessageMobileNumber = "";
                                          errorMessagedob = "";
                                        });
                                              if (isvalid) {
                                                setState(() {
                                                  errorMessageEmail = "";
                                                });

                                      if (_mobileNumberController.text.startsWith("971") && _mobileNumberController.text.length ==12) {
                                        setState(() {
                                          errorMessageMobileNumber = "";
                                        });
                                              setState(() {
                                          errorMessageUsername = "";
                                          errorMessageEmail = "";
                                          errorMessageEmiratesId = "";
                                          errorMessageMobileNumber = "";
                                          errorMessagedob = "";
                                        });
                                        if (_checkbox) {
                                          _onSubmitClicked();
                                        } else {
                                          Utils.showDialogGeneralMessage(
                                              LocaleKeys.terms_condition.tr(),
                                              context,
                                              false);
                                        }
                                      } else {
                                          setState(() {
                                            setState(() {
                                              errorMessageMobileNumber =
                                                  "Enter a valid Mobile Number. Mobile number should start with 971 and number of digits should be 12";
                                            });
                                          });
                                        }
                                    //}
                                    ///  }
                                              //else {

                                        // if (_mobileNumberController.text
                                        //         .startsWith("971") &&
                                        //     _mobileNumberController
                                        //             .text.length ==
                                        //         12) {
                                        //   setState(() {
                                        //     errorMessageMobileNumber ="Enter a valid Mobile Number. Mobile number should start with 971 and number of digits should be 12";
                                        //   });
                                        // } else {
                                        //   setState(() {
                                        //     errorMessageMobileNumber = "";
                                        //   });
                                        }
                                    else{
                                                setState(() {
                                                  errorMessageEmail =
                                                  "Enter a valid Email Address";
                                                });
                                     }
                                    } else {
                                      if (isvalid) {
                                        setState(() {
                                          errorMessageEmail = "";
                                        });
                                      } else {
                                        if (_emailController.text.isEmpty) {
                                          setState(() {
                                            errorMessageEmail =
                                                LocaleKeys.email_required.tr();
                                          });

                                        } else {
                                          if(isvalid){
                                            setState(() {
                                              errorMessageEmail = "";
                                            });
                                          }else{
                                            setState(() {
                                              errorMessageEmail = "Enter a valid Email Address";
                                            });
                                          }
                                          setState(() {
                                            errorMessageEmail = "Enter a valid Email Address";
                                          });
                                        }
                                        // if(isvalid){
                                        //   setState(() {
                                        //     errorMessageEmail = "";
                                        //   });
                                        // }else{
                                        //   setState(() {
                                        //     errorMessageEmail = "valid";
                                        //   });
                                        // }

                                      }

                                      print("validationnnnsss hereeee ");
                                      if (_usernameController.text.isEmpty) {
                                        setState(() {
                                          errorMessageUsername =
                                              LocaleKeys.username_required.tr();
                                        });
                                      } else {
                                        setState(() {
                                          errorMessageUsername = "";
                                        });
                                      }
                                      // if (_emailController.text.isEmpty) {
                                      //   setState(() {
                                      //     errorMessageEmail =
                                      //         LocaleKeys.email_required.tr();
                                      //   });
                                      // } else {
                                      //   setState(() {
                                      //     errorMessageEmail = "";
                                      //   });
                                      // }
                                      if (_emiratesIdController.text.isEmpty) {
                                        setState(() {
                                          errorMessageEmiratesId = LocaleKeys
                                              .emiratesId_required
                                              .tr();
                                        });
                                      } else {
                                        setState(() {
                                          errorMessageEmiratesId = "";
                                        });
                                      }
                                      if (_mobileNumberController
                                          .text.isEmpty) {
                                        setState(() {
                                          errorMessageMobileNumber = LocaleKeys
                                              .mobile_number_required
                                              .tr();
                                        });
                                      } else {
                                        setState(() {
                                          errorMessageMobileNumber = "";
                                        });
                                      }

                                      if (formattedFromDate == null) {
                                        setState(() {
                                          errorMessagedob =
                                              LocaleKeys.DOB_required.tr();
                                        });
                                      } else {
                                        setState(() {
                                          errorMessagedob = "";
                                        });
                                      }
                                    }
                                  }
                                });
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
                            top: 5.0, left: 10.0, right: 10.0,bottom: 30.0),
                        child: Center(
                          child: Text(
                            LocaleKeys.sign_up.tr(),
                            style: TextStyle(fontSize: 18, color: Colors.white),
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
                            )
                    ]),
                ],
              ),),
            )));
  }
}
