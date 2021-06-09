import 'package:air_purifier/ui/widgets/circular_slider.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
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
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(39, 35, 67, 1),
                ),
                height: height / 2.6,
                width: width / 1.3,
                child: CircularSlider(
                  initialValue: model.red,
                  color: HexColor("#dd453a"),
                  changeColor: model.updateRGBValues,
                  publishChange: model.changeColor,
                  colorCode: 'r',
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(39, 35, 67, 1),
                  shape: BoxShape.circle,
                ),
                height: height / 3.2,
                width: width / 1.6,
                child: CircularSlider(
                  initialValue: model.green,
                  color: HexColor("#32db44"),
                  changeColor: model.updateRGBValues,
                  publishChange: model.changeColor,
                  colorCode: 'g',
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(39, 35, 67, 1),
                  shape: BoxShape.circle,
                ),
                height: height / 4,
                width: width / 2.1,
                child: CircularSlider(
                  initialValue: model.blue,
                  color: HexColor("#3b7ddb"),
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
