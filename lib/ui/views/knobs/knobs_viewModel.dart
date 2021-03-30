import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/rgbColor_service.dart';
import 'package:stacked/stacked.dart';

class KnobsViewModel extends BaseViewModel {
  RGBService _rgbService = locator<RGBService>();
  int get red => _rgbService.red;
  int get green => _rgbService.green;
  int get blue => _rgbService.blue;
  Function publishMessage;
  void onModelReady(
    Function publish,
    int initRed,
    initGreen,
    initBlue,
  ) {
    publishMessage = publish;
    updateRGBValues("r", initRed);
    updateRGBValues('g', initGreen);
    updateRGBValues('b', initBlue);
    notifyListeners();
  }

  void updateRGBValues(String code, int val) {
    _rgbService.changeColor(code, val);
  }

  void changeColor() {
    publishMessage("rgb($red,$green,$blue)");
  }
}
