import 'package:air_purifier/ui/widgets/circular_slider.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'knobs_viewModel.dart';

class KnobsView extends StatelessWidget {
  const KnobsView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<KnobsViewModel>.reactive(
      viewModelBuilder: () => KnobsViewModel(),
      builder: (context, model, child) {
        return Container(
          height: height / 2.1,
          width: width / 1.05,
          padding: EdgeInsets.all(width / 50),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(height / 12),
                ),
                height: width / 3.4,
                width: width / 3.4,
                child: CircularSlider(
                  initialValue: model.red,
                  color: Color.fromARGB(255, 255, 0, 0),
                  changeColor: model.updateRGBValues,
                  colorCode: 'r',
                ),
                // child: SleekCircularSlider(
                //   min: 0,
                //   max: 255,
                //   initialValue: 128,
                //   appearance: CircularSliderAppearance(
                //     size: height / 16,
                //     angleRange: 270,
                //     animationEnabled: true,
                //     infoProperties: InfoProperties(
                //       modifier: (value) {
                //         return value.floor().toString();
                //       },
                //       mainLabelStyle: TextStyle(
                //         fontSize: 20,
                //         color: Colors.white,
                //       ),
                //     ),
                //     customWidths: CustomSliderWidths(
                //       trackWidth: 20,
                //       progressBarWidth: 20,
                //     ),
                //   ),
                // ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(height / 12),
                ),
                height: width / 3.4,
                width: width / 3.4,
                child: CircularSlider(
                  initialValue: model.green,
                  color: Color.fromARGB(255, 0, 255, 0),
                  changeColor: model.updateRGBValues,
                  colorCode: 'g',
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.cyanAccent,
                  borderRadius: BorderRadius.circular(height / 12),
                ),
                height: width / 3.4,
                width: width / 3.4,
                child: CircularSlider(
                  initialValue: model.blue,
                  color: Color.fromARGB(255, 0, 0, 255),
                  changeColor: model.updateRGBValues,
                  colorCode: 'b',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
