import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

class RGBService with ReactiveServiceMixin {
  RxValue<int> _red = RxValue<int>(initial: 0);
  RxValue<int> _green = RxValue<int>(initial: 0);
  RxValue<int> _blue = RxValue<int>(initial: 0);

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
      // publishChange(
      //     "rgb(${val.toString()},${_green.value.toString()},${_blue.value.toString()})");
      _red.value = val;
    } else if (color == "g") {
      // publishChange(
      //     "rgb(${_red.value.toString()},${val.toString()},${_blue.value.toString()})");
      _green.value = val;
    } else {
      // publishChange(
      //     "rgb(${_red.value.toString()},${_green.value.toString()},${val.toString()})");
      _blue.value = val;
    }
  }
}
