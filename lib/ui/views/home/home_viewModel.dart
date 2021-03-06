import 'dart:async';
import 'dart:convert';
import 'package:air_purifier/app/router.gr.dart';
import 'package:air_purifier/services/firestore_service.dart';
import 'package:air_purifier/services/mqtt_service.dart';
import 'package:air_purifier/services/streaming_shared_preferences_service.dart';
import 'package:fl_chart/fl_chart.dart';
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
      case 0:
        return "Sunday";
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
    fetchFromPreferences();
    print(lastDevice.toString() +
        " " +
        currentMac.toString() +
        " " +
        currentName.toString() +
        "------------------------------------------------------------------------");

    int day = _streamingSharedPreferencesService.readIntFromStreamingSP("day");
    int month =
        _streamingSharedPreferencesService.readIntFromStreamingSP("month");
    int hour =
        _streamingSharedPreferencesService.readIntFromStreamingSP("hour");
    int year =
        _streamingSharedPreferencesService.readIntFromStreamingSP("year");
    lastSync = DateTime(year, month, day, hour);

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
        int shredPrefYear =
            _streamingSharedPreferencesService.readIntFromStreamingSP("year");
        if (shredPrefYear >= 2020) {
          print("Hello rendereing");
          renderGraphData();
        }

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

  List<double> plotData = [];
  List<FlSpot> renderList = [];
  bool gotGraphData = false;
  int weekDay;
  void renderGraphData() {
    plotData = [];
    DateTime currentTime = DateTime.now();
    weekDay = currentTime.weekday;
    int currentHour = DateTime.now().hour;
    List<String> fillers = List<String>.filled(287, "");
    // if (data.length < 168) {
    // filling plotData
    List<double> bufferHourData = List.filled(288, 0.0);
    // Filling null values for buffer data
    for (int i = 0; i < 7; i++) {
      plotData.addAll(bufferHourData);
      // print("Filling null values for buffer data---" +
      //    plotData.length.toString());
    }

    /// previous 6 day's hours plus current day hour
    int startHourIndex = 1727 + (currentHour * 12);
    int showTillIndex = startHourIndex;
    print('start hour index $startHourIndex');
    int remainingHours;
    if (!isGraphRequestSent) {
      /// Sync with last saved hour
      print("\n\n");
      print(lastSync.day);
      int changeInDay = (currentTime.day - lastSync.day).abs();
      int changeInHour = (currentTime.hour - lastSync.hour).abs();
      int betweenHours = (changeInDay * 24) + (changeInHour);
      remainingHours = 168 - betweenHours;
      startHourIndex = remainingHours * 12 - 1;
    }
    // filling remaining data
    print('raw data - $data');
    print('raw data length - ${data.length}');
    for (int x = data.length - 1; x >= 0; x--) {
      for (int y = 11; y >= 0; y--) {
        print('individaul data ${data[x][y]} + ${startHourIndex} \n');
        if (startHourIndex >= 0) plotData[startHourIndex--] = data[x][y];
      }
    }

    print("Plot data---" + plotData.length.toString());
    plotData.forEach((element) {
      print("${element.toString()}");
    });
    print("${plotData.length}");
    // Constructing xLabel List
    int totalDays = 6;
    int start = weekDay - totalDays;
    if (start < 0) start = start + 7;
    xLabels = [];
    for (int x = 0; x < 7; x++) {
      xLabels.add(getDay(start));
      xLabels.addAll(fillers);
      start = (start + 1) % 7;
    }
    xLabels.add(getDay(weekDay + 1));

    for (int i = 0; i < showTillIndex; i++) {
      renderList.add(FlSpot(i.toDouble(), plotData[i]));
    }

    gotGraphData = true;
    notifyListeners();
  }

  bool isGraphRequestSent = false;
  DateTime lastSync;
  void sendGraphRequestsToMqtt() {
    print("sending graph requests");
    DateTime currentTime = DateTime.now();
    if (lastSync.isBefore(currentTime)) {
      print("sending graph requests 1 + $lastSync");
      bool isItFirst =
          _streamingSharedPreferencesService.readBoolFromStreamingSP("first");
      if ((currentTime.hour - lastSync.hour).abs() >= 2 || !isItFirst) {
        if (!isItFirst)
          _streamingSharedPreferencesService.changeBoolInStreamingSP(
              "first", true);
        print("sending graph requests 2");
        isGraphRequestSent = true;
        _mqttService.publishPayload(
          "GRAPH",
          "/patwardhankaiwalya@gmail.com/AP EMBEDDED/Airpurifier/" +
              currentMac[lastDevice] +
              '/' +
              "IN",
        );

        print(currentTime.toString());
        print(lastSync.toString());

        Duration difference = currentTime.difference(lastSync);

        if (lastSync.year > 2020)
          differenceInHours = difference.inHours;
        else
          differenceInHours = -1;

        print("Difference in gotGraph-${difference}");
        print("Diff in hours in gotGraph-${differenceInHours}");

        _streamingSharedPreferencesService.changeIntInStreamingSP(
            "day", currentTime.day);
        _streamingSharedPreferencesService.changeIntInStreamingSP(
            "month", currentTime.month);
        _streamingSharedPreferencesService.changeIntInStreamingSP(
            "year", currentTime.year);
        _streamingSharedPreferencesService.changeIntInStreamingSP(
            "hour", currentTime.hour);
      }
    }
  }

  List<String> hours = [];
  List<List<double>> data = [];
  List<String> macIdList = [];

  int differenceInHours = -1;
  void gotGraphValues(Map<String, dynamic> map) {
    print('Complete Json----' + map.toString());
    List<dynamic> pm2DataTemp = map["pm2.5"];
    List<int> pm2Data =
        pm2DataTemp.map((e) => int.parse(e.toString())).toList();
    print('Pm2.5 List in int-----' + pm2DataTemp.toString());

    /// filling null values
    if (differenceInHours < 0) {
      differenceInHours = (pm2Data.length / 12).ceil();
    } else
      fetchFromPreferences();

    print("Diff in hours after filling null values-${differenceInHours}");

    for (int i = 0; i < differenceInHours; i++) {
      print('Stuck 1st loop $i');
      List<double> temp = List<double>.filled(12, 0.0);
      print(temp.toString() + 'temp');
      data.add(temp);
      print(data.toString() + 'data');
      hours.add((hours.length + 1).toString() + currentMac[lastDevice]);
      print(hours.toString() + 'hours');
    }

    /// Over writing data from device
    int lastHour = data.length - 1;
    int j = 11;
    for (int i = pm2Data.length - 1; i >= 0; i--) {
      print('Stuck 2nd loop $i');
      data[lastHour][j] = pm2Data[i].toDouble();
      print(data[lastHour][j].toString() + 'data[lastHour][j]');

      j--;
      if (j < 0 && lastHour != 0) {
        j = 11;
        lastHour--;
      }
      print(lastHour.toString() + 'last hour');
    }

    /// syncing data with share prefs
    _streamingSharedPreferencesService.changeStringListInStreamingSP(
      "hours${currentMac[lastDevice]}",
      hours,
    );

    print(
        "hours${currentMac[lastDevice]}    ${hours.toString()}  ${data.toString()}");

    int i = 0;
    hours.forEach((hour) {
      // Future.delayed(Duration(milliseconds: 1), () {
      //
      // });
      print(hour + '--------------------------\n');
      List<String> tempList = data[i].map((e) => e.toString()).toList();
      print(tempList.toString() + '\n\n\n');
      _streamingSharedPreferencesService
          .changeStringListInStreamingSP(
        hour.toString().trim(),
        tempList,
      )
          .then((value) {
        print(value.toString());
      });
      i++;
    });
    renderGraphData();
  }

  void fetchFromPreferences() {
    hours = _streamingSharedPreferencesService
        .readStringListFromStreamingSP("hours${currentMac[lastDevice]}");
    print(hours.toString() + "--------------------------------------------1");
    if (hours != null && hours.length != 0) {
      data = [];
      hours.forEach((hour) {
        print(
            hour.toString() + "--------------------------------------------2");
        List<String> dataInString = _streamingSharedPreferencesService
            .readStringListFromStreamingSP(hour);
        data.add(
            dataInString.map((dataPoint) => double.parse(dataPoint)).toList());
        print(
            data.toString() + "--------------------------------------------3");
      });
    }
    print(data.toString() + "--------------------------------------------4");
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

      /// syncing device
      Future.delayed(Duration(seconds: 1), () {
        _mqttService.subscribeToTopic(
          "/patwardhankaiwalya@gmail.com/AP EMBEDDED/Airpurifier/" +
              currentMac[lastDevice] +
              '/' +
              "GRAPH",
        );
        Future.delayed(Duration(seconds: 2), () {
          sendGraphRequestsToMqtt();
        });
      });

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

  /// Sample graph Json data
  /// {"total":10,"ref":300,"pm1.0":[10,10,7,6,10,7,10,8,8,11],"pm2.5":[12,13,11,10,14,13,14,10,12,13],"pm10":[18,15,11,11,19,16,16,10,12,14]}
  // List<Feature> features = [];

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
  List<String> xLabels = [];
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
