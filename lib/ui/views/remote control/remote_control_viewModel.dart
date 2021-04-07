import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/mqtt_service.dart';
import 'package:air_purifier/services/streaming_shared_preferences_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';

class RemoteControlViewModel extends BaseViewModel {
  bool isConnected = false;
  String displayText = '';
  int i = 0;
  MqttService _mqttService = locator<MqttService>();
  String rootTopic = "/sushrutpatwardhan@gmail.com/AP EMBEDDED/Airpurifier/";
  int red;
  int green;
  int blue;
  int initialIndexForSwitch;
  int initialIndexForPMode;
  int initialIndexForLEDMode;
  int initialIndexForFanSpeed;
  Color primaryColor = Color.fromRGBO(39, 35, 67, 1);

  String mac;
  final StreamingSharedPreferencesService _streamingSharedPreferencesService =
      locator<StreamingSharedPreferencesService>();
  bool isDeviceOn = false;

  void changeBlue() {
    blue -= 10;
    notifyListeners();
  }

  void unsubscribeToTopic() {
    Fluttertoast.showToast(msg: 'Disconnect');
    _mqttService.disconnectBroker();
  }

  void onModelReady() {
    print(" =============================MAC :" +
        _streamingSharedPreferencesService.readStringFromStreamingSP("MAC"));
    setBusy(true);
    _mqttService.setupConnection(
      connectionSuccessful,
      changeDisplayText,
      setInitialValues,
      refreshDeviceState,
    );
  }

  void refreshDeviceState() {
    _mqttService.publishPayload("GET", rootTopic + mac + "DEVICE");
    notifyListeners();
  }

  void connectionSuccessful() {
    isConnected = true;
    mac = _streamingSharedPreferencesService.readStringFromStreamingSP("MAC") +
        "/";
    _mqttService.subscribeToTopic(rootTopic + mac + "SPEED");
    _mqttService.subscribeToTopic(rootTopic + mac + "BUTTON");
    _mqttService.subscribeToTopic(rootTopic + mac + "RESPONSE");
    _mqttService.subscribeToTopic(rootTopic + mac + "IN");
    _mqttService.publishPayload("GET", rootTopic + mac + "DEVICE");
    notifyListeners();
  }

  void publishMessage(String message) {
    String topic = rootTopic + mac + "IN";
    // _mqttService.publishPayload(
    //     '{"AP motor":"OFF","AP mode":"MANUAL","LED mode":"AUTO","AP speed":1,"R color":0,"G color":0,"B color":0}',
    //     rootTopic + mac + "RESPONSE");
    _mqttService.publishPayload(message, topic);
  }

  void changeDisplayText(String display) {
    displayText = display;
    notifyListeners();
  }

  void setInitialValues(Map map) {
    print(map.toString());
    setBusy(false);
    if (map.isEmpty) {
      red = 0;
      green = 0;
      blue = 0;
      initialIndexForSwitch = 0;
      initialIndexForPMode = 0;
      initialIndexForLEDMode = 0;
      initialIndexForFanSpeed = 0;
    } else {
      red = map["R color"];
      green = map["G color"];
      blue = map["B color"];
      initialIndexForSwitch = map["AP motor"] == "OFF" ? 0 : 1;
      initialIndexForLEDMode = map["LED mode"] == "AUTO" ? 0 : 1;
      initialIndexForFanSpeed = map["AP speed"] - 1;
      if (map["AP mode"] == "AUTO")
        initialIndexForPMode = 0;
      else if (map["AP mode"] == "MANUAL")
        initialIndexForPMode = 1;
      else
        initialIndexForPMode = 2;
    }
    notifyListeners();
  }
}
