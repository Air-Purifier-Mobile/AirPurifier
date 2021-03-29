import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/mqtt_service.dart';
import 'package:stacked/stacked.dart';

class RemoteControlViewModel extends BaseViewModel {
  
  bool isConnected = false;

  MqttService _mqttService = locator<MqttService>();

  void onModelReady(){
    _mqttService.setupConnection(connectionSuccessful);
  }
  
  void connectionSuccessful(){
    isConnected = true;
    _mqttService.subscribeToTopic("/sushrutpatwardhan@gmail.com/");
    notifyListeners();
  }
}
