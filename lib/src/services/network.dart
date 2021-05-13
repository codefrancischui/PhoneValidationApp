import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:phone_validation_app/src/config.dart';

class Network {
  static Network _instance;
  factory Network() => _instance ??= new Network._();
  Network._();

  Future<dynamic> validateGet(String phoneNum) async {
    return get(Config().getUrlPhoneVerify() + phoneNum);
  }

  Future<dynamic> get(String url) async {
    // print('Api Get, url $url');
    var responseJson;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic ${Config().getEncodedCredential()}',
        },
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw Exception('No Internet connection');
    }
    // print('Api response: $responseJson');
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return json.decode(response.body.toString());
      default:
        print("Response error status code: ${response.statusCode}");
        return null;
    }
  }
}