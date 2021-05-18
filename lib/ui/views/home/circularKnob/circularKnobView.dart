import 'package:air_purifier/ui/views/home/circularKnob/circularKnobViewModel.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:stacked/stacked.dart';

// ignore: must_be_immutable
class CircularKnobView extends StatelessWidget {
  double height;
  double width;
  String value_temp;
  int index;
  CircularKnobView({
    Key key,
    this.height,
    this.width,
    this.value_temp,
    this.index,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if(value_temp.isEmpty) value_temp = '0.0';
    double value = double.parse(value_temp);
    return ViewModelBuilder<CircularKnobViewModel>.reactive(
      viewModelBuilder: () => CircularKnobViewModel(),
      onModelReady: (model) => model.onModelReady(value, index),
      fireOnModelReadyOnce: false,
      createNewModelOnInsert: true,
      builder: (context, model, child) {
        return Container(
          height: height * 0.3,
          alignment: AlignmentDirectional.topCenter,
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Container(
                height: height * 0.3,
                width: width * 0.6,
                child: AbsorbPointer(
                  absorbing: true,
                  child: SleekCircularSlider(
                    min: 0,
                    max: 400,
                    initialValue: value < 400 ? value : 400,
                    onChangeEnd: (value) {
                      print(value);
                    },
                    appearance: CircularSliderAppearance(
                      startAngle: 165,
                      angleRange: 210,
                      customWidths: CustomSliderWidths(
                        trackWidth: 2,
                        progressBarWidth: 10,
                        handlerSize: 0,
                      ),
                      customColors: CustomSliderColors(
                        progressBarColors: [
                          model.progressBarColorsStart[index],
                          model.progressBarColorsEnd[index]
                        ],
                        dynamicGradient: true,
                        progressBarColor: Colors.white,
                        trackColor: Colors.white,
                        hideShadow: true,
                      ),
                      infoProperties: InfoProperties(
                        modifier: (value) {
                          // widget.changeColor(widget.colorCode, value.ceil());
                          print("\n\nvalue : $value\n\n");
                          return value.ceil().toString();
                        },
                        mainLabelStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              ///Fan Image and Slider
              Container(
                height: height * 0.2,
                width: width * 0.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/${model.quality[index]}.png",
                    ),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
