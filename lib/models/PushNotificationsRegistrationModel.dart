import 'package:onesignal_flutter/onesignal_flutter.dart';

class PushNotificationsRegistrationModel {

  //Mandatory fields
  
  String? pushUserID; 
  bool? isNotificationEnabled; 
  bool? isSubscribed; 
  int? notificationPermissionStatusKey; //(0 to 4 as per the notification permission)

  //Non - Mandatory fields
  String? emailUserID;
  String? smsUserID;
  String? emailAddress;
  String? smsNumber;
  String? pushToken ;

  bool? isPushDisabled; 
  bool? isEmailSubscribed; 
  bool? isSMSSubscribed; 


  PushNotificationsRegistrationModel();

  Future<PushNotificationsRegistrationModel> setOneSignalParamsData() async {
    PushNotificationsRegistrationModel pushNotificationsRegistrationModel = PushNotificationsRegistrationModel();

    //await oneSignalSetEmail('harris@f5tech.ae');  // for testing
    //await oneSignalSetSMSNumber('971502808032');  // for testing
    final deviceState = await OneSignal.shared.getDeviceState();
    print("OneSignal device state ------------------------------------>>>> ${deviceState?.jsonRepresentation()}");

    pushNotificationsRegistrationModel.pushUserID = deviceState?.userId; 
    pushNotificationsRegistrationModel.isNotificationEnabled = deviceState?.hasNotificationPermission; 
    pushNotificationsRegistrationModel.isSubscribed = deviceState?.subscribed; 
    pushNotificationsRegistrationModel.notificationPermissionStatusKey = 4; 

    pushNotificationsRegistrationModel.emailUserID = deviceState?.emailUserId; 
    pushNotificationsRegistrationModel.smsUserID = deviceState?.smsUserId; 
    pushNotificationsRegistrationModel.emailAddress = deviceState?.emailAddress; 
    pushNotificationsRegistrationModel.smsNumber = deviceState?.smsNumber; 
    pushNotificationsRegistrationModel.pushToken = deviceState?.pushToken; 

    pushNotificationsRegistrationModel.isPushDisabled = deviceState?.pushDisabled; 
    pushNotificationsRegistrationModel.isEmailSubscribed = deviceState?.emailSubscribed; 
    pushNotificationsRegistrationModel.isSMSSubscribed = deviceState?.smsSubscribed; 

    return pushNotificationsRegistrationModel;
  }

  static Future<void> oneSignalSetEmail(String? _emailAddress) async {
    
    if(_emailAddress!=null && _emailAddress.trim()!=""){
      print("Setting email");
      await OneSignal.shared.setEmail(email: _emailAddress);
    }else{
      print("Couldnt Set email");
    }
    /*OneSignal.shared.setEmail(email: _emailAddress).whenComplete(() {
      print("Successfully set email");
    }).catchError((error) {
      print("Failed to set email with error: $error");
    });*/
  }
  static Future<String?> oneSignalGetEmailID() async {
    final deviceState = await OneSignal.shared.getDeviceState();
    return deviceState?.emailAddress;
  }

  static Future<void> oneSignalSetSMSNumber(String? _smsNumber) async {    
    if(_smsNumber!=null && _smsNumber.trim()!=""){
      print("Setting SMS Number ----> $_smsNumber");
      await OneSignal.shared.setSMSNumber(smsNumber: _smsNumber);
    }else{
      print("Couldnt Set sms");
    }
    /*OneSignal.shared.setSMSNumber(smsNumber: _smsNumber).then((response) {
      print("Successfully set SMSNumber with response $response");
    }).catchError((error) {
      print("Failed to set SMS Number with error: $error");
    });*/
  }
  static Future<String?> oneSignalGetSMSNumber() async {
    final deviceState = await OneSignal.shared.getDeviceState();
    return deviceState?.smsNumber;
  }

  static Future<void> oneSignalDisablePush(bool disable) async {
    await OneSignal.shared.disablePush(disable);
  }  
  static Future<bool?> oneSignalPushDisabledStatus() async {
    final deviceState = await OneSignal.shared.getDeviceState();
    return deviceState?.pushDisabled;
  }

  
  static Future<String> printOneSignalDeviceStatus() async {
    final deviceState = await OneSignal.shared.getDeviceState();
    String state = deviceState!.jsonRepresentation();
    print("OneSignal device state ------------------------------------>>>> $state");
    return state;
  }
  String toString(){
    String values = "The Push Notification Params=======================================\n";

    values = values + "pushUserID -> $pushUserID \n"; 
    values = values + "isNotificationEnabled -> $isNotificationEnabled \n"; 
    values = values + "subscribed -> $isSubscribed \n"; 
    values = values + "notificationPermissionStatusKey -> $notificationPermissionStatusKey \n"; 

    values = values + "emailUserID -> $emailUserID \n"; 
    values = values + "smsUserID -> $smsUserID \n"; 
    values = values + "emailAddress -> $emailAddress \n"; 
    values = values + "smsNumber -> $smsNumber \n"; 
    values = values + "pushToken -> $pushToken \n"; 

    values = values + "isPushDisabled -> $isPushDisabled \n"; 
    values = values + "isEmailSubscribed -> $isEmailSubscribed \n"; 
    values = values + "isSMSSubscribed -> $isSMSSubscribed \n"; 

    //print(values);

    return values;
  }




  
}
