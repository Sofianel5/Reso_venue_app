import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/urls.dart';
import '../../domain/entities/thread.dart';
import '../../domain/entities/timeslot.dart';
import '../../domain/entities/venue.dart';
import '../models/thread_model.dart';
import '../models/timeslot_model.dart';
import '../models/user_model.dart';
import '../models/venue_model.dart';

abstract class RemoteDataSource {
  Future<String> login({String email, String password});
  Future<UserModel> getUser(Map<String, dynamic> headers);
  Future<Map<String, List<TimeSlot>>> getTimeSlots(
      int venueId, Map<String, dynamic> headers);
  Future<bool> scan(String userId, Venue venue, Map<String, dynamic> headers);
  Future<bool> addTimeSlot(
      {DateTime start,
      Venue venue,
      DateTime stop,
      int numAttendees,
      String type,
      Map<String, dynamic> headers});
  Future<bool> deleteTimeSlot(
      TimeSlot timeslot, Venue venue, Map<String, dynamic> headers);
  Future<bool> getHelp(
      String message, Venue venue, Map<String, dynamic> headers);
  Future<TimeSlot> changeAttendees(
      bool add, Venue venue, TimeSlot timeslot, Map<String, dynamic> headers);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;
  RemoteDataSourceImpl({@required this.client});

  String urlEncodeMap(Map<String, String> data) {
    return data.keys
        .map((key) =>
            "${Uri.encodeComponent(key)}=${Uri.encodeComponent(data[key])}")
        .join("&");
  }

  Future<http.Response> _getResponse(Map<String, dynamic> data, String url,
      {Map<String, dynamic> headers, bool getMethod = false}) async {
    try {
      print("going to post");
      http.Response response;
      if (getMethod) {
        String urlParams = urlEncodeMap(data);
        response = await client.get(url + "?" + urlParams,
            headers: headers ?? <String, String>{});
      } else {
        response = await client.post(url,
            body: data, headers: headers ?? <String, String>{});
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else if (response.statusCode == 406) {
        throw NeedsUpdateException();
      } else if (response.statusCode ~/ 100 == 4) {
        throw AuthenticationException();
      } else if (response.statusCode ~/ 100 == 5) {
        throw ServerException();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Map<String, dynamic>> _getJson(Map<String, dynamic> data, String url,
      {Map<String, dynamic> headers, bool useGet = true}) async {
    try {
      print(headers);
      String responseBody =
          (await _getResponse(data, url, headers: headers, getMethod: useGet))
              .body;
      print("get body");
      Map<String, dynamic> responseJson =
          Map<String, dynamic>.from(jsonDecode(responseBody));
      return responseJson;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Future<String> login({String email, String password}) async {
    try {
      Map<String, String> data = <String, String>{
        "email": email,
        "password": password,
      };
      var jsonData;
      var response = await client.post(Urls.LOGIN_URL, body: data);
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        return jsonData["auth_token"];
      } else if (response.statusCode == 401) {
        throw NotAdminException();
      } else if (response.statusCode == 406) {
        throw NeedsUpdateException();
      } else if (response.statusCode / 100 == 4) {
        throw AuthenticationException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Future<UserModel> getUser(Map<String, dynamic> headers) async {
    try {
      final Map<String, dynamic> jsonData = Map<String, dynamic>.from(
          await _getJson(<String, String>{}, Urls.USER_URL,
              headers: Map<String, String>.from(headers)));
      print(headers);
      return UserModel.fromJson(jsonData);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Map<String, List<TimeSlot>>> getTimeSlots(
      int venueId, Map<String, dynamic> headers) async {
    final response =
        await http.get(Urls.getTimeSlotsForId(venueId), headers: headers);
    if (response.statusCode == 200) {
      print(response.body);
      final responseJson = json.decode(response.body);
      List<TimeSlot> history = [];
      for (var ts in responseJson["history"]) {
        history.add(TimeSlotModel.fromJson(ts));
      }
      List<TimeSlot> current = [];
      for (var ts in responseJson["current"]) {
        current.add(TimeSlotModel.fromJson(ts));
      }
      Map<String, List<TimeSlot>> results = <String, List<TimeSlot>>{
        "history": history,
        "current": current
      };
      return results;
    } else if (response.statusCode ~/ 100 == 4) {
      throw AuthenticationException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> scan(
      String userId, Venue venue, Map<String, dynamic> headers) async {
    Map<String, String> data = Map<String, String>.from(<String, String>{
      "to": userId,
    });
    final response = await client.post(Urls.getScanUrl(venue.id),
        headers: headers, body: data);
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 417) {
      throw LockedUserException();
    } else if (response.statusCode == 412) {
      throw UserNotRegistered();
    } else if (response.statusCode ~/ 100 == 4) {
      throw AuthenticationException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> addTimeSlot(
      {DateTime start,
      DateTime stop,
      int numAttendees,
      String type,
      Venue venue,
      Map<String, dynamic> headers}) async {
    print(start);
    print(start.toIso8601String());
    Map<String, String> data = Map<String, String>.from(<String, String>{
      "start": start.toIso8601String(),
      "stop": stop.toIso8601String(),
      "max_attendees": numAttendees.toString(),
      "type": type,
    });
    final response = await client.post(Urls.addTimeSlotUrl(venue.id),
        headers: headers, body: data);
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode ~/ 100 == 4) {
      throw AuthenticationException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> deleteTimeSlot(
      TimeSlot timeslot, Venue venue, Map<String, dynamic> headers) async {
    final response = await client
        .post(Urls.deleteTimeSlot(venue.id, timeslot.id), headers: headers);
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode ~/ 100 == 4) {
      throw AuthenticationException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> getHelp(
      String message, Venue venue, Map<String, dynamic> headers) async {
    Map<String, String> body =
        Map<String, String>.from(<String, String>{"content": message});
    final response = await client.post(Urls.getHelpUrl(venue.id),
        body: body, headers: headers);
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode ~/ 100 == 4) {
      throw AuthenticationException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TimeSlot> changeAttendees(bool add, Venue venue, TimeSlot timeslot,
      Map<String, dynamic> headers) async {
    Map<String, bool> body = Map<String, bool>.from(
      <String, bool>{"add": add},
    );
    final response = await client.post(
        Urls.getChangeTimeslotUrl(venue.id, timeslot.id),
        body: body,
        headers: headers);
    print(response.body);
    if (response.statusCode == 200) {
      return TimeSlotModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 406) {
      throw CannotChangeException();
    } else if (response.statusCode ~/ 100 == 4) {
      throw AuthenticationException();
    } else {
      throw ServerException();
    }
  }
}
