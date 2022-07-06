class MemberUtilizationModel {

  double? amount;
  double? utilizedAmount;
  double? balanceAmount;
  String? policySubLimit;  

  MemberUtilizationModel();  

  MemberUtilizationModel.fromJson(Map<String, dynamic> json) {
    
    this.amount = json['amount'];
    this.utilizedAmount = json['utilizedamount'];
    this.balanceAmount = json['balanceamount'];
    this.policySubLimit = json['policysublimit'];
  }
}
