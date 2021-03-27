import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'wifi_viewModel.dart';

class WifiView extends StatelessWidget {
  const WifiView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<WifiViewModel>.reactive(
      viewModelBuilder: () => WifiViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Text("I am dummy"),
          ),
        );
      },
    );
  }
}
