import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/rgbColor_service.dart';
import 'package:stacked/stacked.dart';

class KnobsViewModel extends BaseViewModel {
  RGBService _rgbService = locator<RGBService>();
  int get red => _rgbService.red;
  int get green => _rgbService.green;
  int get blue => _rgbService.blue;

  void updateRGBValues(String code, int val) {
    _rgbService.changeColor(code, val);
  }
}
