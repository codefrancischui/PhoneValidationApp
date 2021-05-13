import 'package:flutter/material.dart';
import 'package:phone_validation_app/src/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttemptedHistory extends StatefulWidget {
  @override
  _AttemptedHistoryState createState() => _AttemptedHistoryState();
}

class _AttemptedHistoryState extends State<AttemptedHistory> {
  List<String> _prefsHistory = [];
  final String _prefsKey = "history";

  @override
  void initState() {
    super.initState();
    getPhoneInput();
  }

  Future<Null> getPhoneInput() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _prefsHistory = prefs.getStringList(Config().getPrefsKey()) ?? [];
    });
    print(_prefsHistory);
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Config().getColorAppBarBg(),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: _prefsHistory.length,
          itemBuilder: (BuildContext context, int index) {
            print(_prefsHistory);
            return ListTile(
              title: Text((index+1).toString() + ": " + _prefsHistory[_prefsHistory.length-(index+1)]),
            );
          },
        ),
      ),
    );
  }
}

