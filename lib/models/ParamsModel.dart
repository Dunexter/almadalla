class ParamsModel {

  
  int? key;  
  String? code; 
  String? swiftCode; 
  String? name; 

  ParamsModel(this.key,this.code,this.name);

  ParamsModel.fromJson(Map<String, dynamic> json) {  
    this.key = json['key'];
    this.code = json['code'];
    this.swiftCode = json['swiftcode'];
    this.name = json['name'];
  }
}
