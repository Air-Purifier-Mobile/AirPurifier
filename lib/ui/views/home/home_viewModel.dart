import 'dart:convert';
import 'package:air_purifier/app/router.gr.dart';
import 'package:air_purifier/services/firestore_service.dart';
import 'package:air_purifier/services/mqtt_service.dart';
import 'package:air_purifier/services/streaming_shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/authentication_service.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  static const endPointUrl = 'https://api.openweathermap.org/data/2.5';
  static String apiKey = "877d03d951c069bd37eaec4c9ee02abc";
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final MqttService _mqttService = locator<MqttService>();
  final StreamingSharedPreferencesService _streamingSharedPreferencesService =
      locator<StreamingSharedPreferencesService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  Position position;
  String cityName;
  String description;
  String temperature;
  String feelsLike;
  String humidity;
  String minTemp;
  String maxTemp;
  String pm1;
  String pm2;
  String pm10;
  String mac;
  String rootTopic = "/patwardhankaiwalya@gmail.com/AP EMBEDDED/Airpurifier/";
  FSBStatus drawerCurrentState = FSBStatus.FSB_CLOSE;
  Color primaryColor = Color.fromRGBO(39, 35, 67, 1);
  DateTime today = DateTime.now();

  void logout() {
    _authenticationService.signOut();
  }

  void menuToggle() {
    drawerCurrentState = drawerCurrentState == FSBStatus.FSB_OPEN
        ? FSBStatus.FSB_CLOSE
        : FSBStatus.FSB_OPEN;
    notifyListeners();
  }

  String getDay(int day) {
    switch (day) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "";
    }
  }

  String getMonth(int month) {
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
      default:
        return "";
    }
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
    pm1 = null;
    pm2 = null;
    pm10 = null;
    notifyListeners();
    getPermissions();
  }

  void getPermissions() async {
    _firestoreService
        .retrieveUserDocument(_authenticationService.getUID())
        .then((temp) {
      if (temp.exists) {
        _streamingSharedPreferencesService.changeStringInStreamingSP(
            'MAC', temp.data()['MAC']);
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
                  minTemp = (weatherMap["main"]["temp_min"] - 273.15)
                      .floor()
                      .toString();
                  maxTemp = (weatherMap["main"]["temp_max"] - 273.15)
                      .floor()
                      .toString();
                  notifyListeners();
                }
              });
            }
            print(" =============================MAC :" +
                _streamingSharedPreferencesService
                    .readStringFromStreamingSP("MAC"));
            setBusy(true);
            _mqttService.setupConnection(
              connectionSuccessful,
              changeDisplayText,
              setInitialValues,
              getPermissions,
            );
          },
        );
      }
    });
  }

  void gotoRemoteScreen() {
    _mqttService.disconnectBroker();
    _navigationService.navigateTo(Routes.remoteControlView, arguments: refresh);
  }

  void connectionSuccessful() {
    mac = _streamingSharedPreferencesService.readStringFromStreamingSP("MAC") +
        "/";
    _mqttService.subscribeToTopic(rootTopic + mac + "PM 1.0");
    _mqttService.subscribeToTopic(rootTopic + mac + "PM 2.5");
    _mqttService.subscribeToTopic(rootTopic + mac + "PM 10");
  }

  void changeDisplayText(String display) {}

  void setInitialValues(String value, String topic) {
    // print("\n----------------\n$value + $topic\n---------------------");
    if (topic == rootTopic + mac + "PM 1.0") {
      pm1 = value;
    } else if (topic == rootTopic + mac + "PM 2.5") {
      pm2 = value;
    } else if (topic == rootTopic + mac + "PM 10") {
      pm10 = value;
    }
    notifyListeners();
  }

  void goToBluetoothScreen() {
    _navigationService.navigateTo(Routes.addDeviceView);
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
