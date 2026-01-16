import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_vendor_app/view/screens/Subcriptionplans/token_string.dart';

class MyToken {
  static Future getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(TokenString.userid);
    return data;
  }

  static Future setUserID(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(TokenString.userid, userId);
    // return data;
  }

  static Future getPlanStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(TokenString.planStatus);
    return data;
  }

  static Future setUserType(String userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(TokenString.userType, userType);
    // return data;
  }

  static Future<String> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = await prefs.getString(TokenString.userType);
    return data ?? '';
  }
}
