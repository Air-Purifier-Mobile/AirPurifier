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
          body: Center(
            child: Text("Configure Device"),
          ),
        );
      },
    );
  }
}
