import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CircularSlider extends StatefulWidget {
  final Function changeColor;
  final Color color;
  final String colorCode;
  final int initialValue;
  const CircularSlider({
    this.changeColor,
    this.color,
    this.colorCode,
    this.initialValue,
  });

  @override
  _CircularSliderState createState() => _CircularSliderState();
}

class _CircularSliderState extends State<CircularSlider> {
  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
      min: 0,
      max: 255,
      initialValue: widget.initialValue.toDouble(),
      onChangeEnd: (val) {
        print(val);
      },
      appearance: CircularSliderAppearance(
        customColors: CustomSliderColors(
          dotColor: Colors.white,
          progressBarColor: widget.color,
          trackColor: Colors.black,
        ),
        infoProperties: InfoProperties(
          modifier: (value) {
            widget.changeColor(widget.colorCode, value.ceil());
            return value.ceil().toString();
          },
          mainLabelStyle: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 255, 0, 0),
          ),
        ),
      ),
    );
  }
}
