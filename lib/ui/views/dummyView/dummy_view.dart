import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'dummy_viewModel.dart';

class DummyView extends StatelessWidget {
  const DummyView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<DummyViewModel>.reactive(
      viewModelBuilder: () => DummyViewModel(),
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
