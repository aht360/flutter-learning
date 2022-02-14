import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  late String? _token;
  DateTime? _expiryTime;
  late String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryTime != null &&
        _expiryTime!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    final url = Uri.https(
      'identitytoolkit.googleapis.com',
      '/v1/accounts:$urlSegment',
      {
        'key': 'AIzaSyBwoIdXVLwSUfze6dco111CdUVSPRqZBKo',
      },
    );

    try {
      final requestBody = json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      });

      final response = await http.post(url, body: requestBody);

      final responseData = json.decode(
        response.body,
      );

      if (responseData['error'] != null) {
        throw HttpException(
          responseData['error']['message'],
        );
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryTime = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );

      _autoLogout();
      notifyListeners();

      SharedPreferences.setMockInitialValues({});

      final prefs = await SharedPreferences.getInstance();

      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryTime': _expiryTime!.toIso8601String(),
      });

      await prefs.setString('userData', userData);
    } catch (err) {
      throw err;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }

    final String? encodedUserData = prefs.getString('userData');

    final extractedUserData = json.decode(encodedUserData!);

    final expiryTime = DateTime.parse(extractedUserData['expiryTime']!);

    if (expiryTime.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryTime = expiryTime;
    notifyListeners();
    _autoLogout();

    return true;
  }

  Future<void> signUp(
    String email,
    String password,
  ) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(
    String email,
    String password,
  ) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryTime = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryTime!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(
      Duration(
        seconds: timeToExpiry,
      ),
      logout,
    );
  }
}
