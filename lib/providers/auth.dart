import 'package:flutter/cupertino.dart';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier{

  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  
   bool get isAuth{
     return token !=null;
   }

  String get token{
    if(_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token!=null)
      return _token;
    return null;
  }
  
  String get userId{
    return _userId;
  }
  Future<void> signup(String email,String password) async{

    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCFukUkIGunAPp6mXCSo9VE4i91KO5kVxg';
    try{
      final response = await http.post(
      url,
      body:json.encode(
        {'email':email,'password':password,'returnSecureToken':true}));
      
      final responsedata = json.decode(response.body);
      if(responsedata['error'] != null){
        throw HttpException(responsedata['error']['message']);
      }
      _token = responsedata['idToken'];
      _userId = responsedata['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responsedata['expiresIn'])));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({'token':_token,'userId':_userId,'expiryDate':_expiryDate.toIso8601String()});
      prefs.setString('userData', userData);
    }
    catch(error){
      throw error;
    }
    
  }
  Future<void> login(String email,String password) async{
    
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCFukUkIGunAPp6mXCSo9VE4i91KO5kVxg';
    try{
      final response = await http.post(
      url,
      body:json.encode(
        {'email':email,'password':password,'returnSecureToken':true}
      )
    );
      
      final responsedata = json.decode(response.body);
      if(responsedata['error'] != null){
        throw HttpException(responsedata['error']['message']);
      }
      _token = responsedata['idToken'];
      _userId = responsedata['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responsedata['expiresIn'])));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({'token':_token,'userId':_userId,'expiryDate':_expiryDate.toIso8601String()});
      prefs.setString('userData', userData);
    }
    catch(error){
      throw error;
    }
  }
  Future<void> logout() async{
    _token  = null;
    _userId = null;
    _expiryDate = null;
    if(_authTimer!=null){
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
  Future<bool> tryAutoLogin() async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
      
    final extractedUsersData =  json.decode(prefs.getString('userData')) as Map<String,Object>;
    final expiryDate = DateTime.parse(extractedUsersData['expiryDate']);
    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }
    _token = extractedUsersData['token'];
    _userId = extractedUsersData['userId'];
    _expiryDate = DateTime.parse(extractedUsersData['expiryDate']);
    notifyListeners();
    _autoLogout();
    return true;
  }

  void _autoLogout(){

    if(_authTimer!=null){
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
      
    _authTimer = Timer(
      Duration(seconds:timeToExpiry),
      logout
    );
  }

}