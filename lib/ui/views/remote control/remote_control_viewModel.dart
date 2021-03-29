import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/mqtt_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';

class RemoteControlViewModel extends BaseViewModel {
  bool isConnected = false;
  String displayText = '';
  int i = 0;
  MqttService _mqttService = locator<MqttService>();
  String rootTopic = "/sushrutpatwardhan@gmail.com/";

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
    i++;
    _mqttService.publishPayload('Sent from app' + i.toString(), '');
  }

  void changeDisplayText(String display) {
    displayText = display;
    notifyListeners();
  }
}
