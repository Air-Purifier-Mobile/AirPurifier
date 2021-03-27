import 'package:wifi_configuration/wifi_configuration.dart';

class WifiService {
  List availableWifi;
  Future<List> getListOfWifi(Function callBack) async {
    print("Getting List");
    return await WifiConfiguration.getWifiList().then((list) {
      callBack("Got list");
      return list;
    });
  }
}
