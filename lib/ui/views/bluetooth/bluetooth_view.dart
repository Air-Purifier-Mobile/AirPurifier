import 'package:air_purifier/ui/shared/ui_helpers.dart';
import 'package:air_purifier/ui/widgets/busy_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'bluetooth_viewModel.dart';

class BluetoothView extends StatelessWidget {
  const BluetoothView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<BluetoothViewModel>.reactive(
      viewModelBuilder: () => BluetoothViewModel(),
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Container(
              height: height,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      model.displayText,
                    ),
                  ),
                  Container(
                    height: 50.0,
                    width: width / 2,
                    child: BusyButton(
                      title: "AT",
                      onPressed: () {
                        model.at();
                      },
                    ),
                  ),
                  verticalSpaceMedium,
                  Container(
                    height: 50.0,
                    width: width / 2,
                    child: BusyButton(
                      title: "MAC",
                      onPressed: () {
                        model.mac();
                      },
                    ),
                  ),
                  verticalSpaceMedium,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
