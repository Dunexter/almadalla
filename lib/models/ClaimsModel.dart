class ClaimsModel {

  String? claimRef;  
  String? claimType; 
  String? serviceDate; 
  String? cardNo; 
  String? provider; 
  double? claimedCost; 
  double? approvedCost; 
  String? claimaction; 
  String? status; 
  String? remarks; 

  ClaimsModel();  

  ClaimsModel.fromJson(Map<String, dynamic> json) {
    
    this.claimRef = json['claimref'];
    this.claimType = json['claimtype'];
    this.serviceDate = json['servicedate'];
    this.cardNo = json['cardno'];
    this.provider = json['provider'];
    this.claimedCost = json['claimedcost'];
    this.approvedCost = json['approvedcost'];
    this.claimaction = json['claimaction'];
    this.status = json['status'];
    this.remarks = json['remarks'];
    
  }
}
