import 'package:shared_preferences/shared_preferences.dart';

class SharedDatabase {
  setAreaID(String userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('aid', userID);
  }

  Future<String> getAreaID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('aid');
  }

  setCatID(String userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cid', userID);
  }

  Future<String> getCatID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('cid');
  }
  setMobile(String userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mobile', userID);
  }

  Future<String> getMobile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('mobile');
  }

  setUserData(String userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', userID);
  }

  Future<String> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('uid');
  }

  setType(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('type', type);
  }

  Future<String> getType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('type');
  }

  setDdone(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('ddon', value);
  }

  Future<bool> isDdon() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getBool('ddon');
  }

  setLogin(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('login', value);
  }

  Future<bool> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getBool('login');
  }

  setProfile(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('profile', value);
  }

  Future<bool> isProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getBool('profile');
  }

  setDoctorCategory(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('cat', value);
  }

  Future<bool> getDoctorCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getBool('cat');
  }

  setLoaction(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('loc', value);
  }

  Future<bool> getLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getBool('loc');
  }

  setSlots(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('slot', value);
  }

  Future<bool> getSlots() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getBool('slot');
  }
}
