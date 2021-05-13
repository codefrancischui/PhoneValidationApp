import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phone_validation_app/src/config.dart';
import 'package:phone_validation_app/src/services/network.dart';
import 'package:phone_validation_app/src/screens/attempted_history_screen.dart';

class PhoneVerify extends StatefulWidget {
  @override
  _PhoneVerifyState createState() => _PhoneVerifyState();
}

enum ValidateState{
  needValidate,
  valid,
  invalid,
}

class _PhoneVerifyState extends State<PhoneVerify> {
  String _areaCode = "";
  String _phoneNum = "";
  String _latestValidateString = "";
  String _validateResult = "";
  Color _validateResultColor;
  ValidateState _status = ValidateState.needValidate;

  final String _strMsgSuccess = "Success";
  final String _strMsgFail = "Invalid phone number. Please try again.";
  final Color _colorMsgSuccess = Colors.green[300];
  final Color _colorMsgFail = Colors.red[300];

  @override
  void initState() {
    super.initState();
  }

  void updateResult(bool isValid)
  {
    setState(() {
      _validateResult = (isValid)? _strMsgSuccess : _strMsgFail;
      _validateResultColor = (isValid)? _colorMsgSuccess : _colorMsgFail;
      _status = (isValid) ? ValidateState.valid : ValidateState.invalid;
    });
  }

  void handleValidateResult(bool isValid)
  {
    updateResult(isValid);
    appendPhoneInput("$_areaCode-$_phoneNum").then((value) =>
        setState(() {
          _status = (isValid) ? ValidateState.valid : ValidateState.invalid;
        })
    );
  }

  void verifyPhone () {
    if (_phoneNum == "")
      updateResult(false);
    else if(_latestValidateString != _areaCode + _phoneNum) {
      _latestValidateString = _areaCode + _phoneNum;
      Network().validateGet(_latestValidateString).then((response) =>
      {
        handleValidateResult(response != null)
      });
    }
  }

  Future<Null> appendPhoneInput(String phoneNum) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> prefsHistory = prefs.getStringList(Config().getPrefsKey()) ?? [];
    prefsHistory.add(phoneNum);
    prefs.setStringList(Config().getPrefsKey(), prefsHistory);
    print(prefsHistory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Validation'),
        backgroundColor: Config().getColorAppBarBg(),
        actions: [
          if(_status == ValidateState.valid) Container(
            margin:EdgeInsets.only(right: 10),
            child:IconButton(
              icon: Text("Next"),
              tooltip: 'Go to the next page',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AttemptedHistory()),
                );
              },
            ),
          ),
          if(_status != ValidateState.valid ) Container(
            margin: EdgeInsets.only(right:10),
            alignment: Alignment.centerRight,
            child: IconButton(
              iconSize: 40.0,
              icon: Text("Verify"),
              onPressed: () {
                verifyPhone();
              },
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: CountryCodePicker(
                      enabled: true,
                      onInit: (c) => _areaCode = c.dialCode,
                      onChanged: (c) {
                        if(_areaCode != c.dialCode) {
                          _areaCode = c.dialCode;
                          setState(() { _status = ValidateState.needValidate; });
                          verifyPhone();
                        }
                      },
                      initialSelection: Config().getUserLocationAreaCode(),
                      favorite: [Config().getUserLocationAreaCode()],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Focus(
                            onFocusChange: (hasFocus) {
                              if(!hasFocus && _status == ValidateState.needValidate) {
                                verifyPhone();
                              }
                            },
                            child: TextField(
                              // controller: phoneNumController,
                              onChanged: (newPhoneNum) {
                                _phoneNum = newPhoneNum;
                                setState(() { _status = ValidateState.needValidate; });
                              },
                              decoration: InputDecoration(labelText: "Enter your number"),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // validStatusSection,
            if(_status == ValidateState.valid || _status == ValidateState.invalid)
              Container(
                padding: const EdgeInsets.only(top: 5),
                alignment: Alignment.centerRight,
                child: Text(
                  _validateResult,
                  style: TextStyle(color: _validateResultColor),
                ),
              ),
          ],
        ),
      ),
    );
  }
}