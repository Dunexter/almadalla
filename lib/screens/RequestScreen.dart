import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/UserRequestModel.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class RequestScreen extends StatefulWidget {
  RequestScreen({Key? key, required this.title, required this.loginData})
      : super(key: key);

  final String title;
  final LoginData? loginData;

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  void _onBackButtonTap(context) {
    /*Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => DashBoardPage(
                title: '',
              )),
    );*/
    Navigator.of(context).pop();
  }

  bool isSearchProgress = false;
  int _selectedIndex = 0;
  _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
      isSearchProgress = true;
    });

  }
  void _showRequestButton(String? key) async {
    setState(() {
      isSearchProgress = true;
    });
    int keyValue = int.parse(key!);
    UserRequestModel? userRequestModel;
    userRequestModel = new UserRequestModel();
    userRequestModel.OnlineUserRequestTypeKey = keyValue;
    String? response = await RestDatasource()
        .saveUserRequest(widget.loginData, userRequestModel);
    if (response!.isNotEmpty && response == "success") {
      setState(() {
        isSearchProgress = false;
      });
      SnackBar successMessage = SnackBar(content: new Text( LocaleKeys.request_sent.tr()));
      ScaffoldMessenger.of(context).showSnackBar(successMessage);
    } else {
      setState(() {
        isSearchProgress = false;
      });
      String? msg = response;
      String? finalString = "";
      if (response.contains(',')) {
        String regex = ",";
        String result = response.replaceAll(regex, "");
        List<String> values = result.split(" ");
        print("values$values");
        for (int i = 0; i < values.length; i++) {
          finalString = finalString! + " " + values[i].tr();
        }
        print("finalString$finalString");

        SnackBar requestErrorMessage =
            SnackBar(content: new Text(finalString!));
        ScaffoldMessenger.of(context).showSnackBar(requestErrorMessage);
      } else {
        String errorMessage = response.tr();
        print("msg$msg");
        SnackBar requestScreenErrorMessage =
            SnackBar(content: new Text(errorMessage));
        ScaffoldMessenger.of(context).showSnackBar(requestScreenErrorMessage);
      }
    }
    setState(() {
        isSearchProgress = false;
      });
  }

  Future<List<UserRequestModel>?>? userRequest;
  void initState() {
    userRequest = RestDatasource().getUserRequestList(widget.loginData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isSearchProgress,
      child: Scaffold(
          backgroundColor: Color(0xFFeeede7),
          appBar: AppBar(
              title: Text(widget.title),
              backgroundColor: Color(0xFFeeede7),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              actions: <Widget>[],
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.black87,
                  onPressed: () {
                    _onBackButtonTap(context);
                  })),
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
              child: Column(children: [
                Center(
                  child: Text(
                    LocaleKeys.requests
                        .tr(),
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
                          left: 10.0, top: 5.0, right: 10.0, bottom: 10),
                      child: FutureBuilder<List<UserRequestModel>?>(
                        future: userRequest, // async work
                        builder: (BuildContext context,
                            AsyncSnapshot<List<UserRequestModel>?> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Container(
                                  child: Center(
                                      child: CupertinoActivityIndicator()));
                            default:
                              if (snapshot.hasError)
                                return Text(
                                  LocaleKeys.try_again.tr(),
                                );
                              else
                                return getUserRequestWidget(snapshot.data);
                          }
                        },
                      ),
                    )),
              ]))),
    );
  }

  Widget getUserRequestWidget(List<UserRequestModel>? userRequestModel) {
    return SingleChildScrollView(
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
                        child: ListTile(
                          leading: Text( LocaleKeys.select_request
                              .tr(),
                              style: TextStyle(fontSize: 15.0)),
                        )),
                    Container(
                      child: Column(children: [
                        ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: userRequestModel!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                  onTap: () {},
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: Row(children: <Widget>[
                                              Expanded(
                                                  flex: 6,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                    ),
                                                    child: Text(
                                                        userRequestModel != null
                                                            ? userRequestModel[
                                                                        index]
                                                                    .name ??
                                                                'No data'
                                                            : 'No data',
                                                        style: TextStyle(
                                                            fontSize: 15.0)),
                                                  )),
                                              Expanded(
                                                  flex: 4,
                                                  child: InkWell(
                                                      onTap: () {
                                                        _onSelected(index);
                                                        String?
                                                            onlineUserRequestKey =
                                                            userRequestModel[
                                                                    index]
                                                                .OnlineUserRequestTypeKey
                                                                .toString();
                                                        _showRequestButton(
                                                            onlineUserRequestKey);
                                                      },
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 0),
                                                          child: Container(
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                InkWell(
                                                                    splashColor:
                                                                        Colors
                                                                            .transparent,
                                                                    highlightColor:
                                                                        Colors
                                                                            .transparent,
                                                                    focusColor:
                                                                        Colors
                                                                            .transparent,
                                                                    child:
                                                                        Container(
                                                                          width: 90,
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              10),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              Color(0xFFb7956c),
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10)),
                                                                        color: Color(
                                                                            0xFFb7956c),
                                                                      ),
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              0.0,
                                                                          left:
                                                                              5.0,
                                                                          right:
                                                                              5.0),
                                                                      child: Center(
                                                                          child: Text(
                                                                            LocaleKeys.request
                                                                                .tr(),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white, fontSize:12),
                                                                      )),
                                                                    )),
                                                                _selectedIndex == index &&  isSearchProgress
                                                                    ? Center(
                                                                        child: Container(
                                                                            width:
                                                                                10,
                                                                            margin:
                                                                                const EdgeInsets.only(left: 8, right: 8),
                                                                            child: Center(child: CupertinoActivityIndicator())))
                                                                    : Container(
                                                                        width:
                                                                            10,
                                                                      )
                                                              ],
                                                            ),
                                                          )))),
                                            ]))
                                      ],
                                    ),
                                  ));
                            }),
                      ]),
                    )
                  ],
                ))));
  }
}
