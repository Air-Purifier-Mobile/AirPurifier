import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/mqtt_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';

class RemoteControlViewModel extends BaseViewModel {
  bool isConnected = false;
  String displayText = '';
  MqttService _mqttService = locator<MqttService>();
  String rootTopic = "/tdharmik76@gmail.com/";

  void unsubscribeToTopic() {
    _mqttService.unSubscribeToTopic(rootTopic);
  }

  void onModelReady() {
    _mqttService.setupConnection(connectionSuccessful, changeDisplayText);
  }

  void connectionSuccessful() {
    isConnected = true;
    _mqttService.subscribeToTopic(rootTopic);
    notifyListeners();
  }

  void publishMessage() {
    _mqttService.publishPayload('Testing', '');
  }

  void changeDisplayText(String display) {
    displayText = display;
    notifyListeners();
  }
}
