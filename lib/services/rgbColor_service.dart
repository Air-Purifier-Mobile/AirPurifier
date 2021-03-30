import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

class RGBService with ReactiveServiceMixin {
  RxValue<int> _red = RxValue<int>(initial: 255);
  RxValue<int> _green = RxValue<int>(initial: 255);
  RxValue<int> _blue = RxValue<int>(initial: 255);

  int get red => _red.value;
  int get green => _green.value;
  int get blue => _blue.value;

  RGBService() {
    listenToReactiveValues([
      _red,
      _green,
      _blue,
    ]);
  }

  void changeColor(String color, int val) {
    if (color == "r") {
      _red.value = val;
    } else if (color == "g") {
      _green.value = val;
    } else {
      _blue.value = val;
    }
  }
}
