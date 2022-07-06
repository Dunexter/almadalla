class LoginData {

  String? accessToken;
  String? tokenType;  
  int? expiresIn;
  String? error;
  String? errorDescription;
  String? authorization;

  LoginData.fromJson(Map<String, dynamic> json) {
    this.accessToken = json['access_token'];
    this.tokenType = json['token_type'];
    this.expiresIn = json['expires_in'];
    this.error = json['error'];
    this.errorDescription = json['error_description'];
    this.authorization = json['access_token']!=null?(json['token_type'] + " " + json['access_token']):null;
  }
}
