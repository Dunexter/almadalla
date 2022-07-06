import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/customwidgets/CustomDrawer.dart';
import 'package:almadalla/models/AlMadallaMemberModel.dart';
import 'package:almadalla/models/BankAccountsModel.dart';
import 'package:almadalla/models/ClaimsModel.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/ParamsModel.dart';
import 'package:almadalla/models/SearchClaimsParams.dart';
import 'package:almadalla/models/SubmitClaimParams.dart';
import 'package:almadalla/models/UserSettingsBloc.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/screens/HealthCareProviderScreen.dart';
import 'package:almadalla/screens/LanguageBloc.dart';
import 'package:almadalla/screens/SettingsScreen.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class SubmitClaimsPage extends StatefulWidget {
  SubmitClaimsPage({Key? key, required this.title, required this.loginData})
      : super(key: key);

  final String title;
  final LoginData? loginData;
  @override
  _SubmitClaimsPageState createState() => _SubmitClaimsPageState();
}

class _SubmitClaimsPageState extends State<SubmitClaimsPage> {
  // void _onSearchTap(context) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(builder: (_) => HealthCareProviderPage(title: '')),
  //   );
  // }
  bool isLoginProgress = false;
  bool _checkbox = false;
  //String? memberKey;
  List<String> _member = [
    'Rank Insurance',
  ];
  List<String> _payment = ['Bank Transfer', 'Cheque'];
  List<String> _bankAccount = ['All'];
  List<String> _bank = [
    'All',
  ];
  List<String> _submissionType = ['Submission', 'Resubmission'];
  bool enabledText = false;
  final _claimedCost = TextEditingController();
  Future<List<AlMadallaMemberModel>?>? alMadallaCardFuture;
  // Future<AlMadallaMemberModel?>? alMadallaCardFuture;
  //String? _bankAccountType;
  String? _paymentType;
  // String? _bankType;
  // String? _memberType;
  String? newPath;
  String? galleryPath;
  String? formattedFromDate;
  String? formattedToDate;
  DateTime? _fromDate;
  String? fileName;
  String? firstOptionFileName;
  String? secondOptionFileName;
  String? thirdOptionFileName;
  PickedFile? _imageFile;
  bool? firstOption = false;
  bool? secondOption = false;
  bool? thirdOption = false;
  String? docPath;
  String? optionOneFilePath;
  String? optionTwoFilePath;
  String? optionThreeFilePath;
  String? swiftCode;
  String? submissionType;
  DateTime? endTime = DateTime.now();
  final picker = ImagePicker();
  String? todayDateFormat =
      DateFormat('dd-MMM-yyyy', 'en').format(DateTime.now());
  String errorMessageMember = "";
  String errorMessagePaymentType = "";
  String errorMessageClaimedCost = "";
  String errorMessageClaimedAttachment = "";
  String errorMessageBank = "";
  String errorMessageBankAccount = "";
  String errorMessageBankIban = "";
  String errorMessageReason = "";
  String errorMessageSubmissionClaimRef = "";
  DateTime startTime = new DateTime(DateTime.now().year - 1, DateTime.january);
  final _formKey = GlobalKey<FormState>();
  ParamsModel? _currencyType;
  ParamsModel? _bankType;
  AlMadallaMemberModel? _membertype;
  BankAccountsModel? _bankAccountType;
  Future<List<ParamsModel>?>? currencies;
  Future<List<ParamsModel>?>? banks;
  Future<List<BankAccountsModel>?>? bankAccounts;
  final _submissionClaimRefController = TextEditingController();
  final _bankSwiftCodeController = TextEditingController();
  final _bankAccountNameController = TextEditingController();
  final _bankAccountIbanController = TextEditingController();
  final _bankController = TextEditingController();
  final _reasonController = TextEditingController();
  String? number;
  bool? memberData = false;
  bool type = false;
  UserSettingsBloc? userSettingsBloc;
  bool value = false;
  LanguageBloc? bloc;
  bool isSearchProgress = false;
  void _onFromDateClick() async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _fromDate == null
            ? new DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
              )
            : DateTime(
                _fromDate!.year,
                _fromDate!.month,
                _fromDate!.day,
              ),
        firstDate: DateTime(1899),
        lastDate: DateTime.now()); //DateTime(2100));
    if (pickedDate != null && pickedDate != _fromDate) {
      setState(() {
        _fromDate = pickedDate;
        formattedFromDate = DateFormat('dd-MMM-yyyy', 'en').format(_fromDate!);
      });
      print("selectedDatee$_fromDate");
    }
  }

  List<ClaimsModel>? trackClaimFuture;
  List<ClaimsModel>? tem = [];
  ScrollController _controller = ScrollController();
  void _onScrollEvent() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _controller.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  void initState() {
    alMadallaCardFuture =
        RestDatasource().getAlMadallaMemberDetailsList(widget.loginData);
    currencies = RestDatasource().getCurrencies(widget.loginData);
    banks = RestDatasource().getBanks(widget.loginData);
    bankAccounts = RestDatasource().getBankAccounts(widget.loginData);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onScrollEvent);
    super.dispose();
  }

  Future<String?> _onSubmitClicked() async {
    setState(() {
      isLoginProgress = true;
    });

    SubmitClaimParams? submitClaimsParams;
    submitClaimsParams = new SubmitClaimParams();
    submitClaimsParams.cardNo = int.parse(_membertype!.cardNo!);
    print("--memberKey--${submitClaimsParams.cardNo}");
    submitClaimsParams.serviceDate =
        _fromDate != null ? formattedFromDate : todayDateFormat;
    print("--fromDate--${submitClaimsParams.serviceDate}");
    if (_paymentType == null) {
      submitClaimsParams.paymentType = "2";
    } else {
      if (_paymentType == "Bank Transfer") {
        submitClaimsParams.paymentType = "2";
      } else {
        submitClaimsParams.paymentType = "1";
      }
    }

    print("--_paymentType--${submitClaimsParams.paymentType}");
    if (submissionType == "Resubmission") {
      submitClaimsParams.submissionClaimRef =
          _submissionClaimRefController.text.isNotEmpty
              ? _submissionClaimRefController.text
              : "";
    } else {
      submitClaimsParams.submissionClaimRef = "";
    }
    // submitClaimsParams.submissionClaimRef =
    //     _submissionClaimRefController.text.isNotEmpty
    //         ? _submissionClaimRefController.text
    //         : "";
    print("--submissionClaimRef--${submitClaimsParams.submissionClaimRef}");
    submitClaimsParams.claimedCost =
        _claimedCost.text.isNotEmpty ? _claimedCost.text : "";
    print("--claimedCost--${submitClaimsParams.claimedCost}");
    submitClaimsParams.currencyCode =
        _currencyType?.code != null ? _currencyType?.code : "";
    print("--currencyCode--${submitClaimsParams.currencyCode}");
    submitClaimsParams.claimAttachmentOriginalFileName = fileName;
    print(
        "--claimAttachmentOriginalFileName--${submitClaimsParams.claimAttachmentOriginalFileName}");
    submitClaimsParams.claimAttachmentFilePath = docPath;
    print(
        "--claimAttachmentOriginalFilePath--${submitClaimsParams.claimAttachmentFilePath}");
    submitClaimsParams.optionalAttachment1OriginalFileName =
        firstOptionFileName != null ? firstOptionFileName : "";
    submitClaimsParams.optionalAttachment1FilePath =
        optionOneFilePath != null ? optionOneFilePath : "";
    print(
        "--optionalAttachment1OriginalFileName--${submitClaimsParams.optionalAttachment1OriginalFileName}");
    print(
        "--optionalAttachment1OriginalFilePath--${submitClaimsParams.optionalAttachment1FilePath}");
    submitClaimsParams.optionalAttachment2OriginalFileName =
        secondOptionFileName != null ? secondOptionFileName : "";
    print(
        "--optionalAttachment2OriginalFileName--${submitClaimsParams.optionalAttachment2OriginalFileName}");
    submitClaimsParams.optionalAttachment2FilePath =
        optionTwoFilePath != null ? optionTwoFilePath : "";
    print(
        "--optionalAttachment2OriginalFilePath--${submitClaimsParams.optionalAttachment2FilePath}");
    submitClaimsParams.optionalAttachment3OriginalFileName =
        thirdOptionFileName != null ? thirdOptionFileName : "";
    print(
        "--optionalAttachment3OriginalFileName--${submitClaimsParams.optionalAttachment3OriginalFileName}");
    submitClaimsParams.optionalAttachment3FilePath =
        optionThreeFilePath != null ? optionThreeFilePath : "";
    print(
        "--optionalAttachment3OriginalFilePath--${submitClaimsParams.optionalAttachment3FilePath}");
    submitClaimsParams.memberBankSwiftCode = _bankSwiftCodeController.text;
    print("--memberBankSwiftCode--${submitClaimsParams.memberBankSwiftCode}");
    submitClaimsParams.memberBankAccountName =
        _bankAccountNameController.text.isNotEmpty
            ? _bankAccountNameController.text
            : "";
    print(
        "--memberBankAccountName--${submitClaimsParams.memberBankAccountName}");
    submitClaimsParams.memberBankIBAN =
        _bankAccountIbanController.text.isNotEmpty
            ? _bankAccountIbanController.text
            : "";
    print("--memberBankIBAN--${submitClaimsParams.memberBankIBAN}");
    submitClaimsParams.setAsMemberDefaultAccount = _checkbox;
    submitClaimsParams.reasonForCheque =
        _reasonController.text.isNotEmpty ? _reasonController.text : "";
    submitClaimsParams.useMemberDefaultBankAccount = _checkbox;

    String submitClaimFuture = await RestDatasource()
        .submitClaim(widget.loginData, submitClaimsParams);
    print("response$submitClaimFuture");
    if (submitClaimFuture.isNotEmpty && submitClaimFuture == "success") {
      _claimedCost.clear();
      _bankSwiftCodeController.clear();
      _bankAccountNameController.clear();
      _bankAccountIbanController.clear();
      _submissionClaimRefController.clear();
      _reasonController.clear();
      _bankController.clear();
      fileName = null;
      firstOptionFileName = null;
      secondOptionFileName = null;
      thirdOptionFileName = null;
      _fromDate = null;
      _membertype = null;
      _paymentType = null;
      _bankType = null;
      _currencyType = null;
      _bankAccountType = null;
      submissionType = null;
      enabledText = false;
      setState(() {
        isLoginProgress = false;
        SnackBar submitClaimErrorMessage = SnackBar(
            content: new Text(
          LocaleKeys.submitted_successfully.tr(),
        ));
        ScaffoldMessenger.of(context).showSnackBar(submitClaimErrorMessage);
      });
    } else {
      setState(() {
        isLoginProgress = false;
      });
      print("Submit claims Error message = $submitClaimFuture");

      String? msg = submitClaimFuture;
      String? finalString = "";
      if (submitClaimFuture.contains(',')) {
        String regex = ",";
        String result = submitClaimFuture.replaceAll(regex, "");
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

        SnackBar errorMessage = SnackBar(content: new Text(finalString!));
        ScaffoldMessenger.of(context).showSnackBar(errorMessage);
      } else {
        String errorMessage = submitClaimFuture.tr();
        print("msg$msg");
        SnackBar submitClaimErrorMessage =
            SnackBar(content: new Text(errorMessage));
        ScaffoldMessenger.of(context).showSnackBar(submitClaimErrorMessage);
      }
    }
  }

  void showAddAttachment() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      RawMaterialButton(
                        onPressed: () {
                          getImageFromCamera();
                          Navigator.of(context).pop();
                        },
                        elevation: 2.0,
                        fillColor: Color(0xFFb7956c),
                        child: Icon(
                          Icons.local_see,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        padding: EdgeInsets.all(15.0),
                        shape: CircleBorder(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: new Text("Take Photo"),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      RawMaterialButton(
                        onPressed: () {
                          getImageFromGallery();
                          Navigator.of(context).pop();
                        },
                        elevation: 2.0,
                        fillColor: Color(0xFFb7956c),
                        child: Icon(
                          Icons.photo,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        padding: EdgeInsets.all(15.0),
                        shape: CircleBorder(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: new Text("Pick Photo"),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      RawMaterialButton(
                        onPressed: () {
                          getFile();
                          Navigator.of(context).pop();
                        },
                        elevation: 2.0,
                        fillColor: Color(0xFFb7956c),
                        child: Icon(
                          Icons.cloud,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        padding: EdgeInsets.all(15.0),
                        shape: CircleBorder(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: new Text("Pick File"),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  void _showSearchButton() async {
    if (_membertype != null && _membertype!.memberKey != null) {
      setState(() {
        errorMessageMember = "";
        isSearchProgress = true;
      });
      SearchClaimsParams? searchClaimsParams;
      searchClaimsParams = new SearchClaimsParams();
      searchClaimsParams.memberKey = _membertype!.memberKey;
      print("memberKey${searchClaimsParams.memberKey}");
      searchClaimsParams.fromDate =
          DateFormat('dd-MMM-yyyy', 'en').format(startTime);
      print("fromDate${searchClaimsParams.fromDate}");
      searchClaimsParams.toDate =
          DateFormat('dd-MMM-yyyy', 'en').format(endTime!);
      // DateFormat('dd-MM-yyyy')
      //     .format(endTime!);
      print("toDate${searchClaimsParams.toDate}");
      searchClaimsParams.claimType = "2";

      searchClaimsParams.claimAction = "";
      searchClaimsParams.status = "";

      print("claimType${searchClaimsParams.claimType}");
      print("claimAction${searchClaimsParams.claimAction}");
      print("status${searchClaimsParams.status}");
      searchClaimsParams.claimRef = "";
      print("claimRef${searchClaimsParams.claimRef}");
      searchClaimsParams.showDependantClaims = true;

      trackClaimFuture = await RestDatasource()
          .trackClaims(widget.loginData, searchClaimsParams);
      print("trackClaimFuture length...${trackClaimFuture!.length}");
      if (trackClaimFuture!.isNotEmpty) {
        setState(() {
          isSearchProgress = false;
        });
        for (int i = 0; i < trackClaimFuture!.length; i++) {
          if (trackClaimFuture![i].claimRef != "-") {
            tem!.add(trackClaimFuture![i]);
          }
        }
        print("temp length...${tem!.length}");
        if (tem!.isNotEmpty) {
          _showDialog(tem);
        } else {
          setState(() {
            isSearchProgress = false;
          });

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
                  //height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 50, left: 5),
                          child: Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Center(
                                  child: Text(
                                "No data available",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                              )))),
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
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                LocaleKeys.submission_claim_ref.tr(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          // showDialog(
          //     context: context,
          //     builder: (context) => new AlertDialog(
          //       title: Text("There is no Submission Claim Ref"),
          //       actions: <Widget>[
          //         TextButton(
          //           child: Text("Ok"),
          //           onPressed: () => {Navigator.pop(context, false)},
          //         ),
          //
          //       ],
          //     ));

        }
      } else {
        setState(() {
          isSearchProgress = false;
        });
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
                //height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 50, left: 5),
                        child: Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Center(
                                child: Text(
                              "No data available",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            )))),
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
                              LocaleKeys.submission_claim_ref.tr(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    } else {
      setState(() {
        errorMessageMember = LocaleKeys.please_select_member.tr();
      });
    }
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageFile = pickedFile;
        File? cameraFile = File(pickedFile.path);
        print("cameraFile$cameraFile");
        String dir=path.dirname(pickedFile.path);
        // String dir = path.dirname(pickedFile.path);
        // print("camrradir$dir");
        // newPath = path.join(dir, 'image.jpg');
        // print('NewPath: ${newPath}');
        // File? newFile = cameraFile.renameSync(newPath!);
        print("cameraFile$cameraFile");
        if (firstOption == true) {
          newPath = path.join(dir, 'cameraImage_1.jpg');
          print('NewPath: ${newPath}');
           File? newFileFirstOption = cameraFile.renameSync(newPath!);
          firstOptionFileName = newFileFirstOption.path.split('/').last;
          optionOneFilePath = newPath;
          firstOption = false;
        } else if (secondOption == true) {
          newPath = path.join(dir,'cameraImage_2.jpg');
          print('NewPath: ${newPath}');
          File? newFileSecondOption = cameraFile.renameSync(newPath!);
          secondOptionFileName = newFileSecondOption.path.split('/').last;
          optionTwoFilePath =newPath;
          secondOption = false;
        } else if (thirdOption == true) {
          newPath = path.join(dir,'cameraImage_3.jpg');
          print('NewPath: ${newPath}');
          File? newFileThirdOption = cameraFile.renameSync(newPath!);
          thirdOptionFileName = newFileThirdOption.path.split('/').last;
          optionThreeFilePath = newPath;
          thirdOption = false;
        } else {
          newPath = path.join(dir,'cameraImage.jpg');
          print('NewPath: ${newPath}');
          File? newFiledefault = cameraFile.renameSync(newPath!);
          fileName = newFiledefault.path.split('/').last;
          docPath =newPath;
        }
        print("fileName$fileName");
        print("filepathe$docPath");
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = pickedFile;
        File galleryFile = File(pickedFile.path);
        print("galleryFile$galleryFile");
        String dir = path.dirname(pickedFile.path);
        // galleryPath = path.join(dir, 'galleryImage.jpg');
        // print('galleryPath: ${galleryPath}');
        // File? newGalleryFile = galleryFile.renameSync(galleryPath!);
        // print("newGalleryFile$newGalleryFile");

        if (firstOption == true) {
          galleryPath = path.join(dir, 'galleryImage_1.jpg');
          print('galleryPath: ${galleryPath}');
          File? newGalleryFistOption = galleryFile.renameSync(galleryPath!);
          print("newGalleryFile$newGalleryFistOption");
          firstOptionFileName = newGalleryFistOption.path.split('/').last;
          optionOneFilePath = galleryPath;
          firstOption = false;
        } else if (secondOption == true) {
          galleryPath = path.join(dir, 'galleryImage_2.jpg');
          print('galleryPath: ${galleryPath}');
          File? newGallerySecondOption = galleryFile.renameSync(galleryPath!);
          print("newGalleryFile$newGallerySecondOption");
          secondOptionFileName = newGallerySecondOption.path.split('/').last;
          optionTwoFilePath = galleryPath;
          secondOption = false;
        } else if (thirdOption == true) {
          galleryPath = path.join(dir, 'galleryImage_3.jpg');
          print('galleryPath: ${galleryPath}');
          File? newGalleryThirdOption = galleryFile.renameSync(galleryPath!);
          print("newGalleryFile$newGalleryThirdOption");
          thirdOptionFileName = newGalleryThirdOption.path.split('/').last;
          optionThreeFilePath = galleryPath;
          thirdOption = false;
        } else {
          galleryPath = path.join(dir, 'galleryImage.jpg');
          print('galleryPath: ${galleryPath}');
          File? newGallery = galleryFile.renameSync(galleryPath!);
          print("newGalleryFile$newGallery");
          fileName = newGallery.path.split('/').last;
          docPath = galleryPath;
        }
        print("fileName$fileName");
        print("filepathe$docPath");
      } else {
        print('No image selected.');
      }
    });
  }

  void getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;
      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      setState(() {
        print("hhhhhh$fileName");
        if (firstOption == true) {
          firstOptionFileName = file.name;
          optionOneFilePath = file.path;
          firstOption = false;
        } else if (secondOption == true) {
          secondOptionFileName = file.name;
          optionTwoFilePath = file.path;
          secondOption = false;
        } else if (thirdOption == true) {
          thirdOptionFileName = file.name;
          optionThreeFilePath = file.path;
          thirdOption = false;
        } else {
          fileName = file.name;
          docPath = file.path;
        }
        print("filepathe$docPath");
      });
    } else {
      print('No image selected.');
      // User canceled the picker
    }
  }

  _showDialog(List<ClaimsModel>? param) {
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
            //height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 50, left: 5),
                    child: Container(
                      width: double.infinity,
                      //height: MediaQuery.of(context).size.height * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      // child: SingleChildScrollView(
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: param == null
                              ? 0
                              : (param.length > 10 ? 10 : param.length),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                                onTap: () {
                                  _submissionClaimRefController.text =
                                      param![index].claimRef != null
                                          ? param[index].claimRef ?? 'No data'
                                          : 'No data';
                                  Navigator.of(context).pop();
                                },
                                child: ListTile(
                                    title: Text(
                                  param![index].claimRef != null
                                      ? param[index].claimRef ?? 'No data'
                                      : 'No data',
                                )));
                          }),
                      //
                      //
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
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          LocaleKeys.submission_claim_ref.tr(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
              Navigator.of(context).pop();
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
              child: AbsorbPointer(
                absorbing: isLoginProgress,
                child: SingleChildScrollView(
                  controller: _controller,
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          LocaleKeys.submit_claims.tr(),
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
                            alignment: value == true
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 15.0, left: 12.0, right: 12.0),
                              child: RichText(
                                text: TextSpan(
                                    text: LocaleKeys.member.tr(),
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16.0))
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
                                    new BorderRadius.all(Radius.circular(5.0))
                                // color: Colors.white12,
                                ),
                            alignment: FractionalOffset.center,
                            child: FutureBuilder<List<AlMadallaMemberModel>?>(
                              future: alMadallaCardFuture, // async work
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<AlMadallaMemberModel>?>
                                      snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return Expanded(
                                        flex: 6,
                                        child: Center(
                                            child:
                                                CupertinoActivityIndicator()));
                                  default:
                                    if (snapshot.hasError)
                                      return Text(LocaleKeys.try_again);
                                    else
                                      return getMemberDataWidget(snapshot.data);
                                }
                              },
                            ),
                          ),
                          Align(
                              alignment: value == true
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0,
                                    right: 12.0,
                                    top: 0.0,
                                    bottom: 5.0),
                                child: Text(
                                  errorMessageMember,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red),
                                ),
                              )),

                          Align(
                            alignment: value == true
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 0.0, left: 12.0, right: 12.0),
                              child: RichText(
                                text: TextSpan(
                                    text: LocaleKeys.service_date.tr(),
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16.0))
                                    ]),
                              ),
                            ),
                          ),
                          new Container(
                              padding: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  top: 5.0,
                                  bottom: 5.0),
                              margin: const EdgeInsets.only(
                                  top: 5.0,
                                  left: 15,
                                  right: 15.0,
                                  bottom: 10.0),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _fromDate != null
                                        ? Text("${formattedFromDate}")
                                        : Text("${todayDateFormat}"),
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
                              )
                              //                              child: new TextFormField(
                              //
                              //
                              //                       style: TextStyle(color: Colors.black),
                              // //                                initialValue: "user@ionicfirebaseapp.com",
                              //                       decoration: InputDecoration(
                              //                         hintText: _fromDate != null
                              //                             ? formattedFromDate
                              //                             : todayDateFormat,
                              //                         suffixIcon: IconButton(
                              //                           onPressed: () {
                              //                             FocusScopeNode currentFocus =
                              //                             FocusScope.of(context);
                              //                             currentFocus.unfocus();
                              //                             _onFromDateClick();
                              //                           },
                              //                           icon: Image.asset(
                              //                             'assets/calendar.png',
                              //                             width: 20.0,
                              //                             height: 20.0,
                              //                           ),
                              //                         ),
                              //                         border: InputBorder.none,
                              //                       ),
                              //                       // decoration: new InputDecoration(
                              //                       //   hintText:  _fromDate != null
                              //                       //       ? formattedFromDate:
                              //                       //   todayDateFormat,
                              //                       //   border: InputBorder.none,
                              //                       // ),
                              //                       keyboardType: TextInputType.text,
                              //                     ),
                              ),
                          Align(
                            alignment: value == true
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 12.0, right: 12.0),
                              child: Text(
                                "Submission Type",
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
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(5.0))
                                // color: Colors.white12,
                                ),
                            alignment: FractionalOffset.center,
                            child: DropdownButtonFormField<dynamic>(
                              decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                              ),
                              value: submissionType,
                              hint: Text('Select',
                                  style: TextStyle(
                                    color: Colors.black,
                                  )),

                              // this is the magic
                              items: _submissionType
                                  .map<DropdownMenuItem<dynamic>>(
                                      (dynamic value) {
                                return DropdownMenuItem<dynamic>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (dynamic value) {
                                setState(() {
                                  submissionType = value;
                                });
                                if (submissionType == "Resubmission") {
                                  type = true;
                                } else {
                                  type = false;
                                }
                              },
                              // validator: (value) =>
                              //     value == null ? 'Please Select Country' : null,
                            ),
                          ),
                          submissionType == "Resubmission"
                              ? Align(
                                  alignment: value == true
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 12.0, right: 12.0),
                                    child: RichText(
                                      text: TextSpan(
                                          text: LocaleKeys.submission_claim_ref
                                              .tr(),
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                          children: [
                                            TextSpan(
                                                text: ' *',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 16.0))
                                          ]),
                                    ),
                                  ),
                                )
                              : Container(),
                          submissionType == "Resubmission"
                              ? Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 0.0, left: 12.0, right: 12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            // width:240,

                                            padding: const EdgeInsets.only(
                                                left: 10.0,
                                                right: 10.0,
                                                top: 5.0,
                                                bottom: 5.0),
                                            margin: const EdgeInsets.only(
                                                top: 5.0,
                                                left: 5,
                                                right: 6,
                                                bottom: 10.0),
                                            decoration: new BoxDecoration(
                                                color: Colors.white,
                                                border: new Border.all(
                                                  color: Colors.transparent,
                                                ),
                                                borderRadius:
                                                    new BorderRadius.all(
                                                        Radius.circular(5.0))
                                                // color: Colors.white12,
                                                ),
                                            alignment: FractionalOffset.center,
                                            child: new TextFormField(
                                              controller:
                                                  _submissionClaimRefController,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              //                                initialValue: "user@ionicfirebaseapp.com",
                                              decoration: new InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        /*ElevatedButton(
                                          onPressed: memberData == true ?_showSearchButton:null,
                                          child: /*const Text(
                                            'Search',
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 15),
                                          ),*/
                                          Icon(Icons.search),
                                          style:  ElevatedButton.styleFrom(
                                            minimumSize: Size(10, 20),
                                            primary: Color(0xFFb89669),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                          )
                                        ),*/

                                        InkWell(
                                            //onTap: memberData == true ?_showSearchButton:null,
                                            onTap: _showSearchButton,
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            child: Container(
                                              //width: 150,
                                              padding: const EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color(0xFFb7956c),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                color: Color(0xFFb7956c),
                                              ),
                                              margin: const EdgeInsets.only(
                                                  top: 0.0,
                                                  left: 10.0,
                                                  right: 10.0),
                                              child: Center(
                                                child: Icon(Icons.search,
                                                    color: Colors.white),
                                              ),
                                            )),
                                        isSearchProgress
                                            ? Center(
                                                child: Container(
                                                    width: 10,
                                                    //margin: const EdgeInsets.only(left: 8,right: 8),
                                                    child: Center(
                                                        child:
                                                            CupertinoActivityIndicator())))
                                            : Container(
                                                width: 10,
                                              )
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          submissionType == "Resubmission"
                              ? Align(
                                  alignment: value == true
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0,
                                        right: 12.0,
                                        top: 2.0,
                                        bottom: 3.0),
                                    child: Text(
                                      errorMessageSubmissionClaimRef,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.red),
                                    ),
                                  ))
                              : Container(),
                          Align(
                            alignment: value == true
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 0.0, left: 12.0, right: 12.0),
                              child: RichText(
                                text: TextSpan(
                                    text: LocaleKeys.claimed_cost.tr(),
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16.0))
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
                                    new BorderRadius.all(Radius.circular(5.0))
                                // color: Colors.white12,
                                ),
                            alignment: FractionalOffset.center,
                            child: new TextFormField(
                              // autofocus: true,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true), //TextInputType.number,
                              inputFormatters: [
                                //FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}')),
                              ],
                              controller: _claimedCost,
                              style: TextStyle(color: Colors.black),
                              //                                initialValue: "user@ionicfirebaseapp.com",
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          Align(
                              alignment: value == true
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0,
                                    right: 12.0,
                                    top: 2.0,
                                    bottom: 3.0),
                                child: Text(
                                  errorMessageClaimedCost,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red),
                                ),
                              )),
                          Align(
                            alignment: value == true
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 0.0, left: 12.0, right: 12.0),
                              child: Text(
                                LocaleKeys.Currency.tr(),
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
                                borderRadius:
                                    new BorderRadius.all(Radius.circular(5.0))
                                // color: Colors.white12,
                                ),
                            alignment: FractionalOffset.center,
                            child: FutureBuilder<List<ParamsModel>?>(
                              future: currencies, // async work
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<ParamsModel>?> snapshot) {
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
                                      return getCurrencyDataWidget(
                                          snapshot.data);
                                }
                              },
                            ),
                          ),
                          _currencyType != null && type == false
                              ? Align(
                                  alignment: value == true
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0,
                                        right: 12.0,
                                        top: 2.0,
                                        bottom: 3.0),
                                    child: Text(
                                      "Kindly note that final claim settlement will be in AED and the amount will be according to the conversion rate at the time of settlement.",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.red),
                                    ),
                                  ))
                              : Container(),
                          Align(
                            alignment: value == true
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 12.0, right: 12.0),
                              child: Text(LocaleKeys.mandatory_documents.tr(),
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.black,
                                      fontSize: 14.0)),
                            ),
                          ),

                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                padding: const EdgeInsets.only(
                                    top: 5.0, left: 10.0, right: 10),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 5.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/list-bullet.png',
                                            width: 18.0,
                                            height: 18.0,
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0, right: 5.0),
                                              child: Text(
                                                LocaleKeys
                                                    .reimbursement_claim_form
                                                    .tr(),
                                                //"Reimbursement claim form (filled, signed and \n stamped by the treating physician",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13.0),
                                                maxLines: 3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 5.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/list-bullet.png',
                                            width: 18.0,
                                            height: 18.0,
                                          ),
                                          Flexible(
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0, right: 5.0),
                                                child: Text(
                                                    //    "Medical/ Surgical/ Discharge Summary \n reports if any",
                                                    LocaleKeys.medical.tr(),
                                                    //+ "/" +  LocaleKeys.surgical.tr() + "/" +  LocaleKeys.discharge_summary.tr() + "\n" +  LocaleKeys.reports.tr(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13.0))),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 5.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/list-bullet.png',
                                            width: 18.0,
                                            height: 18.0,
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0, right: 5.0),
                                              child: Text(
                                                  LocaleKeys
                                                      .laboratory_investigation
                                                      .tr(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13.0)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 5.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/list-bullet.png',
                                            width: 18.0,
                                            height: 18.0,
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0, right: 5.0),
                                              child: Text(
                                                  LocaleKeys
                                                      .prescription_invoice
                                                      .tr(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13.0)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                          top: 5.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/list-bullet.png',
                                              width: 18.0,
                                              height: 18.0,
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0, right: 5.0),
                                                child: Text(
                                                    LocaleKeys.claim_translated
                                                        .tr(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13.0)),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                )),
                          ),

                          Align(
                            alignment: value == true
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 12.0, right: 12.0),
                              child: RichText(
                                text: TextSpan(
                                    text: LocaleKeys.claim_attachment.tr(),
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16.0))
                                    ]),
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () async {
                              showAddAttachment();
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFFc1c1c1),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Color(0xFFc1c1c1),
                                ),
                                margin: const EdgeInsets.only(
                                    top: 5.0, left: 15.0, right: 15.0),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5.0, top: 5),
                                  child: Text(
                                    LocaleKeys.choose_file.tr(),
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.black87),
                                  ),
                                )),
                          ),
                          //                     new Container(
                          //                       padding: const EdgeInsets.only(
                          //                           left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                          //                       margin: const EdgeInsets.only(
                          //                           top: 5.0, left: 15, right: 15.0, bottom: 10.0),
                          //                       decoration: new BoxDecoration(
                          //                           color: Colors.grey,
                          //                           border: new Border.all(
                          //                             color: Colors.transparent,
                          //                           ),
                          //                           borderRadius:
                          //                           new BorderRadius.all(Radius.circular(5.0))
                          //                         // color: Colors.white12,
                          //                       ),
                          //                       alignment: FractionalOffset.center,
                          //                       child: new TextFormField(
                          //                         style: TextStyle(color: Colors.black),
                          // //                                initialValue: "user@ionicfirebaseapp.com",
                          //                         decoration: new InputDecoration(
                          //                           hintText:"Choose file",
                          //                           hintStyle: TextStyle(
                          //                               fontSize: 15.0, color: Colors.black87),
                          //                           border: InputBorder.none,
                          //                         ),
                          //                       ),
                          //                     ),
                          Align(
                              alignment: value == true
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 15.0, right: 15.0),
                                  child: fileName != null
                                      ? Text("${fileName}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0))
                                      : Text(LocaleKeys.no_file.tr(),
                                          style: TextStyle(
                                              color: Color(0xFFc69968),
                                              fontSize: 15.0,
                                              fontStyle: FontStyle.italic)))),

                          Align(
                              alignment: value == true
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0,
                                    right: 12.0,
                                    top: 2.0,
                                    bottom: 3.0),
                                child: Text(
                                  errorMessageClaimedAttachment,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red),
                                ),
                              )),
                          Align(
                            alignment: value == true
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 0.0, left: 12.0, right: 12.0),
                              child: Text(
                                LocaleKeys.optional_attachment_one.tr(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () async {
                              firstOption = true;
                              showAddAttachment();
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFFc1c1c1),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Color(0xFFc1c1c1),
                                ),
                                margin: const EdgeInsets.only(
                                    top: 5.0, left: 15.0, right: 15.0),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5.0, top: 5),
                                  child: Text(
                                    LocaleKeys.choose_file.tr(),
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.black87),
                                  ),
                                )),
                          ),
                          Align(
                              alignment: value == true
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 15.0, right: 15.0),
                                  child: firstOptionFileName != null
                                      ? Text("${firstOptionFileName}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0))
                                      : Text(LocaleKeys.no_file.tr(),
                                          style: TextStyle(
                                              color: Color(0xFFc69968),
                                              fontSize: 15.0,
                                              fontStyle: FontStyle.italic)))),
                          Align(
                            alignment: value == true
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 20.0, left: 12.0, right: 12.0),
                              child: Text(
                                LocaleKeys.optional_attachment_two.tr(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () async {
                              secondOption = true;
                              showAddAttachment();
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFFc1c1c1),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Color(0xFFc1c1c1),
                                ),
                                margin: const EdgeInsets.only(
                                    top: 5.0, left: 15.0, right: 15.0),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5.0, top: 5),
                                  child: Text(
                                    LocaleKeys.choose_file.tr(),
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.black87),
                                  ),
                                )),
                          ),

                          Align(
                              alignment: value == true
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 15.0, right: 15.0),
                                  child: secondOptionFileName != null
                                      ? Text("${secondOptionFileName}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0))
                                      : Text(LocaleKeys.no_file.tr(),
                                          style: TextStyle(
                                              color: Color(0xFFc69968),
                                              fontSize: 15.0,
                                              fontStyle: FontStyle.italic)))),
                          Align(
                            alignment: value == true
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 20.0, left: 12.0, right: 12.0),
                              child: Text(
                                LocaleKeys.optional_attachment_three.tr(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              thirdOption = true;
                              showAddAttachment();
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFFc1c1c1),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Color(0xFFc1c1c1),
                                ),
                                margin: const EdgeInsets.only(
                                    top: 5.0, left: 15.0, right: 15.0),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5.0, top: 5),
                                  child: Text(
                                    LocaleKeys.choose_file.tr(),
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.black87),
                                  ),
                                )),
                          ),
                          Align(
                            alignment: value == true
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, left: 15.0, right: 15.0),
                                child: thirdOptionFileName != null
                                    ? Text("${thirdOptionFileName}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0))
                                    : Text(LocaleKeys.no_file.tr(),
                                        style: TextStyle(
                                            color: Color(0xFFc69968),
                                            fontSize: 15.0,
                                            fontStyle: FontStyle.italic))),
                          ),

                          Align(
                            alignment: value == true
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 15.0, left: 12.0, right: 12.0),
                              child: RichText(
                                text: TextSpan(
                                    text: LocaleKeys.payment_type.tr(),
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: ' *',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16.0))
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
                                    new BorderRadius.all(Radius.circular(5.0))
                                // color: Colors.white12,
                                ),
                            alignment: FractionalOffset.center,
                            child: DropdownButtonFormField<dynamic>(
                              decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                              ),
                              value: _paymentType,
                              hint: Text(LocaleKeys.bank_transfer.tr(),
                                  style: TextStyle(
                                    color: Colors.black,
                                  )),

                              // this is the magic
                              items: _payment.map<DropdownMenuItem<dynamic>>(
                                  (dynamic value) {
                                return DropdownMenuItem<dynamic>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (dynamic value) {
                                setState(() {
                                  print("Value$value");
                                  _paymentType = value;
                                });
                              },
                              // validator: (value) =>
                              //     value == null ? 'Please Select Country' : null,
                            ),
                          ),

                          Align(
                              alignment: value == true
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0,
                                    right: 12.0,
                                    top: 2.0,
                                    bottom: 3.0),
                                child: Text(
                                  errorMessagePaymentType,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red),
                                ),
                              )),

                          _paymentType != "Cheque"
                              ? Align(
                                  alignment: value == true
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 0.0, left: 12.0, right: 12.0),
                                    child: Text(
                                      LocaleKeys.bank_account.tr(),
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          _paymentType != "Cheque"
                              ? new Container(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      top: 5.0,
                                      bottom: 5.0),
                                  margin: const EdgeInsets.only(
                                      top: 5.0,
                                      left: 15,
                                      right: 15.0,
                                      bottom: 10.0),
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      border: new Border.all(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(5.0))
                                      // color: Colors.white12,
                                      ),
                                  alignment: FractionalOffset.center,
                                  child:
                                      FutureBuilder<List<BankAccountsModel>?>(
                                    future: bankAccounts, // async work
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<BankAccountsModel>?>
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
                                            return getBankAccountDataWidget(
                                                snapshot.data);
                                      }
                                    },
                                  ),
                                )
                              : Container(),
                          _paymentType != "Cheque"
                              ? Align(
                                  alignment: value == true
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, left: 12.0, right: 12.0),
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
                                                    color: Colors.red,
                                                    fontSize: 16.0))
                                          ]),
                                    ),
                                  ),
                                )
                              : Container(),
                          _paymentType != "Cheque"
                              ? new Container(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      top: 5.0,
                                      bottom: 5.0),
                                  margin: const EdgeInsets.only(
                                      top: 5.0,
                                      left: 15,
                                      right: 15.0,
                                      bottom: 10.0),
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      border: new Border.all(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(5.0))
                                      // color: Colors.white12,
                                      ),
                                  alignment: FractionalOffset.center,
                                  child: enabledText == true
                                      ? TextFormField(
                                          enabled: false,
                                          controller: _bankController,
                                          style: TextStyle(color: Colors.grey),
                                          //                                initialValue: "user@ionicfirebaseapp.com",
                                          decoration: new InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        )
                                      : FutureBuilder<List<ParamsModel>?>(
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
                                                  return Text(
                                                      LocaleKeys.try_again);
                                                else
                                                  return getBankDataWidget(
                                                      snapshot.data);
                                            }
                                          },
                                        ))
                              : new Container(),

                          _paymentType != "Cheque"
                              ? Align(
                                  alignment: value == true
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0,
                                        right: 12.0,
                                        top: 2.0,
                                        bottom: 3.0),
                                    child: Text(
                                      errorMessageBank,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.red),
                                    ),
                                  ))
                              : Container(),
                          _paymentType != "Cheque"
                              ? Align(
                                  alignment: value == true
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 0.0, left: 12.0, right: 12.0),
                                    child: Text(
                                      LocaleKeys.bank_swift_code.tr(),
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          _paymentType != "Cheque"
                              ? new Container(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      top: 5.0,
                                      bottom: 5.0),
                                  margin: const EdgeInsets.only(
                                      top: 5.0,
                                      left: 15,
                                      right: 15.0,
                                      bottom: 10.0),
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      border: new Border.all(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(5.0))
                                      // color: Colors.white12,
                                      ),
                                  alignment: FractionalOffset.center,
                                  child: enabledText == true
                                      ? new TextFormField(
                                          enabled: false,
                                          controller: _bankSwiftCodeController,
                                          style: TextStyle(color: Colors.grey),
                                          decoration: new InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        )
                                      : TextFormField(
                                          controller: _bankSwiftCodeController,
                                          style: TextStyle(color: Colors.black),
                                          decoration: new InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                )
                              : Container(),

                          _paymentType != "Cheque"
                              ? Align(
                                  alignment: value == true
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 0.0, left: 12.0, right: 12.0),
                                    child: Text(
                                      LocaleKeys.bank_account_name.tr(),
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          _paymentType != "Cheque"
                              ? new Container(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      top: 5.0,
                                      bottom: 5.0),
                                  margin: const EdgeInsets.only(
                                      top: 5.0,
                                      left: 15,
                                      right: 15.0,
                                      bottom: 10.0),
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      border: new Border.all(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(5.0))
                                      // color: Colors.white12,
                                      ),
                                  alignment: FractionalOffset.center,
                                  child: enabledText == true
                                      ? new TextFormField(
                                          enabled: false,
                                          controller:
                                              _bankAccountNameController,
                                          style: TextStyle(color: Colors.grey),
                                          //                                initialValue: "user@ionicfirebaseapp.com",
                                          decoration: new InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        )
                                      : new TextFormField(
                                          controller:
                                              _bankAccountNameController,
                                          style: TextStyle(color: Colors.black),
                                          //                                initialValue: "user@ionicfirebaseapp.com",
                                          decoration: new InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                )
                              : Container(),
                          _paymentType != "Cheque"
                              ? Align(
                                  alignment: value == true
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0,
                                        right: 12.0,
                                        top: 2.0,
                                        bottom: 3.0),
                                    child: Text(
                                      errorMessageBankAccount,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.red),
                                    ),
                                  ))
                              : Container(),

                          _paymentType != "Cheque"
                              ? Align(
                                  alignment: value == true
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 0.0, left: 12.0, right: 12.0),
                                    child: Text(
                                      LocaleKeys.bank_account_IBAN.tr(),
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),

                          _paymentType != "Cheque"
                              ? new Container(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      top: 5.0,
                                      bottom: 5.0),
                                  margin: const EdgeInsets.only(
                                      top: 5.0,
                                      left: 15,
                                      right: 15.0,
                                      bottom: 10.0),
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      border: new Border.all(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(5.0))
                                      // color: Colors.white12,
                                      ),
                                  alignment: FractionalOffset.center,
                                  child: enabledText == true
                                      ? new TextFormField(
                                          controller:
                                              _bankAccountIbanController,
                                          enabled: false,
                                          style: TextStyle(color: Colors.grey),
                                          //                                initialValue: "user@ionicfirebaseapp.com",
                                          decoration: new InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        )
                                      : TextFormField(
                                          controller:
                                              _bankAccountIbanController,
                                          style: TextStyle(color: Colors.black),
                                          //                                initialValue: "user@ionicfirebaseapp.com",
                                          decoration: new InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                )
                              : Container(),

                          _paymentType != "Cheque"
                              ? Align(
                                  alignment: value == true
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0,
                                        right: 12.0,
                                        top: 2.0,
                                        bottom: 3.0),
                                    child: Text(
                                      errorMessageBankIban,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.red),
                                    ),
                                  ))
                              : Container(),
                          _paymentType == "Cheque"
                              ? Align(
                                  alignment: value == true
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 0.0, left: 12.0, right: 12.0),
                                    child: RichText(
                                      text: TextSpan(
                                          text: LocaleKeys.reason.tr(),
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                          children: [
                                            TextSpan(
                                                text: ' *',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 16.0))
                                          ]),
                                    ),
                                  ),
                                )
                              : Container(),

                          _paymentType == "Cheque"
                              ? new Container(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      top: 5.0,
                                      bottom: 5.0),
                                  margin: const EdgeInsets.only(
                                      top: .0,
                                      left: 15,
                                      right: 15.0,
                                      bottom: 10.0),
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      border: new Border.all(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(0.0))
                                      // color: Colors.white12,
                                      ),
                                  alignment: FractionalOffset.center,
                                  child: new TextFormField(
                                      controller: _reasonController,
                                      style: TextStyle(color: Colors.black),
                                      //                                initialValue: "user@ionicfirebaseapp.com",
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      maxLines: 2),
                                )
                              : Container(),
                          _paymentType == "Cheque"
                              ? Align(
                                  alignment: value == true
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0,
                                        right: 12.0,
                                        top: 2.0,
                                        bottom: 3.0),
                                    child: Text(
                                      errorMessageReason,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.red),
                                    ),
                                  ))
                              : Container(),
                          _paymentType != "Cheque"
                              ? Row(
                                  children: [
                                    Checkbox(
                                      value: this._checkbox,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          this._checkbox = value!;
                                        });
                                      },
                                    ),
                                    Text(
                                      LocaleKeys.default_bank_account.tr(),
                                    ),
                                  ],
                                )
                              : Container(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () async {
                                    if (_paymentType == null) {
                                      _paymentType = "Bank Transfer";
                                    }
                                    if (!isLoginProgress) {
                                      if (_paymentType != "Cheque") {
                                        if ((enabledText == false)
                                            ? (type == true)
                                                ? (_membertype != null &&
                                                    _paymentType != null &&
                                                    _claimedCost
                                                        .text.isNotEmpty &&
                                                    fileName != null &&
                                                    (_bankType != null) &&
                                                    (_submissionClaimRefController
                                                        .text.isNotEmpty) &&
                                                    _bankAccountNameController
                                                        .text.isNotEmpty &&
                                                    _bankAccountIbanController
                                                        .text.isNotEmpty)
                                                : (_membertype != null &&
                                                    _paymentType != null &&
                                                    _claimedCost
                                                        .text.isNotEmpty &&
                                                    fileName != null &&
                                                    (_bankType != null) &&
                                                    _bankAccountNameController
                                                        .text.isNotEmpty &&
                                                    _bankAccountIbanController
                                                        .text.isNotEmpty)
                                            : (type == true)
                                                ? (_membertype != null &&
                                                    _paymentType != null &&
                                                    _claimedCost
                                                        .text.isNotEmpty &&
                                                    (_submissionClaimRefController
                                                        .text.isNotEmpty) &&
                                                    fileName != null)
                                                : (_membertype != null &&
                                                    _paymentType != null &&
                                                    _claimedCost
                                                        .text.isNotEmpty &&
                                                    fileName != null)) {
                                          errorMessageMember = "";
                                          errorMessageClaimedCost = "";
                                          errorMessageClaimedAttachment = "";
                                          errorMessageBank = "";
                                          errorMessageBankAccount = "";
                                          errorMessageBankIban = "";
                                          errorMessageSubmissionClaimRef = "";
                                          _onSubmitClicked();
                                        } else {

                                          if (_submissionClaimRefController
                                              .text.isEmpty) {
                                            WidgetsBinding.instance!
                                                .addPostFrameCallback((_) {
                                              _controller.animateTo(
                                                0.0,
                                                curve: Curves.easeOut,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                              );
                                            });
                                            setState(() {
                                              errorMessageSubmissionClaimRef =
                                                  "Please Add Submit Claim Ref";
                                            });
                                          } else {
                                            setState(() {
                                              errorMessageSubmissionClaimRef =
                                                  "";
                                            });
                                          }

                                          if (_bankAccountIbanController
                                              .text.isEmpty) {
                                            setState(() {
                                              errorMessageBankIban =
                                                  "Please Add Bank Iban";
                                            });
                                          } else {
                                            setState(() {
                                              errorMessageBankIban = "";
                                            });
                                          }


                                          if (_bankAccountNameController
                                              .text.isEmpty) {
                                            setState(() {
                                              errorMessageBankAccount =
                                                  LocaleKeys
                                                      .please_add_bank_account
                                                      .tr();
                                            });
                                          } else {
                                            setState(() {
                                              errorMessageBankAccount = "";
                                            });
                                          }

                                          if (enabledText != true) {
                                            if ((_bankType == null)) {
                                              WidgetsBinding.instance!
                                                .addPostFrameCallback((_) {                                              
                                                _controller.animateTo(
                                                    _controller.position
                                                        .maxScrollExtent,
                                                    duration: Duration(
                                                        milliseconds: 200),
                                                    curve: Curves.easeInOut);
                                              });
                                              setState(() {
                                                errorMessageBank = LocaleKeys
                                                    .please_select_bank
                                                    .tr();
                                              });
                                            } else {
                                              setState(() {
                                                errorMessageBank = "";
                                              });
                                            }
                                          }


                                          if (fileName == null) {
                                            WidgetsBinding.instance!
                                                .addPostFrameCallback((_) {
                                              _controller.animateTo(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      1.5,
                                                  duration: Duration(
                                                      milliseconds: 200),
                                                  curve: Curves.easeInOut);
                                            });
                                            setState(() {
                                              errorMessageClaimedAttachment =
                                                  LocaleKeys
                                                      .please_select_attachment
                                                      .tr();
                                            });
                                          } else {
                                            setState(() {
                                              errorMessageClaimedAttachment =
                                                  "";
                                            });
                                          }


                                          if (_claimedCost.text.isEmpty) {

                                            WidgetsBinding.instance!
                                                .addPostFrameCallback((_) {
                                              _controller.animateTo(
                                                0.0,
                                                curve: Curves.easeOut,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                              );
                                            });
                                            setState(() {
                                              errorMessageClaimedCost =
                                                  LocaleKeys
                                                      .please_add_claimed_cost
                                                      .tr();
                                            });
                                          } else {
                                            setState(() {
                                              errorMessageClaimedCost = "";
                                            });
                                          }


                                          if (_membertype == null) {
                                            WidgetsBinding.instance!
                                                .addPostFrameCallback((_) {
                                              _controller.animateTo(
                                                0.0,
                                                curve: Curves.easeOut,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                              );
                                            });
                                            setState(() {
                                              errorMessageMember = LocaleKeys
                                                  .please_select_member
                                                  .tr();
                                            });
                                          } else {
                                            setState(() {
                                              errorMessageMember = "";
                                            });
                                          }
                                        }
                                      } else {
                                        if ((_membertype != null &&
                                            _paymentType != null &&
                                            _claimedCost.text.isNotEmpty &&
                                            fileName != null &&
                                            _reasonController.text.isNotEmpty &&
                                            ((type == true)
                                                ? (_submissionClaimRefController
                                                    .text.isNotEmpty)
                                                : (_membertype != null &&
                                                    _paymentType != null &&
                                                    _claimedCost
                                                        .text.isNotEmpty &&
                                                    fileName != null &&
                                                    _reasonController
                                                        .text.isNotEmpty)))) {
                                          errorMessageMember = "";
                                          errorMessageClaimedCost = "";
                                          errorMessageClaimedAttachment = "";
                                          errorMessageSubmissionClaimRef = "";
                                          errorMessageReason = "";
                                          _onSubmitClicked();
                                        } else {
                                          if (_membertype == null) {
                                            WidgetsBinding.instance!
                                                .addPostFrameCallback((_) {
                                              _controller.animateTo(
                                                0.0,
                                                curve: Curves.easeOut,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                              );
                                            });
                                            setState(() {
                                              errorMessageMember = LocaleKeys
                                                  .please_select_member
                                                  .tr();
                                            });
                                          } else {
                                            setState(() {
                                              errorMessageMember = "";
                                            });
                                          }
                                          if (_claimedCost.text.isEmpty) {
                                            WidgetsBinding.instance!
                                                .addPostFrameCallback((_) {
                                              _controller.animateTo(
                                                0.0,
                                                curve: Curves.easeOut,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                              );
                                            });
                                            setState(() {
                                              errorMessageClaimedCost =
                                                  LocaleKeys
                                                      .please_add_claimed_cost
                                                      .tr();
                                            });
                                          } else {
                                            setState(() {
                                              errorMessageClaimedCost = "";
                                            });
                                          }
                                          if (fileName == null) {
                                            WidgetsBinding.instance!
                                                .addPostFrameCallback((_) {
                                              _controller.animateTo(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      1.5,
                                                  duration: Duration(
                                                      milliseconds: 200),
                                                  curve: Curves.easeInOut);
                                            });
                                            setState(() {
                                              errorMessageClaimedAttachment =
                                                  LocaleKeys
                                                      .please_select_attachment
                                                      .tr();
                                            });
                                          } else {
                                            setState(() {
                                              errorMessageClaimedAttachment =
                                              "";
                                            });
                                          }
                                          if (_submissionClaimRefController
                                              .text.isEmpty) {
                                        if(type== true) {
                                          WidgetsBinding.instance!
                                              .addPostFrameCallback((_) {
                                            _controller.animateTo(
                                              0.0,
                                              curve: Curves.easeOut,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                            );
                                          });
                                        }
                                            setState(() {
                                              errorMessageSubmissionClaimRef =
                                                  "Please Add Submit Claim Ref";
                                            });
                                          } else {
                                            setState(() {
                                              errorMessageSubmissionClaimRef =
                                                  "";
                                            });
                                          }
                                          if (_reasonController.text.isEmpty) {
                                            setState(() {
                                              errorMessageReason = LocaleKeys
                                                  .please_add_reason
                                                  .tr();
                                            });
                                          } else {
                                            setState(() {
                                              errorMessageReason = "";
                                            });
                                          }
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
                                        top: 0.0,
                                        left: 10.0,
                                        right: 10.0,
                                        bottom: 30.0),
                                    child: Center(
                                      child: Text(
                                        LocaleKeys.submit.tr(),
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  )),
                              isLoginProgress
                                  ? Center(
                                      child: Container(
                                          width: 10,
                                          margin:
                                              const EdgeInsets.only(bottom: 30),
                                          child: Center(
                                              child:
                                                  CupertinoActivityIndicator())))
                                  : Container(
                                      width: 10,
                                    )
                            ],
                          ),
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget getMemberDataWidget(List<AlMadallaMemberModel>? alMadallaCardModel) {
    // memberKey = alMadallaCardModel?.cardNo;

    return DropdownButtonFormField<dynamic>(
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      value: _membertype,
      hint: RichText(
        text: TextSpan(
            text: LocaleKeys.select_member.tr(),
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red, fontSize: 16.0))
            ]),
      ),
      items: alMadallaCardModel!.map((AlMadallaMemberModel? paramsModel) {
        return DropdownMenuItem<AlMadallaMemberModel?>(
          value: paramsModel,
          child: Text(
            paramsModel != null
                ? paramsModel.nameEnglish ?? 'No data'
                : 'No data',
          ),
        );
      }).toList(),
      // items: _member.map<DropdownMenuItem<dynamic>>((dynamic value) {
      //   return DropdownMenuItem<dynamic>(
      //     value: value,
      //     child: Text(
      //       alMadallaCardModel != null
      //           ? alMadallaCardModel.nameEnglish ?? 'No data'
      //           : 'No data',
      //     ),
      //   );
      // }).toList(),
      onChanged: (dynamic value) {
        setState(() {
          print("Value$value");
          // number=_membertype!.cardNo!;

          _membertype = value;
          errorMessageMember = "";
          memberData = true;
        });
      },
    );
  }

  Widget getCurrencyDataWidget(List<ParamsModel>? param) {
    return DropdownButtonFormField<dynamic>(
      isExpanded: true,
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      value: _currencyType,
      hint: Text(LocaleKeys.UAE_DHIRHAM.tr(),
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
        setState(() {
          print("Value$value");
          _currencyType = value;
          if (_currencyType!.name! == "UAE DHIRHAM") {
            type = true;
          }
          print("Selected city is ----> $_currencyType");
        });
      },
    );
  }

  Widget getBankDataWidget(List<ParamsModel>? param) {
    return DropdownButtonFormField<dynamic>(
      isExpanded: true,
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      value: _bankType,
      hint: Text(LocaleKeys.select.tr(),
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
          errorMessageBank = "";
          _bankSwiftCodeController.text = _bankType!.swiftCode!;
          print("Selected city is ----> $_bankType");
        });
      },
    );
  }

  Widget getBankAccountDataWidget(List<BankAccountsModel>? param) {
    //print("vvvv${param!.length}");

    List<BankAccountsModel>? temList = [];

    if (param!.isNotEmpty) {
      if (param[0].accountName != "Add New") {
        print("Not Equal--->");
        param.insert(0,
            BankAccountsModel(null, null, null, null, "Add New", null, true));
      }
    } else {
      param.insert(
          0, BankAccountsModel(null, null, null, null, "Add New", null, true));
    }
    if (param.isNotEmpty) {
      for (int i = 0; i < param.length; i++) {
        if (param[i].status == true) {
          temList.add(param[i]);
        }
      }
    }
    param = temList;
    return DropdownButtonFormField<dynamic>(
      isExpanded: true,
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
      ),
      value: _bankAccountType,
      hint: Text("Add New",
          style: TextStyle(
            color: Colors.black,
          )),
      items: param.map((BankAccountsModel? paramsModel) {
        return DropdownMenuItem<BankAccountsModel?>(
          value: paramsModel,
          child: Text(
            paramsModel != null && paramsModel.status == true
                ? paramsModel.accountName ?? ''
                : '',
            // paramsModel!.accountName ?? ''
          ),
        );
      }).toList(),
      onChanged: (dynamic value) {
        setState(() {
          print("Value$value");

          _bankAccountType = value;

          if (_bankAccountType!.accountName != "Add New" ||
              _bankAccountType!.accountName == null) {
            enabledText = true;

            _bankSwiftCodeController.text = _bankAccountType!.swiftCode!;
            _bankAccountNameController.text = _bankAccountType!.accountName!;
            _bankAccountIbanController.text = _bankAccountType!.iban!;
            _bankController.text = _bankAccountType!.bank!;

            setState(() {

              errorMessageBank = "";
              errorMessageBankIban = "";
              errorMessageBankAccount = "";
              
            });

            print("Selected city is ----> $_bankAccountType");
          } else {
            enabledText = false;
            _bankSwiftCodeController.text = "";
            _bankAccountNameController.text = "";
            _bankAccountIbanController.text = "";
          }
          //   print("Selected swiftCode is ----> $swiftCode");
        });
      },
    );
  }
}
