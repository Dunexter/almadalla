import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/models/BankAccountsModel.dart';
import 'package:almadalla/models/BankSaveUpdateParamsModel.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/ParamsModel.dart';
import 'package:almadalla/screens/BankAccountsScreen.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class BankDetailsPage extends StatefulWidget {
  BankDetailsPage({Key? key, required this.title,required this.loginData,required this.bankAccountsModel,}) : super(key: key);

  final String title;
  final BankAccountsModel bankAccountsModel;
  final LoginData? loginData;
 // List<BankAccountsModel>? BankAccountsModel

  @override
  _BankDetailsPageState createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage> {
  bool isLoginProgress = false;
  final _swiftCodeController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _IbanController = TextEditingController();
  String errorMessageSwiftCode = "";
  String  errorMessageBank="";
  String errorMessageIban = "";
  String errorMessageAccountNumber = "";
  List<String> _active = [
    'True',
    'False',
  ];
  String? swiftCode;
  ParamsModel? _bankType;
  List<String> _bank = [

  ];
  bool value = false;
  void _onSettingEnd(context) {
    /*Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => BankAccountsPage(
            title: '', loginData: widget.loginData,
          )),
    );*/
    Navigator.pop(context,  widget.loginData);
  //  Navigator.of(context).pop();
  }

  String? _activeType;
  String? bankName;
  int? bankKey;
  Future<List<ParamsModel>?>? banks;
  Future<void>   _onUpdateClicked() async {
    setState(() {
      isLoginProgress = true;
    });
    BankSaveUpdateParamsModel? bankSaveUpdateParamsModel;
    bankSaveUpdateParamsModel = new BankSaveUpdateParamsModel();
    if(_bankType == null ){
      bankSaveUpdateParamsModel.bankKey= bankKey.toString();
    }
    else{
      bankSaveUpdateParamsModel.bankKey = _bankType?.key.toString();
    }
    print("bankKey${bankSaveUpdateParamsModel.bankKey}");
    bankSaveUpdateParamsModel.iban =
    _IbanController.text.isNotEmpty ? _IbanController.text : "";
    print("iban${ bankSaveUpdateParamsModel.iban}");
    bankSaveUpdateParamsModel.accountName =
    _accountNameController.text.isNotEmpty ? _accountNameController.text : "";
    print("accountName${ bankSaveUpdateParamsModel.accountName}");
    bankSaveUpdateParamsModel.swiftCode =
    _swiftCodeController.text.isNotEmpty ? _swiftCodeController.text : "";

    print("swiftCode${bankSaveUpdateParamsModel.swiftCode}");
    if (_activeType == null) {
      bankSaveUpdateParamsModel.accountStatus = "True";
    } else {
      bankSaveUpdateParamsModel.accountStatus = _activeType.toString();
    }

    print("accountStatus${bankSaveUpdateParamsModel.accountStatus}");


    String?   response =  await  RestDatasource().saveBankDetails(widget.loginData, bankSaveUpdateParamsModel);
    if (response != null && response.isNotEmpty) {
      setState(() {
        isLoginProgress = false;
      });
      SnackBar successMessage =
      SnackBar(content: new Text("Details Updated Successfully"));
      ScaffoldMessenger.of(context).showSnackBar(successMessage);
    } else {
      setState(() {
        isLoginProgress = false;
      });
      SnackBar successMessage =
      SnackBar(content: new Text("Bank Details Not Updated"));
      ScaffoldMessenger.of(context).showSnackBar(successMessage);
    }

  }
  void initState() {
    super.initState();
    banks =
        RestDatasource().getBanks(widget.loginData);
    swiftCode=widget.bankAccountsModel.swiftCode;
    String? accountName=widget.bankAccountsModel.accountName;
    String? iban=widget.bankAccountsModel.iban;
     bankName=widget.bankAccountsModel.bank;
    bankKey=widget.bankAccountsModel.key;

    if(swiftCode != null){
      _swiftCodeController.text=swiftCode!;}
    _accountNameController.text=accountName!;
    _IbanController.text=iban!;
    bool? type=widget.bankAccountsModel.status;
    print("swiftCode$swiftCode");
    print("accountName$accountName");
    print("iban$iban");
    if(type== true){
      _activeType="True";
    }else{
      _activeType="False";
    }
  }
  @override
  Widget build(BuildContext context) {
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
              child:SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      LocaleKeys.bank_details.tr(),
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  Align(
                    alignment: value == true? Alignment.topRight:Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.only(top: 15.0, left: 12.0,right: 12.0),
                      child: RichText(
                        text: TextSpan(
                            text: LocaleKeys.bank.tr(),
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
                        borderRadius: new BorderRadius.all(Radius.circular(5.0))
                        // color: Colors.white12,
                        ),
                    alignment: FractionalOffset.center,
                    child: FutureBuilder<List<ParamsModel>?>(
                      future: banks, // async work
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ParamsModel>?>
                          snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Container(
                                child: Center(
                                    child:
                                    CupertinoActivityIndicator()));
                          default:
                            if (snapshot.hasError)
                              return Text(LocaleKeys.try_again);
                            else
                              return getBankDataWidget(
                                  snapshot.data);
                        }
                      },
                    ),
                  ),
                  Align(
                      alignment: value == true? Alignment.topRight:Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 0.0, top: 2.0, bottom: 3.0),
                        child: Text(
                          errorMessageBank,
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      )),
                  Align(
                    alignment: value == true? Alignment.topRight:Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.only(top: 0.0, left: 12.0,right:12.0),
                      child: Text(
                        LocaleKeys.swift_code.tr(),
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
                        borderRadius: new BorderRadius.all(Radius.circular(5.0))
                        // color: Colors.white12,
                        ),
                    alignment: FractionalOffset.center,
                    child: new TextFormField(
                      enabled: false,
                      controller: _swiftCodeController,
                      // onChanged: (text) {
                      //   print('First text field: $text');
                      //   email=text;
                      // },
                      style: TextStyle(color: Colors.grey),
//                                initialValue: "user@ionicfirebaseapp.com",
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Align(
                      alignment: value == true? Alignment.topRight:Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 0.0, top: 2.0, bottom: 3.0),
                        child: Text(
                          errorMessageSwiftCode,
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      )),
                  Align(
                    alignment: value == true? Alignment.topRight:Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.only(top: 0.0, left: 12.0,right:12.0),
                      child: Text(
                        LocaleKeys.account_name.tr(),
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
                        borderRadius: new BorderRadius.all(Radius.circular(5.0))
                        // color: Colors.white12,
                        ),
                    alignment: FractionalOffset.center,
                    child: new TextFormField(
                      controller: _accountNameController,
                      style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Align(
                      alignment: value == true? Alignment.topRight:Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 0.0, top: 2.0, bottom: 3.0),
                        child: Text(
                          errorMessageAccountNumber,
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      )),
                  Align(
                    alignment: value == true? Alignment.topRight:Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.only(top: 0.0, left: 12.0,right:12.0),
                      child: Text(
                        //"IBAN",
                        LocaleKeys.iban.tr(),
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
                        borderRadius: new BorderRadius.all(Radius.circular(5.0))
                        // color: Colors.white12,
                        ),
                    alignment: FractionalOffset.center,
                    child: new TextFormField(
                      controller: _IbanController,
                      style: TextStyle(color: Colors.black),
//                                initialValue: "user@ionicfirebaseapp.com",
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Align(
                      alignment: value == true? Alignment.topRight:Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 0.0, top: 2.0, bottom: 3.0),
                        child: Text(
                          errorMessageIban,
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      )),
                  Align(
                    alignment: value == true? Alignment.topRight:Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.only(top: 0.0, left: 12.0, right:12.0),
                      child: Text(
                        LocaleKeys.active.tr(),
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
                        borderRadius: new BorderRadius.all(Radius.circular(5.0))
                        // color: Colors.white12,
                        ),
                    alignment: FractionalOffset.center,
                    child: DropdownButtonFormField<dynamic>(
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                      ),
                      value: _activeType,
                      // hint: Text('-- Select Member --',
                      //     style: TextStyle(
                      //       color: Colors.black,
                      //     )),
                      hint: RichText(
                        text: TextSpan(
                          text: "True",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      // this is the magic
                      items: _active
                          .map<DropdownMenuItem<dynamic>>((dynamic value) {
                        return DropdownMenuItem<dynamic>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (dynamic value) {
                        setState(() {
                          print("Value$value");

                          _activeType = value;
                        });
                      },
                      // validator: (value) =>
                      //     value == null ? 'Please Select Country' : null,
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () async {
                              if (!isLoginProgress) {
                                if ((_swiftCodeController.text.isNotEmpty &&
                                    _accountNameController.text.isNotEmpty &&
                                    _IbanController.text.isNotEmpty
                                 )) {
                                  _onUpdateClicked();
                                } else {

                                  if (_swiftCodeController.text.isEmpty) {
                                    setState(() {
                                      errorMessageSwiftCode =
                                          "Invalid SwiftCode";
                                    });
                                  } else {
                                    setState(() {
                                      errorMessageSwiftCode = "";
                                    });
                                  }
                                  if (_IbanController.text.isEmpty) {
                                    setState(() {
                                      errorMessageIban = "Invalid IBAN";
                                    });
                                  } else {
                                    setState(() {
                                      errorMessageIban = "";
                                    });
                                  }
                                  if (_accountNameController.text.isEmpty) {
                                    setState(() {
                                      errorMessageAccountNumber =
                                          "Invalid Account Name";
                                    });
                                  } else {
                                    setState(() {
                                      errorMessageAccountNumber = "";
                                    });
                                  }
                                }
                              }
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            child: Container(
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
                                  top: 20.0, left: 20.0, right: 20.0,bottom: 20),
                              child: Center(
                                child: Text(
                                  LocaleKeys.update_bank_details.tr(),
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            )),
                        isLoginProgress
                            ? Center(
                                child: Container(
                                    width: 10,
                                    //margin: const EdgeInsets.only(top: 5.0,bottom: 10),
                                    child: Center(
                                        child: CupertinoActivityIndicator())))
                            : Container(
                                width: 10,
                              )
                      ])
                ],
              ),
            ))));
  }
  Widget getBankDataWidget(List<ParamsModel>? param) {
    return DropdownButtonFormField<dynamic>(
      isExpanded: true,
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      value: _bankType,
      hint: Text(bankName!,
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
      onChanged: (dynamic value) {
        ParamsModel? paramsModel;
        setState(() {
          print("Value$value");
          _bankType = value;
          //  String hhh=_bankType.
          //    _bankSwiftCodeController.text = _bankType!.swiftCode!;
          print("Selected city is ----> $_bankType");
        });
        _swiftCodeController.text=_bankType!.swiftCode!;
      },
    );
  }
}
