import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'chameleon_container_viewModel.dart';

class ChameleonContainerView extends StatelessWidget {
  const ChameleonContainerView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<ChameleonContainerViewModel>.reactive(
      viewModelBuilder: () => ChameleonContainerViewModel(),
      builder: (context, model, child) {
        return GestureDetector(
          child: Container(
            height: height / 2.1,
            width: width / 1.05,
            padding: EdgeInsets.all(width / 50),
            color: Color.fromRGBO(
              model.red,
              model.green,
              model.blue,
              1,
            ),
          ),
          onTap: () {
            model.notifyListeners();
          },
        );
      },
    );
  }
}
