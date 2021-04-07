import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
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
          child: PlasmaRenderer(
            type: PlasmaType.circle,
            particles: 5,
            color: Color.fromRGBO(
              model.red,
              model.green,
              model.blue,
              1,
            ),
            blur: 0.51,
            size: 2.37,
            speed: 10,
            offset: 0,
            blendMode: BlendMode.plus,
            particleType: ParticleType.atlas,
            variation1: 0,
            variation2: 0,
            variation3: 0,
            rotation: 0,
          ),
          onTap: () {
            print("chameleon tapped---------");
            model.notifyListeners();
          },
        );
      },
    );
  }
}
