import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';

class CircularKnobViewModel extends BaseViewModel {
  double value;
  int qualityIndex;
  List<String> quality = ["good", "medium", "poor"];
  List<Color> qualityColor = [
    Color(0xff5aa897),
    Color(0xfffdc830),
    Color(0xffa55962)
  ];
  List<Color> progressBarColorsStart = [
    Color.fromRGBO(56, 239, 125, 1),
    Color.fromRGBO(243, 115, 53, 1),
    Color.fromRGBO(203, 53, 107, 1),
  ];
  List<Color> progressBarColorsEnd = [
    Color.fromRGBO(17, 153, 142, 1),
    Color.fromRGBO(253, 200, 48, 1),
    Color.fromRGBO(185, 46, 52, 1),
  ];

  void onModelReady(double value, int qualityIndex) {
    this.value = value;
    this.qualityIndex = qualityIndex;
    notifyListeners();
  }
}
