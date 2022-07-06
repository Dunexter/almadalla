class PushNotificationsDetailsModel {

  
  
  String? notificationText; 
  String? notificationDate; 

  PushNotificationsDetailsModel(this.notificationText,this.notificationDate);

  PushNotificationsDetailsModel.fromJson(Map<String, dynamic> json) {  
    this.notificationText = json['NotificationText'];
    this.notificationDate = json['CreatedDateTime'];
  }
}
