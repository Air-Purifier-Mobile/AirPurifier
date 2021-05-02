import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:hexcolor/hexcolor.dart';

class SpeedController extends StatefulWidget {
  final double height;
  final double width;
  final int initialValue;
  final int maxValue;
  final int minValue;
  int value;
  final Color arrowColor;
  final Color contentColor;
  final Color backgroundColor;
  final Function changeCallBack;
  final Function setValue;
  final bool enabled;
  SpeedController(
    this.value, {
    this.height,
    this.width,
    this.initialValue,
    this.maxValue,
    this.minValue,
    this.arrowColor,
    this.contentColor,
    this.backgroundColor,
    this.changeCallBack,
    this.setValue,
    this.enabled,
  });
  @override
  _SpeedControllerState createState() => _SpeedControllerState();
}

class _SpeedControllerState extends State<SpeedController> {
  int index;
  @override
  void initState() {
    widget.value = widget.initialValue ?? widget.minValue;
    super.initState();
  }

  void increase() {
    if (widget.enabled) {
      setState(() {
        widget.changeCallBack(
            widget.value + 1 <= widget.maxValue ? widget.value + 1 : index);
      });
    }
  }

  void decrease() {
    if (widget.enabled) {
      setState(() {
        widget.changeCallBack(
            widget.value - 1 >= widget.minValue ? widget.value - 1 : index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.0),
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: !widget.enabled ? HexColor("4a4a68") : widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.width / 2),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 0.0,
            child: GestureDetector(
              onTap: () => decrease(),
              child: Icon(
                Icons.arrow_drop_down,
                size: widget.width,
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            child: GestureDetector(
              onTap: () => increase(),
              child: Icon(
                Icons.arrow_drop_up_sharp,
                size: widget.width,
              ),
            ),
          ),
          // SizedBox(
          //   height: widget.height * 0.05,
          // ),
          Container(
            height: widget.height * 0.3,
            child: Text(
              widget.value.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: widget.contentColor,
                fontSize: widget.height * 0.25,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
