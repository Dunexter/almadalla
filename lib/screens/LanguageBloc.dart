import 'package:flutter/material.dart';


class LanguageBloc with ChangeNotifier {
  int? _language;

  void setLanguage(int lang){
    _language = lang;
    notifyListeners();
  }
  int? getLanguage(){
    return _language;
  }





}