import 'package:air_purifier/ui/views/startup/startUp_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:stacked/stacked.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return ViewModelBuilder<StartUpViewModel>.reactive(
      viewModelBuilder: () => StartUpViewModel(),
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => SafeArea(
        child: Center(
          child: Container(
            color: Color.fromRGBO(39, 35, 67, 1),
            height: height,
            width: width,
            child: Center(
              child: LoadingBouncingGrid.circle(
                backgroundColor: Colors.white70,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
