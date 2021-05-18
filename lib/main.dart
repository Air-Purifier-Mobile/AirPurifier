import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/mqtt_service.dart';
import 'package:air_purifier/services/streaming_shared_preferences_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:air_purifier/app/router.gr.dart' as customRouter;
import 'package:stacked_services/stacked_services.dart';
import 'package:workmanager/workmanager.dart';

const myTask = "syncWithTheBackEnd";

void callbackDispatcher() {
// this method will be called every hour
  Workmanager.executeTask((task, inputdata) async {
    //Return true when the task executed successfully or not
    if (task == myTask) connectMqtt();
    return Future.value(true);
  });
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  StreamingSharedPreferencesService streamingSharedPreferencesService =
      locator<StreamingSharedPreferencesService>();
  await streamingSharedPreferencesService.init();
  Workmanager.initialize(callbackDispatcher);
  setupLocator();
  Workmanager.registerPeriodicTask(
    "2",
    // use the same task name used in callbackDispatcher function for identifying the task
    // Each task must have an unique name if you want to add multiple tasks;
    myTask,
    // When no frequency is provided the default 15 minutes is set.
    // Minimum frequency is 15 min.
    // Android will automatically change your frequency to 15 min if you have configured a lower frequency than 15 minutes.
    frequency: Duration(minutes: 15), // change duration according to your needs
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aeolus',
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics())
      ],
      debugShowCheckedModeBanner: false,
      initialRoute: customRouter.Routes.startUpView,
      themeMode: ThemeMode.light,
      // ignore: deprecated_member_use
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: customRouter.Router().onGenerateRoute,
    );
  }
}

final StreamingSharedPreferencesService _streamingSharedPreferencesService =
    locator<StreamingSharedPreferencesService>();
final MqttService _mqttService = locator<MqttService>();
List<String> hours;
List<List<double>> data = [];
List<String> macIdList =
    _streamingSharedPreferencesService.readStringListFromStreamingSP("MAC");

void connectMqtt() {
  _mqttService.setupConnection(
    () {
      if (macIdList != [])
        macIdList.forEach((mac) {
          Future.delayed(Duration(seconds: 1), () {
            _mqttService.subscribeToTopic(
              "/patwardhankaiwalya@gmail.com/AP EMBEDDED/Airpurifier/" +
                  mac +
                  '/' +
                  "GRAPH",
            );
            Future.delayed(Duration(seconds: 2), () {
              sendGraphRequestsToMqtt(mac);
            });
          });
        });
    },
    () {},
    () {},
    () {},
    graphInit: gotGraphValues,
  );
}

void sendGraphRequestsToMqtt(String mac) {
  _mqttService.publishPayload(
    "GRAPH",
    "/patwardhankaiwalya@gmail.com/AP EMBEDDED/Airpurifier/" + mac + '/' + "IN",
  );
}

void gotGraphValues(Map map, String mac) {
  print(map.toString());
  List<int> pm2Data = map["pm2.5"];

  /// ek ghante mai 12
  fetchFromPreferences(mac);

  /// filling new data
  data.add(List<double>.filled(12, 0.0));
  hours.add((hours.length + 1).toString() + mac);
  int lastHour = data.length - 1;
  int j = 11;
  for (int i = pm2Data.length - 1; i >= 0; i--) {
    data[lastHour][j] = pm2Data[i].toDouble();
    j--;
    if (j == 0 && lastHour != 0) {
      j = 11;
      lastHour--;
    }
  }

  /// syncing data with share prefs
  _streamingSharedPreferencesService.changeStringListInStreamingSP(
    "hours$mac",
    hours,
  );
  int i = 0;
  hours.forEach((hour) {
    List<String> tempList = data[i].map((e) => e.toString()).toList();
    _streamingSharedPreferencesService.changeStringListInStreamingSP(
      hour,
      tempList,
    );
    i++;
  });
}

void fetchFromPreferences(String mac) {
  hours = _streamingSharedPreferencesService
      .readStringListFromStreamingSP("hours$mac");
  if (hours != []) {
    data = [];
    hours.map((hour) {
      List<String> dataInString = _streamingSharedPreferencesService
          .readStringListFromStreamingSP("$hour$mac");
      data.add(
          dataInString.map((dataPoint) => double.parse(dataPoint)).toList());
    });
  }
}
