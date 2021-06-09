import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

// ignore: must_be_immutable
class LedToggle extends StatefulWidget {
  final Color backColor;
  bool ledMode;
  final Function toggleLedMode;
  LedToggle({
    this.backColor,
    this.toggleLedMode,
    this.ledMode,
  });
  @override
  _LedToggleState createState() => _LedToggleState();
}

class _LedToggleState extends State<LedToggle> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Manual",
          style: TextStyle(
            color: widget.ledMode ? Colors.white : Colors.white54,
            fontSize: MediaQuery.of(context).size.height / 50,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 20,
        ),
        FlutterSwitch(
          height: 20,
          width: 40.0,
          padding: 4.0,
          toggleSize: 15.0,
          borderRadius: 10.0,
          switchBorder: Border.all(
            color: Colors.white,
            width: 1.0,
          ),
          activeColor: widget.backColor,
          value: widget.ledMode,
          onToggle: (value) {
            print("toggling led mode");
            setState(() {
              widget.ledMode = value;
              widget.toggleLedMode();
            });
          },
        ),
      ],
    );
  }
}
