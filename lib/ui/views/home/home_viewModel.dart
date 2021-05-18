import 'dart:async';
import 'dart:convert';
import 'package:air_purifier/app/router.gr.dart';
import 'package:air_purifier/services/firestore_service.dart';
import 'package:air_purifier/services/mqtt_service.dart';
import 'package:air_purifier/services/streaming_shared_preferences_service.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';
import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/authentication_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:stacked_services/stacked_services.dart';

import '../../../main.dart';

class HomeViewModel extends BaseViewModel {
  /// weather api url
  static const endPointUrl = 'https://api.openweathermap.org/data/2.5';

  /// weather api key
  static String apiKey = "877d03d951c069bd37eaec4c9ee02abc";

  /// Instances of services used
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final MqttService _mqttService = locator<MqttService>();
  final StreamingSharedPreferencesService _streamingSharedPreferencesService =
      locator<StreamingSharedPreferencesService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  /// Devices:
  int lastDevice;

  /// Variables initialisation.
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
  List<String> currentMac;
  List<String> currentName;
  String rootTopic = "/patwardhankaiwalya@gmail.com/AP EMBEDDED/Airpurifier/";
  FSBStatus drawerCurrentState = FSBStatus.FSB_CLOSE;
  Color primaryColor = Color.fromRGBO(39, 35, 67, 1);
  DateTime today = DateTime.now();

  /// Edit bool
  bool editingStatus = false;
  TextEditingController nameEditor = TextEditingController(text: "");

  /// Drawer List
  List<Widget> totalList = [];

  /// List of quality
  List<String> quality = ["good", "medium", "poor"];
  List<String> qualityText = ["Good", "Medium", "Poor"];
  List<Color> qualityColor = [
    Color(0xff5aa897),
    Color(0xfffdc830),
    Color(0xffa55962)
  ];
  int qualityIndex = 0;

  /// User Logs out
  void logout() {
    _authenticationService.signOut();
  }

  void removeDevice() {
    currentMac.removeAt(lastDevice);
    currentName.removeAt(lastDevice);
    drawerCurrentState = FSBStatus.FSB_CLOSE;
    Fluttertoast.showToast(msg: "Device removed");
    _streamingSharedPreferencesService.changeStringListInStreamingSP(
      "name",
      currentName,
    );
    _streamingSharedPreferencesService.changeStringListInStreamingSP(
      "MAC",
      currentMac,
    );
    _firestoreService.userData(
      _authenticationService.getUID(),
      currentMac,
      currentName,
    );
    if (lastDevice != 0) {
      lastDevice--;
      refresh();
    } else if (currentName.length >= 1) {
      refresh();
    } else {
      _navigationService.clearStackAndShow(Routes.addDeviceView);
    }
  }

  /// updateName
  void updateName(String name) {
    nameEditor.text = name;
    currentName[lastDevice] = name;
    editingStatus = false;
    _streamingSharedPreferencesService.changeStringListInStreamingSP(
      "name",
      currentName,
    );
    _firestoreService.userData(
      _authenticationService.getUID(),
      currentMac,
      currentName,
    );
    notifyListeners();
  }

  /// toggles drawer
  void menuToggle() {
    drawerCurrentState = drawerCurrentState == FSBStatus.FSB_OPEN
        ? FSBStatus.FSB_CLOSE
        : FSBStatus.FSB_OPEN;
    notifyListeners();
  }

  ///Used to get WeekDay
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

  /// Used to get Month
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

  /// Refreshes Home View
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
    getLocation();
    panelController.close();
    notifyListeners();
  }

  /// Change last Device
  void changeDevice(String name) {
    nameEditor.text = name;
    lastDevice = currentName.indexOf(name);
    drawerCurrentState = FSBStatus.FSB_CLOSE;
    _streamingSharedPreferencesService.changeIntInStreamingSP(
      "lastDevice",
      lastDevice,
    );
    refresh();
  }

  /// Gets data
  void getLocation() async {
    lastDevice =
        _streamingSharedPreferencesService.readIntFromStreamingSP("lastDevice");
    currentMac =
        _streamingSharedPreferencesService.readStringListFromStreamingSP("MAC");
    currentName = _streamingSharedPreferencesService
        .readStringListFromStreamingSP("name");
    nameEditor.text = currentName[lastDevice];
    print(lastDevice.toString() +
        " " +
        currentMac.toString() +
        " " +
        currentName.toString() +
        "------------------------------------------------------------------------");

    /// Gets the mac ID stored in firebase.
    Future.delayed(
      Duration(seconds: 0),
      () async {
        /// Get's users' location
        Position _position;
        _position = await _authenticationService.getLocation();
        if (_position != null) {
          position = _position;
          double lat = _position.latitude;
          double lon = _position.longitude;
          http.Client client = http.Client();

          /// Passes the location to weather API
          final requestUrl =
              '$endPointUrl/weather?lat=$lat&lon=$lon&APPID=$apiKey';
          Uri url = Uri.parse(requestUrl);
          client.get(url).then((result) {
            /// On Response sets the weather data on home screen
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
        }

        setBusy(true);

        /// Initiates a connection to MQTT broker
        _mqttService.setupConnection(
          connectionSuccessful,
          (String display) {},
          setInitialValues,
          getLocation,
          graphInit: gotGraphValues,
        );
      },
    );
  }

  ///Disconnects broker and navigates to remote screen
  void gotoRemoteScreen() {
    _mqttService.disconnectBroker();
    _navigationService.navigateTo(Routes.remoteControlView, arguments: refresh);
  }

  /// MQTT connection successful callback
  void connectionSuccessful() {
    /// When MQTT service establishes successful with broker, 2 things are done:
    /// 1) Topics for pm values are set to null by publishing null value on those.
    /// 2) Corresponding topics are subscribed to listen live data from device.
    _mqttService.publishPayload(
        "", rootTopic + currentMac[lastDevice] + '/' + "PM 1.0");
    _mqttService.publishPayload(
        "", rootTopic + currentMac[lastDevice] + '/' + "PM 2.5");
    _mqttService.publishPayload(
        "", rootTopic + currentMac[lastDevice] + '/' + "PM 10");
    Future.delayed(Duration(milliseconds: 300), () {
      _mqttService.subscribeToTopic(
          rootTopic + currentMac[lastDevice] + '/' + "PM 1.0");
      _mqttService.subscribeToTopic(
          rootTopic + currentMac[lastDevice] + '/' + "PM 2.5");
      _mqttService
          .subscribeToTopic(rootTopic + currentMac[lastDevice] + '/' + "PM 10");

      /// Uncomment for PM testing
      // double val = 0.0;
      // Timer.periodic(Duration(milliseconds: 500), (timer) {
      //   val = val + 10;
      //   _mqttService.publishPayload(
      //       "$val", rootTopic + currentMac[lastDevice] + '/' + "PM 2.5");
      //   _mqttService.publishPayload(
      //       "$val", rootTopic + currentMac[lastDevice] + '/' + "PM 10");
      //   if (val >= 360) {
      //     val = 0;
      //   }
      // });
    });
  }

  /// initial value setter.
  void setInitialValues(String value, String topic) {
    /// Sets pm1, pm2, pm10 values corresponding to topic.
    // print("\n----------------\n$value + $topic\n---------------------");
    try {
      if (topic == rootTopic + currentMac[lastDevice] + '/' + "PM 1.0") {
        pm1 = value;
      } else if (topic == rootTopic + currentMac[lastDevice] + '/' + "PM 2.5") {
        pm2 = value;
      } else if (topic == rootTopic + currentMac[lastDevice] + '/' + "PM 10") {
        pm10 = value;
      }
      try {
        double pmInt = double.parse(pm2);
        int tempIndex;
        if (pmInt <= 40) {
          tempIndex = 0;
        } else if (pmInt > 40 && pmInt <= 250) {
          tempIndex = 1;
        } else {
          tempIndex = 2;
        }
        if (tempIndex != qualityIndex) {
          setQualityIndexAsPerAir(tempIndex);
        }
      } catch (E) {
        print(E.toString());
      }
      notifyListeners();
    } catch (E) {
      print(E.toString());
    }
  }

  /// Navigates to configure bluetooth screen screen
  void goToBluetoothScreen() {
    _navigationService.navigateTo(Routes.addDeviceView);
  }

  void setQualityIndexAsPerAir(int index) {
    qualityIndex = index;
    notifyListeners();
  }

  PanelController panelController = PanelController();
  void closePanel() {
    panelController.close();
  }

  /// Sample graph Json data
  /// {"total":10,"ref":300,"pm1.0":[10,10,7,6,10,7,10,8,8,11],"pm2.5":[12,13,11,10,14,13,14,10,12,13],"pm10":[18,15,11,11,19,16,16,10,12,14]}
  List<Feature> features = [
    Feature(
      title: "Drink Water",
      color: Color.fromRGBO(255, 255, 255, 1),
      data: [0.01, 0.8, 1, 0.7, 0.6, 0.2, 0.8, 1, 0.7, 0.6],
    ),
    Feature(
      title: "Good",
      color: Colors.greenAccent,
      data: List<double>.filled(151, 0.1),
    ),
    Feature(
      title: "Medium",
      color: Colors.orangeAccent,
      data: List<double>.filled(151, 0.625),
    ),
    Feature(
      title: "Poor",
      color: Colors.redAccent,
      data: List<double>.filled(151, 1),
    ),
  ];

  /// Graph Data

  ScrollController graphScrollController = ScrollController();
  List<String> yLabels = [
    '',
    '',
    '',
    'Good',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    'Medium',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    'Poor',
  ];
  List<String> xLabels = [
    'Monday',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    'Tuesday',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    'Wednesday',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    'Thursday',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    'Friday',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    'Saturday',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    'Sunday',
  ];
}

/// The Json retrieved from weather api is of following structure :
// Map dummy = {
//   "coord": {"lon": 80.3319, "lat": 26.4499},
//   "weather": [
//     {
//       "id": 721,
//       "main": "Haze",
//       "description": "haze",
//       "icon": "50n",
//     }
//   ],
//   "base": "stations",
//   "main": {
//     "temp": 302.15,
//     "feels_like": 303.36,
//     "temp_min": 302.15,
//     "temp_max": 302.15,
//     "pressure": 1006,
//     "humidity": 45
//   },
//   "visibility": 4000,
//   "wind": {
//     "speed": 1.03,
//     "deg": 0,
//   },
//   "clouds": {
//     "all": 0,
//   },
//   "dt": 1616947408,
//   "sys": {
//     "type": 1,
//     "id": 9176,
//     "country": "IN",
//     "sunrise": 1616891640,
//     "sunset": 1616935999,
//   },
//   "timezone": 19800,
//   "id": 1267995,
//   "name": "Kanpur",
//   "cod": 200,
// };
