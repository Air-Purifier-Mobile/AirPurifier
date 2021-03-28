import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/authentication_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class HomeViewModel extends BaseViewModel {
  static const endPointUrl = 'https://api.openweathermap.org/data/2.5';
  static String apiKey = "877d03d951c069bd37eaec4c9ee02abc";
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  Position position;
  String cityName;
  String description;
  String temperature;
  String feelsLike;
  String humidity;
  String minTemp;
  String maxTemp;
  MaterialColor color = Colors.lightBlue;
  void logout() {
    _authenticationService.signOut();
  }

  void refresh() {
    position = null;
    cityName = null;
    description = null;
    temperature = null;
    feelsLike = null;
    humidity = null;
    minTemp = null;
    maxTemp = null;
    notifyListeners();
    getPermissions();
  }

  void getPermissions() async {
    Future.delayed(
      Duration(seconds: 0),
      () async {
        Position _position;
        _position = await _authenticationService.getLocation();
        if (_position != null) {
          position = _position;
          double lat = _position.latitude;
          double lon = _position.longitude;
          http.Client client = http.Client();
          final requestUrl =
              '$endPointUrl/weather?lat=$lat&lon=$lon&APPID=$apiKey';
          Uri url = Uri.parse(requestUrl);
          client.get(url).then((result) {
            print(result.body);
            Map weatherMap = jsonDecode(result.body);
            if (weatherMap["cod"] == 200) {
              cityName = weatherMap["name"];
              description = weatherMap["weather"][0]["description"];
              temperature =
                  (weatherMap["main"]["temp"] - 273.15).floor().toString();
              feelsLike = (weatherMap["main"]["feels_like"] - 273.15)
                  .floor()
                  .toString();
              humidity = weatherMap["main"]["humidity"].toString();
              minTemp =
                  (weatherMap["main"]["temp_min"] - 273.15).floor().toString();
              maxTemp =
                  (weatherMap["main"]["temp_max"] - 273.15).floor().toString();
              notifyListeners();
            }
          });
          //setup http request
          //https: //samples.openweathermap.org/data/2.5/weather?q=London&appid=439d4b804bc8187953eb36d2a8c26a02
          // var url = Uri.https(
          //   "api.openweathermap.org",
          //   "/data/2.5/weather?lat=${_position.latitude.toString()}&lon=${_position.longitude.toString()}&appid=$apiKey",
          // );
          // await http.get(Uri.encodeFull(url)).then((result) {
          //
          // });
        }
      },
    );
  }

  Map dummy = {
    "coord": {"lon": 80.3319, "lat": 26.4499},
    "weather": [
      {
        "id": 721,
        "main": "Haze",
        "description": "haze",
        "icon": "50n",
      }
    ],
    "base": "stations",
    "main": {
      "temp": 302.15,
      "feels_like": 303.36,
      "temp_min": 302.15,
      "temp_max": 302.15,
      "pressure": 1006,
      "humidity": 45
    },
    "visibility": 4000,
    "wind": {
      "speed": 1.03,
      "deg": 0,
    },
    "clouds": {
      "all": 0,
    },
    "dt": 1616947408,
    "sys": {
      "type": 1,
      "id": 9176,
      "country": "IN",
      "sunrise": 1616891640,
      "sunset": 1616935999,
    },
    "timezone": 19800,
    "id": 1267995,
    "name": "Kanpur",
    "cod": 200,
  };
}
