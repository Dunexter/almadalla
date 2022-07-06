import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:almadalla/models/AlMadallaMemberModel.dart';
import 'package:almadalla/models/BankAccountsModel.dart';
import 'package:almadalla/models/ClaimsModel.dart';
import 'package:almadalla/models/ContactReasonsModel.dart';
import 'package:almadalla/models/DownloadFileModel.dart';
import 'package:almadalla/models/LoginData.dart';
import 'package:almadalla/models/MemberUtilizationModel.dart';
import 'package:almadalla/models/NetworkProviderModel.dart';
import 'package:almadalla/models/ParamsModel.dart';
import 'package:almadalla/models/ProviderSearchParams.dart';
import 'package:almadalla/models/PushNotificationsDetailsModel.dart';
import 'package:almadalla/models/PushNotificationsRegistrationModel.dart';
import 'package:almadalla/models/SearchClaimsParams.dart';
import 'package:almadalla/models/SendMessageParams.dart';
import 'package:almadalla/models/SubmitClaimParams.dart';
import 'package:almadalla/models/UserProfile.dart';
import 'package:almadalla/models/BankSaveUpdateParamsModel.dart';
import 'package:almadalla/models/UserRequestModel.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'CustomException.dart';
import 'Session.dart';
import '../models/Constants.dart';
//import 'package:almadalla/screens/CustomException.dart';
class RestDatasource {
  Session networkSession = new Session();

  // 1. login

  Future<LoginData?> login(String userName, String userPassword) async {
    LoginData? loginData;
    try {
      print('login Request => ${Constants.LoginUrl}');
      http.Response response = await networkSession.post(
          url: Constants.LoginUrl,
          body: {
            "username": userName, //Constants.Username,
            "password": userPassword, //Constants.Password,
          },
          authorization: "");
      print('login Response => ${response.body}');
      print('login Response => ${response.statusCode}');
      Map<String, dynamic> responseResult = json.decode(response.body);
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }  if(response.statusCode == 200||response.statusCode == 400){
      if (response.body.trim() != "") {
        loginData = new LoginData.fromJson(responseResult);
      } }else {
        // There is no data
        print("No data available...");
      }
    } catch (e) {
      print('WTF - login \n');
      print(e.toString());
    }
    return loginData;
  }

  // 2. Forgot Username

  Future<String?> forgotUsername(
      String registeredEmail, String emiratesIDNo) async {
    String? responseString;
    try {
      print('forgotUsername => ${Constants.ForgotUsernameUrl}');
      http.Response response = await networkSession.post(
          url: Constants.ForgotUsernameUrl,
          body: {
            "registeredEmail": registeredEmail,
            "emiratesIDNo": emiratesIDNo,
          },
          authorization: "");
      print('forgotUsername Response => Result: ${response.statusCode}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }
      if (response.statusCode == 200) {
        // Username will be sent to registered email ID.
        responseString = "success";
      } else {
        if (response.body.trim() != "") {
          Map<String, dynamic> responseResult = json.decode(response.body);
          responseString = responseResult['Message'];
        } else {
          responseString = response.statusCode.toString();
        }
      }
    } catch (e) {
      print('WTF - forgotUsername \n');
      print(e.toString());
    }
    return responseString;
  }

  // 3. Forgot Password

  Future<String?> forgotPassword(
      String registeredEmail, String userName) async {
    String? responseString;
    try {
      print('forgotPassword => ${Constants.ForgotPasswordUrl}');
      http.Response response = await networkSession.post(
          url: Constants.ForgotPasswordUrl,
          body: {
            "registeredEmail": registeredEmail,
            "userName": userName,
          },
          authorization: "");
      print('forgotPassword Response => Result: ${response.statusCode}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }
     if (response.statusCode == 200) {
        // Password will be sent to registered email ID.
        responseString = "success";
      } else {
        if (response.body.trim() != "") {
          Map<String, dynamic> responseResult = json.decode(response.body);
          responseString = responseResult['Message'];
        } else {
          responseString = response.statusCode.toString();
        }
      }
    } catch (e) {
      print('WTF - forgotPassword \n');
      print(e.toString());
    }
    return responseString;
  }

  // 4. Update Password

  Future<String?> updatePassword( LoginData? loginData,String newPassword) async {
    String? responseString;
    try {
      print('updatePassword => ${Constants.UpdatePasswordUrl}');
      http.Response response = await networkSession.post(
          url: Constants.UpdatePasswordUrl,
          body: {"password": newPassword},
          authorization:loginData!.authorization.toString());
      print('updatePassword Response => Result: ${response.statusCode}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }
      if (response.statusCode == 200) {
        responseString = "success";
      } else {
        if (response.body.trim() != "") {
          Map<String, dynamic> responseResult = json.decode(response.body);
          responseString = responseResult['Message'];
        } else {
          responseString = response.statusCode.toString();
        }
      }
    } catch (e) {
      print('WTF - updatePassword \n');
      print(e.toString());
    }
    return responseString;
  }

  // 5 . Register

  Future<String?> register(UserProfile userprofile) async {
    String? responseString;
    try {
      print('register => ${Constants.RegisterUrl}');
      http.Response response = await networkSession.post(
          url: Constants.RegisterUrl,
          body: {
            "userName": userprofile.name,
            "memberDOB": userprofile.dob,
            "memberMobile": userprofile.mobile.toString(),
            "emailID": userprofile.emailID,
            "memberEmiratesIDNo": userprofile.emiratesIDNo,
          },
          authorization: "");
      print('register Response => Result: ${response.statusCode}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }
      if (response.statusCode == 200) {
        responseString = "success";
      } else {
        if (response.body.trim() != "") {
          Map<String, dynamic> responseResult = json.decode(response.body);
          responseString = responseResult['Message'];
        } else {
          responseString = response.statusCode.toString();
        }
      }
    } catch (e) {
      print('WTF - register \n');
      print(e.toString());
    }
    return responseString;
  }

  // 6. Get user's userprofile ************************//
  Future<UserProfile?> getUserProfile(LoginData loginData) async {
    UserProfile? userProfile;
    try {
      print('getUserProfile Request => ${Constants.GetProfileUrl}');
      http.Response response = await networkSession.post(
          url: Constants.GetProfileUrl,
          body: {},
          authorization: loginData.authorization.toString());
      print('getUserProfile Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }  if(response.statusCode == 200){
      if (response.body.trim() != "") {
        Map<String, dynamic> responseResult = json.decode(response.body);
        userProfile = UserProfile.fromJson(responseResult);

        // Get gender data
        AlMadallaMemberModel? alMadallaMemberModel =
            await getAlMadallaMemberDetails(loginData);
        if (alMadallaMemberModel != null) {
          userProfile.gender = alMadallaMemberModel.gender;
          userProfile.payer=alMadallaMemberModel.payer;
          userProfile.network=alMadallaMemberModel.network;
          userProfile.payerKey=alMadallaMemberModel.payerKey ;
          userProfile.networkKey=alMadallaMemberModel.networkKey;
        }
      }} else {
        // There is no data
        print("No data available...");
      }
    } catch (e) {
      print('WTF - getUserProfile \n');
      print(e.toString());
    }
    return userProfile;
  }

  // 7. Update User Profile

  Future<String?> updateUserProfile(
      LoginData? loginData, UserProfile profile) async {
    String? responseString;
    try {
      print('updateUserProfile => ${Constants.UpdateProfileUrl}');
      http.Response response = await networkSession.post(
          url: Constants.UpdateProfileUrl,
          body: {
            "name": profile.name,
            "mobile": profile.mobile.toString(),
            "emailID": profile.emailID
          },
          authorization: loginData!.authorization.toString());
      print('updateUserProfile Response => Result: ${response.statusCode}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }
      if (response.statusCode == 200) {
        responseString = "success";
      } else {
        if (response.body.trim() != "") {
          Map<String, dynamic> responseResult = json.decode(response.body);
          responseString = responseResult['Message'];
        } else {
          responseString = response.statusCode.toString();
        }
      }
    } catch (e) {
      print('WTF - updateUserProfile \n');
      print(e.toString());
    }
    return responseString;
  }

  // 8. Get member details ************************//
  Future<AlMadallaMemberModel?> getAlMadallaMemberDetails(
      LoginData? loginData) async {
    AlMadallaMemberModel? alMadallaMemberModel;
    try {
      print(
          'getAlMadallaMemberDetails Request => ${Constants.MemberDetailsUrl}');
      http.Response response = await networkSession.post(
          url: Constants.MemberDetailsUrl,
          body: {},
          authorization: loginData!.authorization.toString());
      print('getAlMadallaMemberDetails Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }if(response.statusCode == 200){
      if (response.body.trim() != "") {
        //Map<String, dynamic> responseResult = json.decode(response.body)[0];
        //alMadallaMemberModel = AlMadallaMemberModel.fromJson(responseResult);

        List<dynamic> responseResultList = json.decode(response.body);
        if (responseResultList.length > 0) {
          if (responseResultList.length > 1) {
            for (Map<String, dynamic> responseResult in responseResultList) {
              if (responseResult['parentmemberkey'] == null) {
                alMadallaMemberModel =
                    AlMadallaMemberModel.fromJson(responseResult);
              }
            }
          } else {
            Map<String, dynamic> responseResult = responseResultList[0];
            alMadallaMemberModel =
                AlMadallaMemberModel.fromJson(responseResult);
          }
        }
      } }else {
        // There is no data
        print("No data available...");
      }
    } catch (e) {
      print('WTF - getAlMadallaMemberDetails \n');
      print(e.toString());
    }
    return alMadallaMemberModel;
  }

  // 9. Get member utilizations ************************//
  Future<List<MemberUtilizationModel>?> getMemberUtilizations(
      LoginData? loginData, AlMadallaMemberModel? alMadallaMemberModel) async {
    MemberUtilizationModel? memberUtilizationModel;
    List<MemberUtilizationModel> memberUtilizationList = [];
    try {
      print(
          'getMemberUtilizations memberKey => ${alMadallaMemberModel!.memberKey.toString()}');
      print(
          'getMemberUtilizations Request => ${Constants.MemberUtilizationsUrl}');
      http.Response response = await networkSession.post(
          url: Constants.MemberUtilizationsUrl,
          body: {
            "languageKey": '1',
            "memberKey": alMadallaMemberModel.memberKey.toString(),
          },
          authorization: loginData!.authorization.toString());
      print('getMemberUtilizations Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      } if(response.statusCode == 200){
      if (response.body.trim() != "") {
        // Map<String, dynamic> responseResult = json.decode(response.body)[0];
        // memberUtilizationModel =
        //     MemberUtilizationModel.fromJson(responseResult);
        List<dynamic> responseResultList = json.decode(response.body);
        if (responseResultList.length > 0) {
          for (Map<String, dynamic> responseResult in responseResultList) {
            memberUtilizationModel = MemberUtilizationModel.fromJson(responseResult);
            memberUtilizationList.add(memberUtilizationModel);
          }
        }
      }}else {
        // There is no data
        print("No data available...");
      }
    } catch (e) {
      print('WTF - getMemberUtilizations \n');
      print(e.toString());
    }
    return memberUtilizationList;
  }

  // 10. Provider Seach ************************ START //

  //Payer
  Future<List<ParamsModel>?> getProviderPayers(LoginData? loginData) async {
    List<ParamsModel> providerPayers = [];
    ParamsModel? paramsModel;
    try {
      print('getProviderPayers Request => ${Constants.PayersUrl}');
      http.Response response = await networkSession.post(
          url: Constants.PayersUrl, body: {}, authorization: "");
      print('getProviderPayers Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }
      if(response.statusCode == 200){
      if (response.body.trim() != "") {
        List<dynamic> responseResultList = json.decode(response.body);
        if (responseResultList.length > 0) {
          for (Map<String, dynamic> responseResult in responseResultList) {
            paramsModel = ParamsModel.fromJson(responseResult);
            providerPayers.add(paramsModel);
          }
        }
      }}else {
        // There is no data
        print("No data available...");
      }
    } catch (e) {
      print('WTF - getProviderPayers \n');
      print(e.toString());
    }
    return providerPayers;
  }

  //Network
  Future<List<ParamsModel>?> getProviderNetworks(LoginData? loginData) async {
    List<ParamsModel> providerNetworks = [];
    ParamsModel? paramsModel;
    try {
      print('getProviderNetworks Request => ${Constants.NetworksUrl}');
      http.Response response = await networkSession.post(
          url: Constants.NetworksUrl, body: {}, authorization: "");
      print('getProviderNetworks Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }
      if(response.statusCode == 200)
        {
      if (response.body.trim() != "") {
        List<dynamic> responseResultList = json.decode(response.body);
        if (responseResultList.length > 0) {
          for (Map<String, dynamic> responseResult in responseResultList) {
            paramsModel = ParamsModel.fromJson(responseResult);
            providerNetworks.add(paramsModel);
          }
        }
      } }else {
        // There is no data
        print("No data available...");
      }
    } catch (e) {
      print('WTF - getProviderNetworks \n');
      print(e.toString());
    }
    return providerNetworks;
  }

  //Provider Type
  Future<List<ParamsModel>?> getProviderTypes(LoginData? loginData) async {
    List<ParamsModel> providerTypes = [];
    ParamsModel? paramsModel;
    try {
      print('getProviderTypes Request => ${Constants.ProviderTypesUrl}');
      http.Response response = await networkSession.post(
          url: Constants.ProviderTypesUrl, body: {}, authorization: "");
      print('getProviderTypes Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }
   if(response.statusCode == 200){
      if (response.body.trim() != "") {
        List<dynamic> responseResultList = json.decode(response.body);
        if (responseResultList.length > 0) {
          for (Map<String, dynamic> responseResult in responseResultList) {
            paramsModel = ParamsModel.fromJson(responseResult);
            providerTypes.add(paramsModel);
          }
        }
      }} else {
        // There is no data
        print("No data available...");
      }
    } catch (e) {
      print('WTF - getProviderTypes \n');
      print(e.toString());
    }
    return providerTypes;
  }

  //Speciality
  Future<List<ParamsModel>?> getProviderSpecialities(
      LoginData? loginData) async {
    List<ParamsModel> providerSpecialities = [];
    ParamsModel? paramsModel;
    try {
      print(
          'getProviderSpecialities Request => ${Constants.ProviderSpecialitiesUrl}');
      http.Response response = await networkSession.post(
          url: Constants.ProviderSpecialitiesUrl, body: {}, authorization: "");
      print('getProviderSpecialities Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }
      if(response.statusCode == 200){
      if (response.body.trim() != "") {
        List<dynamic> responseResultList = json.decode(response.body);
        if (responseResultList.length > 0) {
          for (Map<String, dynamic> responseResult in responseResultList) {
            paramsModel = ParamsModel.fromJson(responseResult);
            providerSpecialities.add(paramsModel);
          }
        }
      } }else {
        // There is no data
        print("No data available...");
      }
    } catch (e) {
      print('WTF - getProviderSpecialities \n');
      print(e.toString());
    }
    return providerSpecialities;
  }

  //City
  Future<List<ParamsModel>?> getProviderCities(LoginData? loginData) async {
    List<ParamsModel> providerCities = [];
    ParamsModel? paramsModel;
    try {
      print('getProviderCities Request => ${Constants.CitiesUrl}');
      http.Response response = await networkSession.post(
          url: Constants.CitiesUrl, body: {}, authorization: "");
      print('getProviderCities Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }
       if(response.statusCode == 200){
      if (response.body.trim() != "") {
        List<dynamic> responseResultList = json.decode(response.body);
        if (responseResultList.length > 0) {
          for (Map<String, dynamic> responseResult in responseResultList) {
            paramsModel = ParamsModel.fromJson(responseResult);
            providerCities.add(paramsModel);
          }
        }
      }} else {
        // There is no data
        print("No data available...");
      }
    } catch (e) {
      print('WTF - getProviderCities \n');
      print(e.toString());
    }
    return providerCities;
  }

  //Location
  Future<List<ParamsModel>?> getProviderLocations(LoginData? loginData, String cityKey) async {
    List<ParamsModel> providerLocations = [];
    ParamsModel? paramsModel;
    try {
      print(
          'getProviderLocations Request => ${Constants.ProviderLocationsUrl}');
      http.Response response = await networkSession.post(
          url: Constants.ProviderLocationsUrl, body: {
            "languageKey": '1',
            "cityKey": cityKey,
          }, authorization: "");
      print('getProviderLocations Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }
       if(response.statusCode == 200){
      if (response.body.trim() != "") {
        List<dynamic> responseResultList = json.decode(response.body);
        if (responseResultList.length > 0) {
          for (Map<String, dynamic> responseResult in responseResultList) {
            paramsModel = ParamsModel.fromJson(responseResult);
            providerLocations.add(paramsModel);
          }
        }
      } }else {
        // There is no data
        print("No data available...");
      }
    } catch (e) {
      print('WTF - getProviderLocations \n');
      print(e.toString());
    }
    return providerLocations;
  }

  // 11. Provider Search
  Future<List<NetworkProviderModel>?> searchNetworkProviders(
      LoginData? loginData, ProviderSearchParams providerSearchParams) async {
    List<NetworkProviderModel> networkProviders = [];
    NetworkProviderModel? networkProviderModel;
    try {
      print('searchNetworkProviders Request => ${Constants.ProviderSearchUrl}');
      http.Response response = await networkSession.post(
          url: Constants.ProviderSearchUrl,
          body: {
            "payerKey": providerSearchParams.payerKey.toString(),
            "networkKey": providerSearchParams.networkKey.toString(),
            "providerTypeKey": providerSearchParams.providerTypeKey != -1
                ? providerSearchParams.providerTypeKey.toString()
                : "",
            "specialtyKey": providerSearchParams.specialtyKey != -1
                ? providerSearchParams.specialtyKey.toString()
                : "",
            "cityKey": providerSearchParams.cityKey != -1
                ? providerSearchParams.cityKey.toString()
                : "",
            "locationKey": providerSearchParams.locationKey != -1
                ? providerSearchParams.locationKey.toString()
                : "",
          },
          authorization: "");
      print('searchNetworkProviders Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }
      if(response.statusCode == 200){
      if (response.body.trim() != "") {
        List<dynamic> responseResultList = json.decode(response.body);
        if (responseResultList.length > 0) {
          for (Map<String, dynamic> responseResult in responseResultList) {
            networkProviderModel =
                NetworkProviderModel.fromJson(responseResult);
            networkProviders.add(networkProviderModel);
          }
        }
      } }else {
        // There is no data
        print("No data available...");
      }
    } catch (e) {
      print('WTF - searchNetworkProviders \n');
      print(e.toString());
    }
    return networkProviders;
  }

  // Provider Seach ************************ END //

  // CLaims ************************ START //

  // 12. Track Claims
  Future<List<ClaimsModel>?> trackClaims(
      LoginData? loginData, SearchClaimsParams searchClaimsParams) async {
    List<ClaimsModel> claims = [];
    ClaimsModel? claimsModel;
    try {
      print('trackClaims Request => ${Constants.TrackClaimsUrl}');
      http.Response response = await networkSession.post(
          url: Constants.TrackClaimsUrl,
          body: {
            "memberKey": searchClaimsParams.memberKey.toString(),
            "fromDate": searchClaimsParams.fromDate,
            "toDate": searchClaimsParams.toDate,
            "claimType": searchClaimsParams.claimType,
            "claimRef": searchClaimsParams.claimRef,
            "claimAction": searchClaimsParams.claimAction,
            "showDependantClaims":
                1.toString(), //searchClaimsParams.showDependantClaims,
            "status": searchClaimsParams.status,
          },
          authorization: loginData!.authorization.toString());
      print('trackClaims Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }
     if(response.statusCode == 200){
      if (response.body.trim() != "") {
        List<dynamic> responseResultList = json.decode(response.body);
        if (responseResultList.length > 0) {
          for (Map<String, dynamic> responseResult in responseResultList) {
            claimsModel = ClaimsModel.fromJson(responseResult);
            claims.add(claimsModel);
          }
        }
      }} else {
        // There is no data
        print("No data available...");
      }
    } catch (e) {
      print('WTF - trackClaims \n');
      print(e.toString());
    }
    return claims;
  }

  //Submit Claim

  //Get Currencies
  Future<List<ParamsModel>?> getCurrencies(LoginData? loginData) async {
    List<ParamsModel> currencies = [];
    ParamsModel? paramsModel;
    try {
      print('getCurrencies Request => ${Constants.CurrenciesUrl}');
      http.Response response = await networkSession.post(
          url: Constants.CurrenciesUrl,
          body: {},
          authorization: loginData!.authorization.toString());
      print('getCurrencies Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }
      if(response.statusCode == 200){
      if (response.body.trim() != "") {
        List<dynamic> responseResultList = json.decode(response.body);
        if (responseResultList.length > 0) {
          for (Map<String, dynamic> responseResult in responseResultList) {
            paramsModel = ParamsModel.fromJson(responseResult);
            currencies.add(paramsModel);
          }
        }
      }} else {
        // There is no data
        print("No data available...");
      }
    } catch (e) {
      print('WTF - getCurrencies \n');
      print(e.toString());
    }
    return currencies;
  }

  //Get Banks
  Future<List<ParamsModel>?> getBanks(LoginData? loginData) async {
    List<ParamsModel> banks = [];
    ParamsModel? paramsModel;
    try {
      print('getBanks Request => ${Constants.BanksUrl}');
      http.Response response = await networkSession.post(
          url: Constants.BanksUrl,
          body: {},
          authorization: loginData!.authorization.toString());
      print('getBanks Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }
    if(response.statusCode == 200){
      if (response.body.trim() != "") {
        List<dynamic> responseResultList = json.decode(response.body);
        if (responseResultList.length > 0) {
          for (Map<String, dynamic> responseResult in responseResultList) {
            paramsModel = ParamsModel.fromJson(responseResult);
            banks.add(paramsModel);
          }
        }
      } }else {
        // There is no data
        print("No data available...");
      }
    } catch (e) {
      print('WTF - getBanks \n');
      print(e.toString());
    }
    return banks;
  }

  //Get Bank Accounts
  Future<List<BankAccountsModel>?> getBankAccounts(LoginData? loginData) async {
    List<BankAccountsModel> bankAccounts = [];
    BankAccountsModel? bankAccountsModel;
    try {
      print('getBankAccounts Request => ${Constants.BankAccountsUrl}');
      http.Response response = await networkSession.post(
          url: Constants.BankAccountsUrl,
          body: {},
          authorization: loginData!.authorization.toString());
      print('getBankAccounts Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }
      if(response.statusCode == 200){
      if (response.body.trim() != "") {
        List<dynamic> responseResultList = json.decode(response.body);
        if (responseResultList.length > 0) {
          for (Map<String, dynamic> responseResult in responseResultList) {
            bankAccountsModel = BankAccountsModel.fromJson(responseResult);
            bankAccounts.add(bankAccountsModel);
          }
        }
      }} else {
        // There is no data
        print("No data available...");
      }
    } catch (e) {
      print('WTF - getBankAccounts \n');
      print(e.toString());
    }
    return bankAccounts;
  }

  // 13. Track Claims

  Future<String> submitClaim(
      LoginData? loginData, SubmitClaimParams submitClaimParams) async {
    String responseString = "";
    try {
      print('submitClaim URL => ${Constants.SubmitClaimsUrl}');
      print('submitClaimParams.cardNo => ${submitClaimParams.cardNo}');
      print(
          'submitClaimParams.serviceDate => ${submitClaimParams.serviceDate}');
      print(
          'submitClaimParams.claimedCost => ${submitClaimParams.claimedCost}');
      print(
          'submitClaimParams.claimAttachmentOriginalFileName => ${submitClaimParams.claimAttachmentOriginalFileName}');
      print(
          'submitClaimParams.memberBankAccountName => ${submitClaimParams.memberBankAccountName}');
      print(
          'submitClaimParams.memberBankSwiftCode => ${submitClaimParams.memberBankSwiftCode}');
      print(
          'submitClaimParams.memberBankIBAN => ${submitClaimParams.memberBankIBAN}');

      var submitClaimRequest = new http.MultipartRequest(
          "POST", Uri.parse(Constants.SubmitClaimsUrl));

      Map<String, String> headers = {
        "Authorization": loginData!.authorization.toString()
      };
      submitClaimRequest.headers.addAll(headers);

      submitClaimRequest.fields['cardNo'] = submitClaimParams.cardNo.toString();
      submitClaimRequest.fields["serviceDate"] =
          submitClaimParams.serviceDate != null
              ? submitClaimParams.serviceDate.toString()
              : "";
      submitClaimRequest.fields["claimedCost"] =
          submitClaimParams.claimedCost != null
              ? submitClaimParams.claimedCost.toString()
              : "";
      submitClaimRequest.fields["currencyCode"] =
          (submitClaimParams.currencyCode != null && submitClaimParams.currencyCode!.trim() != "")
              ? submitClaimParams.currencyCode.toString()
              : "uae dhirham";
      submitClaimRequest.fields["claimAttachmentOriginalFileName"] =
          submitClaimParams.claimAttachmentOriginalFileName != null
              ? submitClaimParams.claimAttachmentOriginalFileName.toString()
              : "";

      submitClaimRequest.fields["optionalAttachment1OriginalFileName"] =
          submitClaimParams.optionalAttachment1OriginalFileName != null
              ? submitClaimParams.optionalAttachment1OriginalFileName.toString()
              : "";
      submitClaimRequest.fields["optionalAttachment2OriginalFileName"] =
          submitClaimParams.optionalAttachment2OriginalFileName != null
              ? submitClaimParams.optionalAttachment2OriginalFileName.toString()
              : "";
      submitClaimRequest.fields["optionalAttachment3OriginalFileName"] =
          submitClaimParams.optionalAttachment3OriginalFileName != null
              ? submitClaimParams.optionalAttachment3OriginalFileName.toString()
              : "";

      submitClaimRequest.fields["submissionClaimRef"] =
          submitClaimParams.submissionClaimRef != null
              ? submitClaimParams.submissionClaimRef.toString()
              : "";
      /*submitClaimRequest.fields["isResubmission"] =
          submitClaimParams.isResubmission != null
              ? submitClaimParams.isResubmission.toString()
              : "";*/
      submitClaimRequest.fields["isResubmission"] =
          (submitClaimParams.submissionClaimRef != null &&
                  submitClaimParams.submissionClaimRef!.trim() != "")
              ? "1"
              : "0";

      submitClaimRequest.fields["paymentType"] =
          submitClaimParams.paymentType != null
              ? submitClaimParams.paymentType.toString()
              : "";
      submitClaimRequest.fields["useMemberDefaultBankAccount"] =
          submitClaimParams.useMemberDefaultBankAccount != null
              ? submitClaimParams.useMemberDefaultBankAccount == true
                  ? "1"
                  : "0"
              : "";
      submitClaimRequest.fields["memberBankSwiftCode"] =
          submitClaimParams.memberBankSwiftCode != null
              ? submitClaimParams.memberBankSwiftCode.toString()
              : "";
      submitClaimRequest.fields["memberBankAccountName"] =
          submitClaimParams.memberBankAccountName != null
              ? submitClaimParams.memberBankAccountName.toString()
              : "";
      submitClaimRequest.fields["memberBankIBAN"] =
          submitClaimParams.memberBankIBAN != null
              ? submitClaimParams.memberBankIBAN.toString()
              : "";
      submitClaimRequest.fields["setAsMemberDefaultAccount"] =
          submitClaimParams.setAsMemberDefaultAccount != null
              ? submitClaimParams.setAsMemberDefaultAccount == true
                  ? "1"
                  : "0"
              : "";
      submitClaimRequest.fields["reasonForCheque"] =
          submitClaimParams.reasonForCheque != null
              ? submitClaimParams.reasonForCheque.toString()
              : "";

      //submitClaimRequest.files.add(await http.MultipartFile.fromPath(
      //  'claimAttachment', submitClaimParams.claimAttachmentFilePath!));

      //submitClaimRequest.files.add( http.MultipartFile.fromBytes(
      // 'claimAttachment', File(submitClaimParams.claimAttachmentFilePath!).readAsBytesSync()));

      submitClaimRequest.fields['claimAttachment'] = (base64.encode(
          File(submitClaimParams.claimAttachmentFilePath!).readAsBytesSync()));

      if (submitClaimParams.optionalAttachment1OriginalFileName != null &&
          submitClaimParams.optionalAttachment1OriginalFileName!.trim() != "") {
        submitClaimRequest.fields['optionalAttachment1'] = (base64.encode(
            File(submitClaimParams.optionalAttachment1FilePath!)
                .readAsBytesSync()));
      } else {
        submitClaimRequest.fields['optionalAttachment1'] = "";
      }

      if (submitClaimParams.optionalAttachment2OriginalFileName != null &&
          submitClaimParams.optionalAttachment2OriginalFileName!.trim() != "") {
        submitClaimRequest.fields['optionalAttachment2'] = (base64.encode(
            File(submitClaimParams.optionalAttachment2FilePath!)
                .readAsBytesSync()));
      } else {
        submitClaimRequest.fields['optionalAttachment2'] = "";
      }
      if (submitClaimParams.optionalAttachment3OriginalFileName != null &&
          submitClaimParams.optionalAttachment3OriginalFileName!.trim() != "") {
        submitClaimRequest.fields['optionalAttachment3'] = (base64.encode(
            File(submitClaimParams.optionalAttachment3FilePath!)
                .readAsBytesSync()));
      } else {
        submitClaimRequest.fields['optionalAttachment3'] = "";
      }

      //print(
      //   'submitClaim Request Fields => ${submitClaimRequest.fields.toString()}');

      print("Going to send request -->");
      var submitClaimResponse = await submitClaimRequest.send();
      print("Request sent -->");

      //print('submitClaim Response => ${response.stream.toString()}');

      print(
          "submitClaim Response => Result: ${submitClaimResponse.statusCode}");
      if (submitClaimResponse.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }

      if (submitClaimResponse.statusCode == 200) {
        responseString = "success";
      } else {
        // await is needed to wait for the response stream
        await submitClaimResponse.stream
            .transform(utf8.decoder)
            .listen((value) {
          print("Response is : $value");
          Map<String, dynamic> submitClaimResponseMap = json.decode(value);
          responseString = submitClaimResponseMap['Message'].toString();
          print("Response Message is  : $responseString");
        });
      }

      /*response.stream.transform(utf8.decoder).listen((value) {

        print("Response is :");
       print(value);
      });*/
    } catch (e) {
      print('WTF - submitClaim \n');
      print(e.toString());
    }
    return responseString;
  }

  // CLaims ************************ END //

  // Google Locations ************************ START //

  Future<List> getGoogleLocationFromAdress(String? address) async {
    double lattitude = 0.00;
    double longitude = 0.00;
    try {
      print(
          'getGoogleLocationFromAdress Request => ${Constants.GooglePlaceFromTextUrl}');
      http.Response response = await networkSession.post(
          url: Constants.GooglePlaceFromTextUrl +
              "?input=$address&inputtype=textquery&fields=geometry&key=${Constants.GoogleAPIKey}",
          body: {},
          authorization: "");
      print('getGoogleLocationFromAdress Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }
     if(response.statusCode == 200){
      if (response.body.trim() != "") {
        List<dynamic> responseResultList =
            json.decode(response.body)['candidates'];
        if (responseResultList.length > 0) {
          for (Map<String, dynamic> responseResult in responseResultList) {
            //paramsModel = ParamsModel.fromJson(responseResult);
            //banks.add(paramsModel);
            lattitude = responseResult['geometry']['location']['lat'];
            longitude = responseResult['geometry']['location']['lng'];
          }
        }
      } }else {
        // There is no data
        print("No data available...");
      }
    } catch (e) {
      print('WTF - getGoogleLocationFromAdress \n');
      print(e.toString());
    }
    return [lattitude, longitude];
  }

  // Google Locations ************************ END //

  // Bank Account Details ****************** START //

  /*Future<List<BankAccountsModel>?> getBankAccountDetails(
      LoginData? loginData) async {
    List<BankAccountsModel> bankAccounts = [];
    BankAccountsModel? bankAccountsModel;
    try {
      print('getBankAccounts Request => ${Constants.BankAccountsUrl}');
      http.Response response = await networkSession.post(
          url: Constants.BankAccountsUrl,
          body: {},
          authorization: loginData!.authorization.toString());
      print('getBankAccounts Response => ${response.body}');
      if (response.body.trim() != "") {
        List<dynamic> responseResultList = json.decode(response.body);
        if (responseResultList.length > 0) {
          for (Map<String, dynamic> responseResult in responseResultList) {
            bankAccountsModel = BankAccountsModel.fromJson(responseResult);
            bankAccounts.add(bankAccountsModel);
          }
        }
      } else {
        // There is no data
        print("No data available...");
      }
    } catch (e) {
      print('WTF - getBankAccounts \n');
      print(e.toString());
    }
    return bankAccounts;
  }*/

  Future<String?> saveBankDetails(LoginData? loginData,
      BankSaveUpdateParamsModel bankSaveUpdateParamsModel) async {
    String? responseString;
    try {
      print('saveBankDetails => ${Constants.SaveBankDetail}');

      http.Response response;

      if (bankSaveUpdateParamsModel.bankKey != null) {
        response = await networkSession.post(
            url: Constants.SaveBankDetail,
            body: {
              "swiftCode": bankSaveUpdateParamsModel.swiftCode,
              "accountName": bankSaveUpdateParamsModel.accountName,
              "iban": bankSaveUpdateParamsModel.iban,
              "accountStatus": bankSaveUpdateParamsModel.accountStatus,
              "bankAccountMappingKey": bankSaveUpdateParamsModel.bankKey
            },
            authorization: loginData!.authorization.toString());
      } else {
        response = await networkSession.post(
            url: Constants.SaveBankDetail,
            body: {
              "swiftCode": bankSaveUpdateParamsModel.swiftCode,
              "accountName": bankSaveUpdateParamsModel.accountName,
              "iban": bankSaveUpdateParamsModel.iban,
              "accountStatus": bankSaveUpdateParamsModel.accountStatus
            },
            authorization: loginData!.authorization.toString());
      }

      print('saveBankDetails Response => Result: ${response.statusCode}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }

      if (response.statusCode == 200) {
        responseString = "success";
      } else {
        if (response.body.trim() != "") {
          Map<String, dynamic> responseResult = json.decode(response.body);
          responseString = responseResult['Message'];
        } else {
          responseString = response.statusCode.toString();
        }
      }
    } catch (e) {
      print('WTF - saveBankDetails \n');
      print(e.toString());
    }
    return responseString;
  }

  // Bank Account Details ******************* END  //


  // Contact US ******************* START  //
  Future<List<ContactReasonsModel>?> getContactReasons() async {
    List<ContactReasonsModel> contactReasons = [];
    ContactReasonsModel? contactReasonsModel;
    try {
      print('getContactReasons Request => ${Constants.ContactReasonsUrl}');
      http.Response response = await networkSession.post(
          url: Constants.ContactReasonsUrl,
          body: {},
          authorization: "");
      print('getContactReasons Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }
      if(response.statusCode == 200){
      if (response.body.trim() != "") {
        List<dynamic> responseResultList = json.decode(response.body);
        if (responseResultList.length > 0) {
          for (Map<String, dynamic> responseResult in responseResultList) {
            contactReasonsModel = ContactReasonsModel.fromJson(responseResult);
            contactReasons.add(contactReasonsModel);
          }
        }
      }} else {
        // There is no data
        print("No data available...");
      }
    } catch (e) {
      print('WTF - getContactReasons \n');
      print(e.toString());
    }
    return contactReasons;
  }
  Future<String?> sendMessage(SendMessageParams sendMessageParams) async {
    String? responseString;
    try {
      print('sendMessage => ${Constants.ContactUrl}');

      http.Response response;

        response = await networkSession.post(
            url: Constants.ContactUrl,
            body: {
              "contactReasonKey": sendMessageParams.contactReasonKey.toString(),
              "emailID": sendMessageParams.emailID,
              "comments": sendMessageParams.comments,
              "name": sendMessageParams.name,
              "phoneNumber": sendMessageParams.phoneNumber
            },
            authorization: "");
      

      print('sendMessage Response => Result: ${response.statusCode}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }
      if (response.statusCode == 200) {
        responseString = "success";
      } else {
        if (response.body.trim() != "") {
          Map<String, dynamic> responseResult = json.decode(response.body);
          responseString = responseResult['Message'];
        } else {
          responseString = response.statusCode.toString();
        }
      }
    } catch (e) {
      print('WTF - sendMessage \n');
      print(e.toString());
    }
    return responseString;
  }

  // Contact US ******************* END  //


  // 8. Get member details ************************//
  Future<List<AlMadallaMemberModel>?> getAlMadallaMemberDetailsList(
      LoginData? loginData) async {
    AlMadallaMemberModel? alMadallaMemberModel;
    List<AlMadallaMemberModel> alMadallaMemberModelList = [];

    try {
      print(
          'getAlMadallaMemberDetails Request => ${Constants.MemberDetailsUrl}');
      http.Response response = await networkSession.post(
          url: Constants.MemberDetailsUrl,
          body: {},
          authorization: loginData!.authorization.toString());
      print('getAlMadallaMemberDetails Response => ${response.body}');

      //@harris
      if (response.statusCode == 401) {
          throw SessionExpiredException("").showDialogBox();
      } else if(response.statusCode == 200){
      if (response.body.trim() != "") {
        //Map<String, dynamic> responseResult = json.decode(response.body)[0];
        //alMadallaMemberModel = AlMadallaMemberModel.fromJson(responseResult);

        List<dynamic> responseResultList = json.decode(response.body);
        if (responseResultList.length > 0) {

          for (Map<String, dynamic> responseResult in responseResultList) {
            alMadallaMemberModel = AlMadallaMemberModel.fromJson(responseResult);
            alMadallaMemberModelList.add(alMadallaMemberModel);
          }
          // if (responseResultList.length > 1) {
          //   for (Map<String, dynamic> responseResult in responseResultList) {
          //     if (responseResult['parentmemberkey'] == null) {
          //       alMadallaMemberModel =
          //           AlMadallaMemberModel.fromJson(responseResult);
          //     }
          //   }
          // } else {
          //   Map<String, dynamic> responseResult = responseResultList[0];
          //   alMadallaMemberModel =
          //       AlMadallaMemberModel.fromJson(responseResult);
          // }
        }
      } else {
        // There is no data
        print("No data available...");
      }}
    } catch (e) {

    //  print("code${response.statusCode}");
      throw SessionExpiredException("").showDialogBox();
      // print('WTF - getAlMadallaMemberDetails \n');
      //  print(e.toString());
    }
    return alMadallaMemberModelList;
  }

  //  Get User RequestList ************************//
  Future<List<UserRequestModel>?> getUserRequestList(
      LoginData? loginData) async {
    UserRequestModel? userRequestModel;
    List<UserRequestModel>userRequestModelList = [];
    try {


      print(
          'getUserRequestList Request => ${Constants.UserRequestUrl}');
      http.Response response = await networkSession.post(
          url: Constants.UserRequestUrl,
          body: {
            "languageKey": '1',
          },
          authorization: loginData!.authorization.toString());
      print('getUserRequestList Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      } if(response.statusCode == 200){
        if (response.body.trim() != "") {
          List<dynamic> responseResultList = json.decode(response.body);
          if (responseResultList.length > 0) {
            for (Map<String, dynamic> responseResult in responseResultList) {
              userRequestModel = UserRequestModel.fromJson(responseResult);
              userRequestModelList.add(userRequestModel);
            }
          }
        }}else {
        print("No data available...");
      }
    } catch (e) {
      throw SessionExpiredException("").showDialogBox();
      // print('WTF - getUserRequestList \n');
      // print(e.toString());
    }
    return userRequestModelList;
  }



  //  Save User Request ************************//
  Future<String?> saveUserRequest(
      LoginData? loginData,UserRequestModel userRequestModel) async {
    int? val =userRequestModel.OnlineUserRequestTypeKey;
    String? responseString;

    try {
      print(
          'Save User Request => ${Constants.SaveRequestUrl}');
      print(
          'Save User Request Param => "OnlineUserRequestTypeKey": ${userRequestModel.OnlineUserRequestTypeKey.toString()}');

      http.Response response = await networkSession.post(
          url: Constants.SaveRequestUrl,
          body: {
            "OnlineUserRequestTypeKey": userRequestModel.OnlineUserRequestTypeKey.toString(),
          },
          authorization: loginData!.authorization.toString());

      print('saveBankDetails Response => Result: ${response.statusCode}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }

      if (response.statusCode == 200) {
        responseString = "success";
      } else {
        if (response.body.trim() != "") {
          Map<String, dynamic> responseResult = json.decode(response.body);
          responseString = responseResult['Message'];
        } else {
          responseString = response.statusCode.toString();
        }
      }
    } catch (e) {
      throw SessionExpiredException("").showDialogBox();
      // print('WTF - saveUserRequest \n');
      // print(e.toString());
    }
    return responseString;
  }



  // Get Download File List ************************//
  Future<List<DownloadFileModel>?> getDownloadFileList(
      LoginData? loginData) async {
    DownloadFileModel? downloadFileModel;
    List<DownloadFileModel>downloadFileList = [];
    try {


      print(
          'Get DownloadFile List Request => ${Constants.DownloadUrl}');
      http.Response response = await networkSession.post(
          url: Constants.DownloadUrl,
          body: {
            "languageKey": '1',
          },
          authorization: loginData!.authorization.toString());
      print('getDownloadFileList Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      } if(response.statusCode == 200){
        if (response.body.trim() != "") {
          List<dynamic> responseResultList = json.decode(response.body);
          if (responseResultList.length > 0) {
            for (Map<String, dynamic> responseResult in responseResultList) {
              downloadFileModel = DownloadFileModel.fromJson(responseResult);
              downloadFileList.add(downloadFileModel);
            }
          }
        }}else {
        print("No data available...");
      }
    } catch (e) {
      throw SessionExpiredException("").showDialogBox();
      // print('WTF - getDownLoadFile \n');
      // print(e.toString());
    }
    return downloadFileList;
  }


  //   Download File From List ************************//
  Future<String?> getDownloadedFile(
      LoginData? loginData,DownloadFileModel downloadFileModel) async {
    String? downloadFile ;
    try {
      print(
          'Get DownloadFile List Request => ${Constants.FileDownloadUrl}');
      http.Response response = await networkSession.post(
          url: Constants.FileDownloadUrl,
          body: {
            "fileKey": downloadFileModel.fileKey.toString(),
          },
          authorization: loginData!.authorization.toString());
      print('getDownloadFileList Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }
      if (response.statusCode == 200) {
        if (response.body.trim() != "") {
          Map<String, dynamic> responseResult = json.decode(response.body);
          downloadFile = responseResult['content'];
        } else {
          downloadFile = response.statusCode.toString();
        }
      }
    } catch (e) {
      throw SessionExpiredException("").showDialogBox();
      // print('WTF - getDownLoadFile \n');
      // print(e.toString());
    }
    return downloadFile;
  }


  // Push notification registration ************************//
  Future<bool?> savePushNotificationRegistrationDetails(
      LoginData? loginData) async {
    bool? registrationSuccess = false;
    try {
      //Set One Signal Data @Harris
    PushNotificationsRegistrationModel pushNotificationsRegistrationModel = 
       await PushNotificationsRegistrationModel().setOneSignalParamsData();
    
      print(
          'savePushNotificationRegistrationDetails Request => ${Constants.PushNotificationRegistrationUrl}');
      print(
          'PushNotificationsRegistrationParams Data => ${pushNotificationsRegistrationModel.toString()}');

      http.Response response = await networkSession.post(
          url: Constants.PushNotificationRegistrationUrl,
          body: {
            "pushUserID": pushNotificationsRegistrationModel.pushUserID.toString(),
            "isNotificationEnabled": pushNotificationsRegistrationModel.isNotificationEnabled.toString(),
            "isSubscribed": pushNotificationsRegistrationModel.isSubscribed.toString(),
            "notificationPermissionStatusKey": pushNotificationsRegistrationModel.notificationPermissionStatusKey.toString(),

            "emailUserID": pushNotificationsRegistrationModel.emailUserID.toString(),
            "smsUserID": pushNotificationsRegistrationModel.smsUserID.toString(),
            "emailAddress": pushNotificationsRegistrationModel.emailAddress.toString(),
            "smsNumber": pushNotificationsRegistrationModel.smsNumber.toString(),
            "pushToken": pushNotificationsRegistrationModel.pushToken.toString(),

            "isPushDisabled": pushNotificationsRegistrationModel.isPushDisabled.toString(),
            "isEmailSubscribed": pushNotificationsRegistrationModel.isEmailSubscribed.toString(),
            "isSMSSubscribed": pushNotificationsRegistrationModel.isSMSSubscribed.toString(),
            
          },
          authorization: loginData!.authorization.toString());
      print('savePushNotificationRegistrationDetails Response Status => ${response.statusCode}');
      print('savePushNotificationRegistrationDetails Response => ${response.body}');
      if (response.statusCode == 401) {
        registrationSuccess = false;
        throw SessionExpiredException("").showDialogBox();
      }else if (response.statusCode == 200) {
        /*if (response.body.trim() != "") {
          Map<String, dynamic> responseResult = json.decode(response.body);
          downloadFile = responseResult['Content'];
        } else {
          downloadFile = response.statusCode.toString();
        }*/
        registrationSuccess = true;
      }
      
    } catch (e) {
      print('WTF - savePushNotificationRegistrationDetails \n');
      print(e.toString());
    }
    return registrationSuccess;
  }


  // Push notification details for user ************************//
  /*Future<List<PushNotificationsDetailsModel>?> getPushNotificationsDetailsForUser(
      LoginData? loginData, AlMadallaMemberModel? alMadallaMemberModel) async {
    List<PushNotificationsDetailsModel> pushNotificationsDetailsModelList = [];
    PushNotificationsDetailsModel pushNotificationsDetailsModel;
    try {
      
    
      print(
          'getPushNotificationsDetailsForUser Request => ${Constants.PushNotificationsDetailsForUserUrl}');
      print(
          'getMemberUtilizations memberKey => ${alMadallaMemberModel!.memberKey.toString()}');

      http.Response response = await networkSession.post(
          url: Constants.PushNotificationsDetailsForUserUrl,
          body: { 
            "memberKey": alMadallaMemberModel.memberKey.toString()            
          },
          authorization: loginData!.authorization.toString());
      print('getPushNotificationsDetailsForUser Response Status => ${response.statusCode}');
      print('getPushNotificationsDetailsForUser Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }else if (response.statusCode == 200) {
       
        if (response.body.trim() != "") {
          List<dynamic> responseResultList = json.decode(response.body);
          if (responseResultList.length > 0) {
            for (Map<String, dynamic> responseResult in responseResultList) {
              pushNotificationsDetailsModel = PushNotificationsDetailsModel.fromJson(responseResult);
              pushNotificationsDetailsModelList.add(pushNotificationsDetailsModel);
            }
          
        }}else {
        print("No data available...");
      }
      }
      
    } catch (e) {
      print('WTF - getPushNotificationsDetailsForUser \n');
      print(e.toString());
      throw BadResponseException("").showDialogBox();
    }
    return pushNotificationsDetailsModelList;
  }*/

  Future<List<PushNotificationsDetailsModel>?> getPushNotificationsDetailsForUser(
      LoginData? loginData, List<AlMadallaMemberModel>? alMadallaMemberModelList) async {
    List<PushNotificationsDetailsModel> pushNotificationsDetailsModelList = [];
    PushNotificationsDetailsModel pushNotificationsDetailsModel;
    try {

      for (var i in alMadallaMemberModelList!){
      
    
      print(
          'getPushNotificationsDetailsForUser Request => ${Constants.PushNotificationsDetailsForUserUrl}');
      print(
          'getMemberUtilizations memberKey => ${i.memberKey.toString()}');

      http.Response response = await networkSession.post(
          url: Constants.PushNotificationsDetailsForUserUrl,
          body: { 
            "memberKey": i.memberKey.toString()            
          },
          authorization: loginData!.authorization.toString());
      print('getPushNotificationsDetailsForUser Response Status => ${response.statusCode}');
      print('getPushNotificationsDetailsForUser Response => ${response.body}');
      if (response.statusCode == 401) {
        throw SessionExpiredException("").showDialogBox();
      }else if (response.statusCode == 200) {
       
        if (response.body.trim() != "") {
          List<dynamic> responseResultList = json.decode(response.body);
          if (responseResultList.length > 0) {
            for (Map<String, dynamic> responseResult in responseResultList) {
              pushNotificationsDetailsModel = PushNotificationsDetailsModel.fromJson(responseResult);
              pushNotificationsDetailsModelList.add(pushNotificationsDetailsModel);
            }
          
        }}else {
        print("No data available...");
      }
      }
      }
      
    } catch (e) {
      print('WTF - getPushNotificationsDetailsForUser \n');
      print(e.toString());
      throw BadResponseException("").showDialogBox();
    }
    return pushNotificationsDetailsModelList;
  }


}
