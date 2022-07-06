class BankAccountsModel {

  
  int? key;  
  int? bankKey;
  String? bank; 
  String? swiftCode; 
  String? accountName; 
  String? iban; 
  bool? status;
  BankAccountsModel(this.key,this.bankKey,this.bank,this.swiftCode,this.accountName,this.iban,this.status);
  BankAccountsModel.fromJson(Map<String, dynamic> json) {  
    this.key = json['key'];
    this.bankKey = json['bankkey'];
    this.bank = json['bank'];
    this.swiftCode = json['swiftcode'];
    this.accountName = json['accountname'];
    this.iban = json['iban'];
    this.status = json['status'];
  }
}
