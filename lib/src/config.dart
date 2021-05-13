import 'package:flutter/material.dart';
import 'dart:convert';

class Config {
  static Config _instance;
  factory Config() => _instance ??= new Config._();
  Config._();

  final String _urlPhoneVerify = "https://lookups.twilio.com/v1/PhoneNumbers/";
  final String _encodedCredential = base64.encode(utf8.encode("AC8cbcff8853efab57b37219bd74d6302f:1c214c70d77bdb154bc0e73a1728e98e"));

  final String _prefsKey = "history";
  final Color _colorAppBarBg = Colors.yellow;
  String _userLocationAreaCode = "+852";

  String getUrlPhoneVerify() => _urlPhoneVerify;
  String getEncodedCredential() => _encodedCredential;
  String getPrefsKey() => _prefsKey;
  Color getColorAppBarBg() => _colorAppBarBg;
  String getUserLocationAreaCode() => _userLocationAreaCode;
  void setUserLocationAreaCode(String areaCode) { _userLocationAreaCode = areaCode; }
}