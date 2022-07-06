import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:io' as io;
import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/models/DownloadFileModel.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadsScreen extends StatefulWidget {
  DownloadsScreen({Key? key, required this.title, required this.loginData})
      : super(key: key);

  final String title;
  final LoginData? loginData;
  @override
  _DownloadsScreenState createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
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
  Future<List<DownloadFileModel>?>? downloadFileList;
  File? filePath;
  void _showDownloadButton(String? key, String? name) async {
    int? keyValue = int.parse(key!);
    String? newName = name;
    DownloadFileModel? downloadFile;
    downloadFile = new DownloadFileModel();
    downloadFile.fileKey = keyValue;

    String? response = await RestDatasource()
        .getDownloadedFile(widget.loginData, downloadFile);
    print(".............Response..........$response");
    if (response != null ) {
      setState(() {
        isSearchProgress = false;
      });
      try {
        await _createFileFromString(response, newName);
        SnackBar errorMessage = SnackBar(
            content: new Text(Platform.isIOS
                ? LocaleKeys.file_download.tr()
                : LocaleKeys.file_download_complete.tr()),
          action: SnackBarAction(
          label: 'Open File',
          onPressed: () async {
            //var fileNewPath =  filePath!.toString();
            //FilePickerResult? result = await FilePicker.platform.pickFiles();
            //fileNewPath = result!.files.single.path!;
           // print("fileNewPath$fileNewPath");
           //  if (result != null) {
           //
           //  } else {
           //    // User canceled the picker
           //  }
            final _result = await OpenFile.open(filePath!.path);
            print(_result.message);
          },
        ),

    );
        ScaffoldMessenger.of(context).showSnackBar(errorMessage);
      } on Exception catch (err) {
        print("throwing new error");
        SnackBar submitClaimErrorMessage = SnackBar(
            content: new Text(
          "Failed to save file. Error: ${err.toString()}",
        ));
        ScaffoldMessenger.of(context).showSnackBar(submitClaimErrorMessage);
      } catch (err) {
        SnackBar submitClaimErrorMessage = SnackBar(
            content: new Text(
          "Failed to save file. Error: ${err.toString()}",
        ));
        ScaffoldMessenger.of(context).showSnackBar(submitClaimErrorMessage);
      }
    } else {
      setState(() {
        isSearchProgress = false;
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

        SnackBar downloadErrorMessage =
            SnackBar(content: new Text(finalString!));
        ScaffoldMessenger.of(context).showSnackBar(downloadErrorMessage);
      } else {
        String errorMessage = response.tr();
        print("msg$msg");
        SnackBar downloadScreenErrorMessage =
            SnackBar(content: new Text(errorMessage));
        ScaffoldMessenger.of(context).showSnackBar(downloadScreenErrorMessage);
      }
    }
  }

  Future _createFileFromString(String? resp, String? _fileName) async {
    final encodedStr = resp;
    Uint8List bytes = base64.decode(encodedStr!);
    //Directory? tempDir = await DownloadsPathProvider.downloadsDirectory;
    Directory? tempDir = Platform.isIOS
        ? await getApplicationDocumentsDirectory()
        : await DownloadsPathProvider.downloadsDirectory;
    String tempPath = tempDir!.path;
    filePath = File(tempPath + '/' + '$_fileName');

    try {
      if (!Platform.isIOS) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
      }

      await filePath!.writeAsBytes(bytes);
      print("----------filepath-----------${filePath!.path}");
    } on FileSystemException catch (err) {
      throw Exception(err.message);
    } on Exception catch (err) {
      throw Exception(err.toString());
    } catch (err) {
      throw Exception(err.toString());
    }
    return filePath!.path;
  }

  void initState() {
    downloadFileList = RestDatasource().getDownloadFileList(widget.loginData);
    super.initState();
  }

  _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
      isSearchProgress = true;
    });
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
                    LocaleKeys.downloads.tr(),
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
                      child: FutureBuilder<List<DownloadFileModel>?>(
                        future: downloadFileList, // async work
                        builder: (BuildContext context,
                            AsyncSnapshot<List<DownloadFileModel>?> snapshot) {
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
                                return getDownloadFileWidget(snapshot.data);
                          }
                        },
                      ),
                    )),
              ]))),
    );
  }

  Widget getDownloadFileWidget(List<DownloadFileModel>? downloadFileModel) {
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
                          leading: Text(LocaleKeys.select_download.tr(),
                              style: TextStyle(fontSize: 15.0)),
                        )),
                    Container(
                      child: Column(children: [
                        ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: downloadFileModel!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                  child: Container(
                                child: Column(
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Row(children: <Widget>[
                                          Expanded(
                                              flex: 9,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                ),
                                                child: Text(
                                                    downloadFileModel != null
                                                        ? downloadFileModel[
                                                                    index]
                                                                .fileName ??
                                                            'No data'
                                                        : 'No data',
                                                    style: TextStyle(
                                                        fontSize: 15.0)),
                                              )),
                                          Expanded(
                                              flex: 6,
                                              child: InkWell(
                                                onTap: () {
                                                  String? fileKey =
                                                      downloadFileModel[index]
                                                          .fileKey
                                                          .toString();
                                                  String? fileName =
                                                      downloadFileModel[index]
                                                          .fileName;
                                                  print("fileKey$fileKey");
                                                  _onSelected(index);
                                                  _showDownloadButton(
                                                      fileKey, fileName);
                                                },
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 0),
                                                    child: Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              child: Container(
                                                                width: 90,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Color(
                                                                        0xFFb7956c),
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10)),
                                                                  color: Color(
                                                                      0xFFb7956c),
                                                                ),
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            0.0,
                                                                        left:
                                                                            5.0,
                                                                        right:
                                                                            5.0),
                                                                child: Center(
                                                                    child: Text(
                                                                  LocaleKeys
                                                                      .download
                                                                      .tr(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12),
                                                                )),
                                                              )),
                                                          _selectedIndex ==
                                                                      index &&
                                                                  isSearchProgress
                                                              ? Center(
                                                                  child: Container(
                                                                      width: 10,
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              8,
                                                                          right:
                                                                              8),
                                                                      child: Center(
                                                                          child:
                                                                              CupertinoActivityIndicator())))
                                                              : Container(
                                                                  width: 10,
                                                                )
                                                        ],
                                                      ),
                                                    )),
                                              )),
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
