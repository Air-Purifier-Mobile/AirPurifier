import 'dart:convert';
import 'dart:io';

import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/authentication_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class HomeViewModel extends BaseViewModel {
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
  bool dataReady = false;

  void logout() {
    _authenticationService.signOut();
  }

  void getPermissions() async {
    Future.delayed(
      Duration(seconds: 0),
      () async {
        Position _position;
        _position = await _authenticationService.getLocation();
        if (_position != null) {
          position = _position;
          //setup http request
          var url = Uri.https(
            "api.openweathermap.org",
            "/data/2.5/weather?lat=${_position.latitude.toString()}&lon=${_position.longitude.toString()}&appid=$apiKey",
          );
          await http.get(url).then((result) {
            print(result.body);
            Map weatherMap = jsonDecode(result.body);
            if (weatherMap["cod"] == 200) {
              cityName = weatherMap["name"];
              description = weatherMap["weather"]["description"];
              temperature = weatherMap["main"]["temp"];
              feelsLike = weatherMap["main"]["feels_like"];
              humidity = weatherMap["main"]["humidity"];
              minTemp = weatherMap["main"]["temp_min"];
              maxTemp = weatherMap["main"]["temp_max"];
              dataReady = true;
              notifyListeners();
            }
          });
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
