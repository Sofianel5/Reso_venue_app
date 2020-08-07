import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/coordinates.dart';
import '../../domain/entities/user.dart';
import '../models/coordinates_model.dart';
import '../models/user_model.dart';

abstract class LocalDataSource {
  Future<String> getAuthToken() {}
  Future<void> cacheAuthToken(String token) {}
  Future<void> clearData() {}
  Future<Coordinates> getCoordinates() {}
  Future<void> cacheUser(UserModel user) {}
  Future<User> getCachedUser() {}
  Future<int> getCurrentVenue() {}
  Future<void> cacheCurrentVenue(int index) {}
}
const String AUTH_TOKEN_KEY = "authtoken";
const String USER_KEY = "user";
const String CURRENT_VENUE_KEY = "CURRENT_VENUE";

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;
  LocalDataSourceImpl(this.sharedPreferences);

  Future<String> _getString(String key) {
    final String str = sharedPreferences.getString(key);
    if (str != null) {
      return Future.value(str);
    } else {
      throw CacheException();
    }
  }

  Future<Map<String, dynamic>> _getJson(String key) async {
    try {
      String result = await _getString(key);
      return json.decode(result);
    } on CacheException {
      throw CacheException();
    }
  }

  Future<void> _setString(String key, String value) async {
    try {
      sharedPreferences.setString(key, value);
      return;
    } on Exception {
      throw CacheException();
    }
  }

  Future<void> _setJson(String key, Map<String, dynamic> data) async {
    try {
      final String str = json.encode(data);
      return await _setString(key, str);
    } on CacheException {
      throw CacheException();
    }
  }
  
  @override
  Future<String> getAuthToken() {
    return _getString(AUTH_TOKEN_KEY);
  }

  @override
  Future<void> cacheAuthToken(String token) async {
    return await _setString(AUTH_TOKEN_KEY, token);
  }

  

  @override 
  Future<void> clearData() async {
    try {
      final pref = await SharedPreferences.getInstance();
      await pref.clear();
      return;
    } catch (e) {
      throw CacheException();
    }
  }

  Future<Coordinates> getCoordinates() async {
    try {
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (position == null) {
        Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
        if (position == null) {
          return null;
        }
      }
      Map<String, String> coordinates = {
        "LAT": position.latitude.toString(),
        "LNG": position.longitude.toString()
      };
      return CoordinatesModel.fromJson(coordinates);
    } catch(e) {
      return null;
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    Map<String, dynamic> userJson = user.toJson();
    return await _setJson(USER_KEY, userJson);
  }

  @override
  Future<User> getCachedUser() async {
    Map<String, dynamic> userJson = await _getJson(USER_KEY);
    return UserModel.fromJson(userJson);
  }

  @override
  Future<int> getCurrentVenue() async {
    return int.parse(await _getString(CURRENT_VENUE_KEY));
  }

  @override
  Future<void> cacheCurrentVenue(int index) async {
    return await _setString(CURRENT_VENUE_KEY, index.toString());
  }
}
