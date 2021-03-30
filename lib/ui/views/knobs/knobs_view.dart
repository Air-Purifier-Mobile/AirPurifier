import 'package:air_purifier/ui/widgets/circular_slider.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'knobs_viewModel.dart';

class KnobsView extends StatelessWidget {
  final Function publishColorCallBack;
  final int initialRed;
  final int initialGreen;
  final int initialBlue;
  const KnobsView({
    Key key,
    this.publishColorCallBack,
    this.initialBlue,
    this.initialGreen,
    this.initialRed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<KnobsViewModel>.reactive(
      viewModelBuilder: () => KnobsViewModel(),
      onModelReady: (model) => model.onModelReady(
        publishColorCallBack,
        initialRed,
        initialGreen,
        initialBlue,
      ),
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
                  borderRadius: BorderRadius.circular(height / 12),
                  color: Color.fromRGBO(36, 37, 41, 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.0, 6.0),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                height: width / 3.4,
                width: width / 3.4,
                child: CircularSlider(
                  initialValue: model.red,
                  color: Color.fromARGB(255, 255, 0, 0),
                  changeColor: model.updateRGBValues,
                  publishChange: model.changeColor,
                  colorCode: 'r',
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(36, 37, 41, 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.0, 6.0),
                      blurRadius: 6.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(height / 12),
                ),
                height: width / 3.4,
                width: width / 3.4,
                child: CircularSlider(
                  initialValue: model.green,
                  color: Color.fromARGB(255, 0, 255, 0),
                  changeColor: model.updateRGBValues,
                  publishChange: model.changeColor,
                  colorCode: 'g',
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(36, 37, 41, 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.0, 6.0),
                      blurRadius: 6.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(height / 12),
                ),
                height: width / 3.4,
                width: width / 3.4,
                child: CircularSlider(
                  initialValue: model.blue,
                  color: Color.fromARGB(255, 0, 0, 255),
                  changeColor: model.updateRGBValues,
                  publishChange: model.changeColor,
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
