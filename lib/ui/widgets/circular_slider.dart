import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CircularSlider extends StatefulWidget {
  final Function changeColor;
  final Function publishChange;
  final Color color;
  final String colorCode;
  final int initialValue;
  const CircularSlider({
    this.changeColor,
    this.color,
    this.colorCode,
    this.initialValue,
    this.publishChange,
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
      initialValue: widget.initialValue.toDouble() ?? 20.0,
      onChangeEnd: (value) {
        widget.publishChange();
        print(value);
      },
      appearance: CircularSliderAppearance(
        startAngle: 165,
        angleRange: 210,
        customWidths: CustomSliderWidths(
          trackWidth: 2,
          progressBarWidth: 2,
          handlerSize: 10,
        ),
        customColors: CustomSliderColors(
          dynamicGradient: true,
          dotColor: widget.color,
          progressBarColor: Colors.white,
          trackColor: Colors.white,
          hideShadow: true,
        ),
        infoProperties: InfoProperties(
          modifier: (value) {
            widget.changeColor(widget.colorCode, value.ceil());
            return value.ceil().toString();
          },
          mainLabelStyle: TextStyle(
            fontSize: 20,
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
