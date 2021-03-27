import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/wifi_service.dart';
import 'package:stacked/stacked.dart';

class WifiViewModel extends BaseViewModel {
  String displayText = "Fetching available wifi devices..";
  List ssids = [];
  bool gotList = false;
  WifiService _wifiService = locator<WifiService>();
  void onModelReady() {
    setBusy(true);
    Future.delayed(Duration(seconds: 3), () {
      _wifiService.getListOfWifi((String text) {
        displayText = text;
        notifyListeners();
      }).then((value) {
        ssids = value;
        gotList = true;
        setBusy(false);
        notifyListeners();
      });
    });
  }

  void refresh() {
    setBusy(true);
    displayText = "Fetching available wifi devices..";
    ssids = [];
    gotList = false;
    notifyListeners();
    onModelReady();
  }
}
