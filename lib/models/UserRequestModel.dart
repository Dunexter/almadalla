class UserRequestModel {
  int? OnlineUserRequestTypeKey;
  String? name;

  UserRequestModel();

  UserRequestModel.fromJson(Map<String, dynamic> json) {
    this.OnlineUserRequestTypeKey = json['OnlineUserRequestTypeKey'];
    this.name = json['Name'];
  }
}
