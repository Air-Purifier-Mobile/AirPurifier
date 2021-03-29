import 'package:air_purifier/ui/views/remote%20control/remote_control_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RemoteControlView extends StatelessWidget {
  const RemoteControlView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<RemoteControlViewModel>.reactive(
      viewModelBuilder: () => RemoteControlViewModel(),
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Text("Remote Control"),
          ),
        );
      },
    );
  }
}
