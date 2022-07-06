class NetworkProviderModel {

  String? name;  
  String? location; 
  String? city; 
  String? phone; 
  String? fax; 

  NetworkProviderModel();  

  NetworkProviderModel.fromJson(Map<String, dynamic> json) {
    
    this.name = json['name'];
    this.location = json['location'];
    this.city = json['city'];
    this.phone = json['phone'];
    this.fax = json['fax'];
  }
}
