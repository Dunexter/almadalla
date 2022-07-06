class ContactReasonsModel {

  
  int? key;  
  String? name; 
  String? arabicName; 
  

  ContactReasonsModel(this.key,this.name,this.arabicName);

  ContactReasonsModel.fromJson(Map<String, dynamic> json) {  
    this.key = json['key'];
    this.name = json['name'];
    this.arabicName = json['arabicname'];
    
  }
}
