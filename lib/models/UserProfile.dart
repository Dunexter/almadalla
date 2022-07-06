class UserProfile {

  int? key;
  String? name;
  String? gender;
  String? mobile;
  String? emailID;
  String? emiratesIDNo;
  String? dob;
  bool? isAccountVerified;  
  String? message;
  String? payer;
  String? network;
  int? payerKey;
  int? networkKey;
  UserProfile();
  UserProfile.fromJson(Map<String, dynamic> json) {
    this.key = json['key'];
    this.name = json['name'];
    this.gender = json['gender'];
    this.mobile = json['mobile'];
    this.emailID = json['emailid'];
    this.emiratesIDNo = json['emiratesidno'];
    this.isAccountVerified = json['isaccountverified'];
    this.message = json['message'];
    this.dob = json["memberDOB"];
    this.payer = json["payer"];
    this.network = json["network"];
    this.payerKey = json["payerkey"];
    this.networkKey = json["networkkey"];
  }
}
