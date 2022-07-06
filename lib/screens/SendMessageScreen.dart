import 'package:almadalla/customwidgets/CustomDrawer.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/screens/SettingsScreen.dart';
import 'package:flutter/material.dart';

class SendMessagePage extends StatefulWidget {
  SendMessagePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SendMessagePageState createState() => _SendMessagePageState();
}

class _SendMessagePageState extends State<SendMessagePage> {
  void _onSettingEnd(context) {
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SettingsPage(title: '')),
    );*/
    Navigator.of(context).pop();
  }

  List<String> _person = [
    'Sheikh Ali Khan',
  ];
  String? _personType;
  String _emiratesTypeValue = "";
  final _formKey = GlobalKey<FormState>();

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
        body: Container(
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
                    "Send us a message",
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
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.only(top: 15.0, left: 12.0),
                        child: RichText(
                          text: TextSpan(
                              text: "Contact Person",
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
                        // child: Text(
                        //   "Contact Reason",
                        //   style: TextStyle(
                        //     fontSize: 16.0,
                        //     color: Colors.black,
                        //   ),
                        // ),
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
                      child: DropdownButtonFormField<dynamic>(
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                        ),
                        value: _personType,
                        hint: Text('-- Select Person --',
                            style: TextStyle(
                              color: Colors.black,
                            )),

                        // this is the magic
                        items: _person
                            .map<DropdownMenuItem<dynamic>>((dynamic value) {
                          return DropdownMenuItem<dynamic>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (dynamic value) {
                          setState(() {
                            print("Value$value");

                            _personType = value;
                          });
                        },
                        // validator: (value) =>
                        //     value == null ? 'Please Select Country' : null,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.only(top: 0.0, left: 12.0),
                        child: RichText(
                          text: TextSpan(
                              text: "Your Name",
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
                        style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.only(top: 0.0, left: 12.0),
                        child: RichText(
                          text: TextSpan(
                              text: "We do we email you?",
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
                        style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.only(top: 0.0, left: 12.0),
                        child: RichText(
                          text: TextSpan(
                              text: "Have a phone number?",
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
                        style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.only(top: 0.0, left: 12.0),
                        child: RichText(
                          text: TextSpan(
                              text: "What's on your mind?",
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
                          style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                          ),
                          maxLines: 4),
                    ),
                    InkWell(
                        onTap: () async {},
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        child: Container(
                          width: 130,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFb7956c),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xFFb7956c),
                          ),
                          margin: const EdgeInsets.only(
                              top: 20.0, left: 10.0, right: 10.0),
                          child: Center(
                            child: Text(
                              "Send",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        )),
                  ]),
                )
              ],
            ),
          ),
        ));
  }
}
