import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/customwidgets/CustomDrawer.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/ContactReasonsModel.dart';
import 'package:almadalla/models/SendMessageParams.dart';
import 'package:almadalla/models/UserSettingsBloc.dart';
import 'package:almadalla/screens/ChangePasswordScreen.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/screens/LanguageBloc.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'ProfileScreen.dart';

class ContactPage extends StatefulWidget {
  ContactPage({Key? key, required this.title }) : super(key: key);

  final String title;

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  void _onChangePasswordEnd(context) {
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChangePasswordPage(title: '')),
    );*/
    Navigator.of(context).pop();
  }

 /* void _onChangePasswordTap(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChangePasswordPage(title: '')),
    );
  }*/

  List<String> _reason = [
    'General Enquiry','Complaint','Medical Enquiry'
  ];

  ContactReasonsModel? _contactReasonType;
   Future<List<ContactReasonsModel>?>? contactReason;
  String? _reasonType;
  String _emiratesTypeValue = "";
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _commentController = TextEditingController();
  String errorMessageEmail = "";
  String errorMessageComment = "";
  UserSettingsBloc? userSettingsBloc;
  bool value = false;
  LanguageBloc? bloc;
  _sendingMails(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  void initState() {
    contactReason =
        RestDatasource().getContactReasons();
    super.initState();
  }
  Future<void> _onSendClicked() async {
    setState(() {
      isLoginProgress = true;
    });
    SendMessageParams? sendMessageParams;
    sendMessageParams = new SendMessageParams();
    sendMessageParams.name =
        _nameController.text.isNotEmpty ? _nameController.text : "";
    print("Name${sendMessageParams.name}");
    sendMessageParams.emailID =
        _emailController.text.isNotEmpty ? _emailController.text : "";
    print("emailID${sendMessageParams.emailID}");
    sendMessageParams.comments =
    _commentController.text.isNotEmpty ? _commentController.text : "";
    print("comments${sendMessageParams.comments}");
    sendMessageParams.phoneNumber = _phoneNumberController.text.isNotEmpty
        ? _phoneNumberController.text
        : "";
    print("phoneNumber${sendMessageParams.phoneNumber}");
    if (_reasonType == null) {
      sendMessageParams.contactReasonKey = 1;
    } else {
    //  int? reasonType=_contactReasonType!.key;
     sendMessageParams.contactReasonKey=_contactReasonType!.key;
    }
    print("ReasonKey${sendMessageParams.contactReasonKey}");
    String? response = await RestDatasource().sendMessage(sendMessageParams);
    if (response != null && response.isNotEmpty) {
      _emailController.clear();
      _commentController.clear();
      _phoneNumberController.clear();
      _nameController.clear();
      _contactReasonType=null;
      setState(() {
        isLoginProgress = false;
      });
      SnackBar successMessage = SnackBar(content: new Text("Message sent"));
      ScaffoldMessenger.of(context).showSnackBar(successMessage);
    } else {
      setState(() {
        isLoginProgress = false;
      });
      SnackBar successMessage = SnackBar(content: new Text("Message Not sent"));
      ScaffoldMessenger.of(context).showSnackBar(successMessage);
    }
  }

  bool isLoginProgress = false;
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
                  _onChangePasswordEnd(context);
                })),
        //drawer: CustomDrawer(),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      LocaleKeys.contact_us.tr(),
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 5.0, top: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //InkWell(
                              // onTap: () => launch('https://www.almadallah.ae/Common/Default.aspx'),
                              Text("Almadallah Healthcare Management FZ Co",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.black,
                                      fontSize: 15.0)),
                              //),

                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5), child:Text(
                                "PO Box 478803",
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.black),
                              ),),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 2),child:Text(
                                "7th Floor, Lynx Tower",
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.black),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 2),child: Text(
                                "Dubai Silicon Oasis",
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.black),
                              ),),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 2),child:Text(
                                " Dubai, UAE",
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.black),
                              ),),
                            ],
                          ))),
                  InkWell(
                      onTap: () {},
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 10.0, right: 15.0),
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                             // height: 100,
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFc5a56a),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(15.0),
                                              topLeft: Radius.circular(15.0),
                                            ),
                                          ),
                                          width:
                                              MediaQuery.of(context).size.width,
                                         // height: 40,
                                          // color: Color(0xFFb7956c),
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0,
                                                  top: 10.0,
                                                  bottom: 10,right: 15.0),
                                              child: Text(LocaleKeys.email.tr()))),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, top: 5,right: 15.0),
                                          child: InkWell(
                                            onTap: () {
                                              _sendingMails(
                                                  "mailto:network@almadallah.ae");
                                            },
                                            child:
                                                Text("network@almadallah.ae"),
                                          )),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15.0,top: 5,bottom: 20,right: 15.0),
                                          child: InkWell(
                                            onTap: () {
                                              _sendingMails(
                                                  "mailto:accounts@almadallah.ae");
                                            },
                                            child:
                                                Text("accounts@almadallah.ae"),
                                          )),
                                    ],
                                  ))))),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 10.0, right: 15.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                           // height: 100,
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFc5a56a),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15.0),
                                            topLeft: Radius.circular(15.0),
                                          ),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                       // height: 40,
                                        // color: Color(0xFFb7956c),
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0,
                                                top: 10.0,bottom: 10.0, right: 15.0),
                                            child: Text(
                                              LocaleKeys.for_administrative_issues.tr(),))),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, top: 5,right: 15.0),
                                        child:InkWell(
                                            onTap: (){
                                              launch("tel:043074111");
                                            },
                                            child: Text("Fax:043074111")
                                        )),
                                        //child: Text("Tel: 043074111")),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0,top:5.0,bottom: 10,right: 15.0),
                                      child:InkWell(
                                          onTap: (){
                                            launch("tel:04 3330340");
                                          },
                                          child: Text("Fax:04 3330340")
                                      ))

                                  ],
                                )))),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 10.0, right: 15.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            //height: 100,
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFc5a56a),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15.0),
                                            topLeft: Radius.circular(15.0),
                                          ),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        //height: 40,
                                        // color: Color(0xFFb7956c),
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0,
                                                top: 10.0,
                                                bottom: 10,right: 15.0),
                                            child: Text(
                                              LocaleKeys.for_claims_reimbursement.tr(),))),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, top: 5,right: 15),
                                        child:InkWell(
                                            onTap: (){
                                              launch("tel:04 3074222");
                                            },
                                            child: Text(" 04 3074222")
                                        )),

                                    Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0,top: 5,bottom: 10,right: 15.0),
                                        child: InkWell(
                                          onTap: () {
                                            _sendingMails(
                                                "mailto:claims@almadallah.ae");
                                          },
                                          child: Text(
                                              "Email: claims@almadallah.ae"),
                                        )),
                                  ],
                                )))),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 10.0, right: 15.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            //height: 100,
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFc5a56a),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15.0),
                                            topLeft: Radius.circular(15.0),
                                          ),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        //height: 40,
                                        // color: Color(0xFFb7956c),
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0,
                                                top: 10.0,
                                                bottom: 10,right: 15.0),
                                            child: Text(LocaleKeys.for_careers.tr(),))),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, top: 10,bottom: 20,right: 15.0),
                                        child: InkWell(
                                          onTap: () {
                                            _sendingMails(
                                                "mailto:jobs@almadallah.ae");
                                          },
                                          child: Text(
                                              "Email: jobs@almadallah.ae"),
                                        ))
                                  ],
                                )))),
                  ),
                  InkWell(
                      onTap: () {},
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 10.0, right: 15.0),
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                             // height: 100,
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFc5a56a),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(15.0),
                                              topLeft: Radius.circular(15.0),
                                            ),
                                          ),
                                          width:
                                              MediaQuery.of(context).size.width,
                                         // height: 40,
                                          // color: Color(0xFFb7956c),
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0,
                                                  top: 10.0,
                                                  bottom: 10,right: 15.0),
                                              child: Text(LocaleKeys.toll_free_numbe.tr(),))),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, top: 10,bottom: 20,right: 15.0),
                                        //  launch("tel://214324234");
                                        child:InkWell(
                                          onTap: (){
                                            launch("tel:800 43444");
                                          },
                                          child: Text("800 43444")
                                        )
                                       // child: Text("800 43444"),
                                      ),
                                    ],
                                  ))))),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top:20.0),
                      child: Text(
                        LocaleKeys.send_message.tr(),
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
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
                                text: LocaleKeys.contact_reason.tr(),
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
                                new BorderRadius.all(Radius.circular(0.0))
                            // color: Colors.white12,
                            ),
                        alignment: FractionalOffset.center,
                        child:  FutureBuilder<List<ContactReasonsModel>?>(
                          future: contactReason, // async work
                          builder: (BuildContext context,
                              AsyncSnapshot<List<ContactReasonsModel>?> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Container(
                                    child: Center(
                                        child: CupertinoActivityIndicator()));
                              default:
                                if (snapshot.hasError)
                                  return Text(LocaleKeys.try_again);
                                else
                                  return getContactReasonDataWidget(snapshot.data);
                            }
                          },
                        ),
                      ),
                      Align(
                        alignment: value == true? Alignment.topRight:Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.only(top: 0.0, left: 12.0,right: 12.0),
                          child: RichText(
                            text: TextSpan(
                                text: LocaleKeys.your_name.tr(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                                children: [
                                  // TextSpan(
                                  //     text: ' *',
                                  //     style: TextStyle(
                                  //         color: Colors.red, fontSize: 16.0))
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
                                new BorderRadius.all(Radius.circular(0.0))
                            // color: Colors.white12,
                            ),
                        alignment: FractionalOffset.center,
                        child: new TextFormField(
                          controller: _nameController,
                          style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Align(
                        alignment: value == true? Alignment.topRight:Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.only(top: 0.0, left: 12.0,right: 12.0),
                          child: RichText(
                            text: TextSpan(
                                text:  LocaleKeys.where_do_we_email_you.tr(),
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
                                new BorderRadius.all(Radius.circular(0.0))
                            // color: Colors.white12,
                            ),
                        alignment: FractionalOffset.center,
                        child: new TextFormField(
                          controller: _emailController,
                          style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Align(
                          alignment: value == true? Alignment.topRight:Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12.0, top: 2.0, bottom: 3.0),
                            child: Text(
                              errorMessageEmail,
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),
                          )),
                      Align(
                        alignment: value == true? Alignment.topRight:Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.only(top: 0.0, left: 12.0,right: 12.0),
                          child: RichText(
                            text: TextSpan(
                                text:  LocaleKeys.have_a_phone_number.tr(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                                // children: [
                                //   TextSpan(
                                //       text: ' *',
                                //       style: TextStyle(
                                //           color: Colors.red, fontSize: 16.0))
                                // ]
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
                                new BorderRadius.all(Radius.circular(0.0))
                            // color: Colors.white12,
                            ),
                        alignment: FractionalOffset.center,
                        child: new TextFormField(
                          controller: _phoneNumberController,
                          style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Align(
                        alignment: value == true? Alignment.topRight:Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.only(top: 0.0, left: 12.0,right: 12.0),
                          child: RichText(
                            text: TextSpan(
                                text: LocaleKeys.What_your_mind.tr(),
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
                            top: .0, left: 15, right: 15.0, bottom: 10.0),
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            border: new Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius:
                                new BorderRadius.all(Radius.circular(0.0))
                            // color: Colors.white12,
                            ),
                        alignment: FractionalOffset.center,
                        child: new TextFormField(
                          controller: _commentController,
                            style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                            ),
                            maxLines: 4),
                      ),
                      Align(
                          alignment: value == true? Alignment.topRight:Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12.0, top: 2.0, bottom: 3.0),
                            child: Text(
                              errorMessageComment,
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),
                          )),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      InkWell(
                                    onTap: () async {
                                      if (!isLoginProgress) {
                                        if ((_emailController.text.isNotEmpty &&
                                            _commentController
                                                .text.isNotEmpty)) {
                                          _onSendClicked();
                                        } else {
                                          if (_emailController.text.isEmpty) {
                                            setState(() {
                                              errorMessageEmail =
                                                  "Invalid Email";
                                            });
                                          } else {
                                            setState(() {
                                              errorMessageEmail = "";
                                            });
                                          }
                                          if (_commentController.text.isEmpty) {
                                            setState(() {
                                              errorMessageComment =
                                                  "Invalid Comments";
                                            });
                                          } else {
                                            setState(() {
                                              errorMessageComment = "";
                                            });
                                          }
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Color(0xFFb89669),
                            ),
                            margin: const EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0,bottom: 30.0),
                            child: Center(
                              child: Text(
                                LocaleKeys.send.tr(),
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          )),      isLoginProgress
                              ? Center(
                              child: Container(
                                  width: 10,
                                  margin: const EdgeInsets.only(bottom: 30),
                                  child: Center(
                                      child: CupertinoActivityIndicator())))
                              : Container(
                            width: 10,
                          )


                        ])
                    ]),
                  )
                ],
              ),
            ))));
  }
  Widget getContactReasonDataWidget(List<ContactReasonsModel>? param) {
    return DropdownButtonFormField<dynamic>(
      isExpanded: true,
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      value: _contactReasonType,
      hint: Text(param![0].name!,
          style: TextStyle(
            color: Colors.black,
          )),
      items: param.map((ContactReasonsModel? paramsModel) {
        return DropdownMenuItem<ContactReasonsModel?>(
          value: paramsModel,
          child: Text(
            paramsModel != null ? paramsModel.name ?? 'No data' : 'No data',
          ),
        );
      }).toList(),
      onChanged: (dynamic value) {
        setState(() {
          print("Value$value");

          _contactReasonType = value;
        });
      },
    );
  }

}

