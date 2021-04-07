import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:numberpicker/numberpicker.dart';

class InputCounter extends StatefulWidget {
  final double width;
  double value;
  final Function setValue;
  InputCounter({
    this.width,
    this.value,
    this.setValue,
  });
  @override
  _InputCounterState createState() => _InputCounterState();
}

class _InputCounterState extends State<InputCounter> {
  bool isNumberPicker = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return NumberPicker(
      value: widget.value.ceil(),
      minValue: 1,
      maxValue: 4,
      step: 1,
      itemHeight: 50,
      itemWidth: widget.width / 1.6,
      axis: Axis.horizontal,
      onChanged: (value) => setState(
        () {
          widget.setValue(value.toDouble());
        },
      ),
      selectedTextStyle: TextStyle(
        color: Colors.white,
        fontSize: height / 22,
      ),
      textStyle: TextStyle(
        fontSize: height / 40,
        color: Colors.white60,
      ),
    );
  }
}
