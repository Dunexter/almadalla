import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/customwidgets/CustomDrawer.dart';
import 'package:almadalla/models/AlMadallaMemberModel.dart';
import 'package:almadalla/models/BankAccountsModel.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/UserSettingsBloc.dart';
import 'package:almadalla/screens/AddbankAccountScreen.dart';
import 'package:almadalla/screens/BankDetailsScreen.dart';
import 'package:almadalla/screens/ChangePasswordScreen.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'MemberDetails.dart';
import 'ProfileScreen.dart';
import 'package:easy_localization/easy_localization.dart';

class BankAccountsPage extends StatefulWidget {
  BankAccountsPage({Key? key, required this.title, required this.loginData})
      : super(key: key);

  final String title;
  final LoginData? loginData;

  @override
  _BankAccountsPageState createState() => _BankAccountsPageState();
}

class _BankAccountsPageState extends State<BankAccountsPage> {
  Future<AlMadallaMemberModel?>? alMadallaCardFuture;

  void _onChangePasswordEnd(context) {
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChangePasswordPage(title: '')),
    );*/
    // Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => DashBoardPage(
                title: '',
              )),
    );
  }

  LoginData? login;
  Future<List<BankAccountsModel>?>? bankAccounts;
  // Future<BankAccountsModel?>? bankAccounts;
  void initState() {
    setState(() {
      if (login != null) {
        loadBankDetails(login!);
      } else {
        bankAccounts = RestDatasource().getBankAccounts(widget.loginData);
      }
    });
    super.initState();
  }

  loadBankDetails(LoginData login) {
    setState(() {
      bankAccounts = RestDatasource().getBankAccounts(login);
    });
  }

  String? bankName;
  String? swiftCode;
  String? accountName;
  String? iban;
  String? status;

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            height: 200.0,
            width: 200.0,
            child: Stack(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 50, left: 20,right: 20,bottom: 20),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: SingleChildScrollView(
                        child: Container(
                          // height: 100,
                          child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Column(children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Text(LocaleKeys.bank_name.tr(),),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Text(bankName!),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 3),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Text(LocaleKeys.swift_code.tr()),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(swiftCode!),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Text(LocaleKeys.account_name.tr()),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(accountName!),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Text(LocaleKeys.iban.tr()),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(iban!),
                                      ),
                                      // Text(iban!),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Text("Status"),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(status!),
                                      ),
                                    ],
                                  ),
                                ),
                              ])),
                        ),
                      ),
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
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          LocaleKeys.bank_details.tr(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, right: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        //  ),
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  UserSettingsBloc? userSettingsBloc;
  @override
  Widget build(BuildContext context) {
    userSettingsBloc = Provider.of<UserSettingsBloc>(context, listen: false);
    return Scaffold(
        backgroundColor: Color(0xFFeeede7),
        appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: Color(0xFFeeede7),
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: ()  async {
        final data=await   Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => AddBankAccountPage(
                              title: '',
                              loginData: userSettingsBloc!.getLoginData(),
                            )),
                  );
        loadBankDetails(data);
                },
              ), //IconButton
              //IconButton
            ],
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.black87,
                onPressed: () {
                  _onChangePasswordEnd(context);
                })),
        //drawer: CustomDrawer(),
        body:  Container(
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
          child: Column(
           // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
              LocaleKeys.bank_accounts.tr(),
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            Expanded(
            flex: 17,
             child: Padding(
             padding: const EdgeInsets.only(
              left: 10.0, top: 5.0, right: 10.0,bottom: 10),
                child: FutureBuilder<List<BankAccountsModel>?>(
                  future: bankAccounts, // async work
                  builder: (BuildContext context,
                      AsyncSnapshot<List<BankAccountsModel>?> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Expanded(

                          //color: Colors.red,

                            child: Center(child: CupertinoActivityIndicator()));
                      default:
                        if (snapshot.hasError)
                          return Text(LocaleKeys.try_again.tr());
                        else
                          return  Padding(
                            padding:
                            const EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0),child:getCardDataWidget(snapshot.data));
                    }
                  },
                ),))

            ],
          ),
        ));
  }

  Widget getCardDataWidget(List<BankAccountsModel>? BankAccountsModel) {
    return    SingleChildScrollView(
     child: Container(
        width: MediaQuery.of(context).size.width,
         child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFc5a56a),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        topLeft: Radius.circular(15.0),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    // color: Color(0xFFb7956c),
                  child:Row(
                    children:<Widget> [
                    Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5,right: 5),
                      child:Text(LocaleKeys.bank_name.tr(),
                          style: TextStyle(fontSize: 15.0))

                    )
    ),
                      Expanded(
                          flex: 3,
                          child: Text( LocaleKeys.iban.tr(),
                              style: TextStyle(fontSize: 15.0))),
                      Expanded(
                          flex: 2,
                          child: Text(LocaleKeys.status.tr(),
                              style: TextStyle(fontSize: 15.0))),

                    ],
                  )

                    // child: ListTile(
                    //     leading: Text(LocaleKeys.bank_name.tr(),
                    //         style: TextStyle(fontSize: 15.0)),
                    //     title: Padding(
                    //       padding: const EdgeInsets.only(
                    //         left: 0.0,right:0.0
                    //       ),
                    //       child: Text(
                    //         "IBAN",
                    //         style: TextStyle(fontSize: 15.0),
                    //       ),
                    //     ),
                    //     trailing: Padding(
                    //       padding: const EdgeInsets.only(
                    //         right: 30.0,
                    //       ),
                    //       child: Text(LocaleKeys.status.tr(),
                    //           style: TextStyle(fontSize: 15.0)),
                    //     ))

                ),

                  ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:BankAccountsModel!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                            onTap: () {
                              bankName = BankAccountsModel != null
                                  ? BankAccountsModel[index].bank ?? 'No data'
                                  : 'No data';
                              swiftCode = BankAccountsModel != null
                                  ? BankAccountsModel[index].swiftCode ??
                                      'No data'
                                  : 'No data';
                              accountName = BankAccountsModel != null
                                  ? BankAccountsModel[index].accountName ??
                                      'No data'
                                  : 'No data';
                              iban = BankAccountsModel != null
                                  ? BankAccountsModel[index].iban ?? 'No data'
                                  : 'No data';
                              status = BankAccountsModel != null
                                  ? BankAccountsModel[index].status.toString()
                                  : "";
                              _showDialog();
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:<Widget> [
                                      Expanded(
                                          flex: 3,
                                          child: Padding(
                                              padding: EdgeInsets.only(left: 10,right: 10, top:5,bottom: 5),
                                              child: Text(
                                                  BankAccountsModel != null
                                                      ? BankAccountsModel[index]
                                                      .bank ??
                                                      'No data'
                                                      : 'No data',
                                                  style: TextStyle(fontSize: 15.0)),

                                          )
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: EdgeInsets.only( top:5),
                                            child: Text(
                                              BankAccountsModel != null
                                                  ? BankAccountsModel[index].iban ??
                                                  'No data'
                                                  : 'No data',
                                              style: TextStyle(fontSize: 15.0),
                                            ),
                                          ),),
                                      Expanded(
                                          flex: 2,
                                          child:Row(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only( top:5),
                                                child: Text(
                                                  BankAccountsModel != null
                                                      ? BankAccountsModel[
                                                  index]
                                                      .status
                                                      .toString()
                                                      : 'No data',
                                                  style: TextStyle(
                                                      fontSize: 15.0),
                                                ),
                                              ),
                                              IconButton(
                                                padding: EdgeInsets.only( top:8, left: 10,right:10),
                                                  constraints: BoxConstraints(),
                                                  icon: Icon(Icons.edit,),
                                                  iconSize: 15,
                                                  color: Colors.black87,
                                                  onPressed: ()  async {
                                                                                  final login=await   Navigator.of(context)
                                                        .push(
                                                      MaterialPageRoute(
                                                          builder: (_) => BankDetailsPage(
                                                              title: '',
                                                              loginData:
                                                              userSettingsBloc!
                                                                  .getLoginData(),
                                                              bankAccountsModel:
                                                              BankAccountsModel[index])),
                                                    );
                                               loadBankDetails(login);
                                                  })
                                            ],
                                          )),

                                    ],
                                  )
                                  // ListTile(
                                  //     leading: Container(
                                  //       width: 100,
                                  //       child: Text(
                                  //           BankAccountsModel != null
                                  //               ? BankAccountsModel[index]
                                  //                       .bank ??
                                  //                   'No data'
                                  //               : 'No data',
                                  //           style: TextStyle(fontSize: 15.0)),
                                  //     ),
                                  //     title: Text(
                                  //       BankAccountsModel != null
                                  //           ? BankAccountsModel[index].iban ??
                                  //               'No data'
                                  //           : 'No data',
                                  //       style: TextStyle(fontSize: 15.0),
                                  //     ),
                                  //     trailing: Container(
                                  //         width: 95,
                                  //         child: Padding(
                                  //             padding: const EdgeInsets.only(
                                  //               left: 8.0,
                                  //             ),
                                  //             child: Row(
                                  //               children: [
                                  //                 Text(
                                  //                   BankAccountsModel != null
                                  //                       ? BankAccountsModel[
                                  //                               index]
                                  //                           .status
                                  //                           .toString()
                                  //                       : 'No data',
                                  //                   style: TextStyle(
                                  //                       fontSize: 15.0),
                                  //                 ),
                                  //                 IconButton(
                                  //                     icon: Icon(Icons.edit),
                                  //                     iconSize: 20,
                                  //                     color: Colors.black87,
                                  //                     onPressed: () {
                                  //                       Navigator.of(context)
                                  //                           .push(
                                  //                         MaterialPageRoute(
                                  //                             builder: (_) => BankDetailsPage(
                                  //                                 title: '',
                                  //                                 loginData:
                                  //                                     userSettingsBloc!
                                  //                                         .getLoginData(),
                                  //                                 bankAccountsModel:
                                  //                                     BankAccountsModel[
                                  //                                         index])),
                                  //                       );
                                  //                     })
                                  //               ],
                                  //             )))),
                                ],
                              ),
                            ));
                      })

              ],
            ))));
  }
}
