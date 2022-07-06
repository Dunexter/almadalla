class SubmitClaimParams {

  
  int? cardNo;
  String? serviceDate; 
  String? claimedCost; 
  String? currencyCode; 
  String? claimAttachmentOriginalFileName; 
  String? claimAttachmentFilePath; 
  String? optionalAttachment1OriginalFileName; 
  String? optionalAttachment1FilePath; 
  String? optionalAttachment2OriginalFileName; 
  String? optionalAttachment2FilePath; 
  String? optionalAttachment3OriginalFileName; 
  String? optionalAttachment3FilePath; 
  //bool? isResubmission; 
  String? submissionClaimRef; 
  String? paymentType; 
  bool? useMemberDefaultBankAccount; 
  String? memberBankSwiftCode; 
  String? memberBankAccountName; 
  String? memberBankIBAN; 
  bool? setAsMemberDefaultAccount; 
  String? reasonForCheque; 


  SubmitClaimParams();  
}
