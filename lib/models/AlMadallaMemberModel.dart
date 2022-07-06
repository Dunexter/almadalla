class AlMadallaMemberModel {

  int? memberKey;
  String? payer;
  String? employeeID;
  String? cardNo;
  String? emiratesIDNo;
  String? policyNo;
  String? category;
  String? network;
  String? nameEnglish;
  String? nameArabic;
  String? gender;
  int? parentMemberKey;
  String? relationship;
  String? dob;
  String? policyStartDate;
  String? policyEndDate;
  int? payerKey;
  int? networkKey;
  String? message;

  AlMadallaMemberModel();  

  AlMadallaMemberModel.fromJson(Map<String, dynamic> json) {
    
    this.memberKey = json['memberkey'];
    this.payer = json['payer'];
    this.employeeID = json['employeeid'];
    this.cardNo = json['cardno'];
    this.emiratesIDNo = json['emiratesidno'];
    this.policyNo = json['policyno'];
    this.category = json['category'];
    this.network = json['network'];
    this.nameEnglish = json['nameenglish'];
    this.nameArabic = json['namearabic'];
    this.gender = json['gender'];
    this.parentMemberKey = json['parentmemberkey'];
    this.relationship = json['relationship'];
    this.dob = json['dob'];
    this.policyStartDate = json['policystartdate'];
    this.policyEndDate = json['policyenddate'];
    this.payerKey = json['payerkey'];
    this.networkKey = json['networkkey'];
    this.message = json['Message'];

  }
}
