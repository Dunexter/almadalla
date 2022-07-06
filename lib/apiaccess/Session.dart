import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Session {
  // make singleton
  static final Session session = Session._internal();
  factory Session() {
    return session;
  }
  Session._internal();

  final JsonDecoder jsonDecoder = new JsonDecoder();
  final JsonEncoder jsonEncoder = new JsonEncoder();

  Map<String, String> headers = {};
  Map<String, String> cookies = {};

  //Future<http.Response> get(String s, {String url}) async {
  Future<http.Response> get({required String url,required String authorization, Map<String, String>? customHeaders} ) async {
    //print('GET HEADER = ${headers.values}');
    //print('GET URL = $url');

    Map<String, String> postHeaders = {};//customHeaders!=null?customHeaders:headers;
    postHeaders["Content-Type"] = "application/x-www-form-urlencoded";
    if(authorization.trim()!=""){
      postHeaders["Authorization"] = authorization;
    } 

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    //print('Response Status = ${response.statusCode}');
    //print('Response Header = ${response.headers}');
    //print('Response Body = ${response.body}');

    updateCookie(response);

    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }

    return response;
  }

  Future<http.Response> post({required String url, dynamic body, required String authorization, Map<String, String>? customHeaders}) async {
    ////print('POST HEADER = ${headers.values}');
    ////print('POST BODY = $body');

    //Map<String, String> postHeaders = {"Content-type": "application/json"};
    //Map<String, String> postHeaders = customheaders!;
    Map<String, String> postHeaders = {};//customHeaders!=null?customHeaders:headers;
    postHeaders["Content-Type"] = "application/x-www-form-urlencoded";

    if(authorization.trim()!=""){
      print("Authorization token --> ${authorization.trim()}");
      postHeaders["Authorization"] = authorization;
    }    

    http.Response response = await http.post(Uri.parse(url), headers: postHeaders, body: body);
    
    /*http.Request requestNew = http.Request("POST",Uri.parse(url));
    requestNew.headers.addAll(postHeaders);
    requestNew.bodyFields.addAll(body);

    print('RequestNew ====> $requestNew');*/

    //var responseNew = await requestNew.send();

    ////print('Response Status = ${response.statusCode}');
    ////print('Response Header = ${response.headers}');
    ////print('Response Body = ${response.body}');
    ///
    

    updateCookie(response);

    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 ){//|| json == null) {
      throw new Exception("Error while fetching data");
    }

    return response;
  }

  void updateCookie(http.Response response) {
    var allSetCookie = response.headers['set-cookie'];

    if (allSetCookie != null) {
      var cookies = allSetCookie.split(',');
      for (var cookie in cookies) {
        var cookies = cookie.split(';');
        for (var cookie in cookies) {
          setCookie(cookie);
        }
      }
      headers['cookie'] = generateCookieHeader();
    }
  }

  void setCookie(String rawCookie) {
    if (rawCookie.length > 0) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];
        // ignore keys that aren't cookies
        if (key == 'path' || key == 'expires') return;
        this.cookies[key] = value;
      }
    }
  }

  String generateCookieHeader() {
    String cookie = "";
    for (var key in cookies.keys) {
      if (cookie.length > 0) cookie += ";";
      //cookie += key + "=" + cookies[key];
      cookie += key + "=" + ((cookies[key]!=null)?cookies[key].toString():"");
      
    }
    return cookie;
  }

  /*String businessLogic_Login(http.Response response) {
    //print('------------------------------------------');
    //print(response.headers);
    //print('------------------------------------------');
    //print('Body = ');
    //print(response.body);
    //print('StatusCode = ');
    //print(response.statusCode);
    //print('Headers = ');
    //print(response.headers);

    final String res = response.body;
    final String cookie = response.headers['set-cookie'];
    //print('Cookie = ');
    //print(cookie);
    final String remember =
        cookie.split('bi_remember_me_token=')[1].split(';')[0];
    //print('REMEMBER ->' + remember + '<-');
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    //print('RES = $res');

    if (res.contains('success')) {
      //print('RETURN VALUE = $cookie');
      return remember;
    } else {
      //print('RETURN VALUE = ERROR');
      return 'error';
    }
  }*/

  /*void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }*/
}
