import 'package:almadalla/models/UserProfile.dart';
import 'package:flutter/foundation.dart';

import 'LoginData.dart';

class UserSettingsBloc with ChangeNotifier {
  LoginData? _loginData;
  UserProfile? _userProfile ;

  setLoginData(LoginData? loginData) {
    this._loginData = loginData;
    notifyListeners();
  }
  setUserProfile(UserProfile? userProfile) {
    this._userProfile = userProfile;
    notifyListeners();
  }

  LoginData? getLoginData(){
    return this._loginData;
  }
  UserProfile? getUserProfile(){
    return this._userProfile;
  }
}
