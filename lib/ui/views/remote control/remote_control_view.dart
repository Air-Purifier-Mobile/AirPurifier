import 'package:air_purifier/ui/shared/ui_helpers.dart';
import 'package:air_purifier/ui/views/remote%20control/remote_control_viewModel.dart';
import 'package:air_purifier/ui/widgets/busy_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RemoteControlView extends StatelessWidget {
  const RemoteControlView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<RemoteControlViewModel>.reactive(
      viewModelBuilder: () => RemoteControlViewModel(),
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        Future<bool> _onBackPressed() {
          return showDialog(
                context: context,
                builder: (context) => new AlertDialog(
                  title: new Text('Are you sure?'),
                  content: new Text('Do you want to exit an App'),
                  actions: <Widget>[
                    new GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
                      child: Text("NO"),
                    ),
                    SizedBox(height: 16),
                    new GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(true);
                        model.unsubscribeToTopic();
                      },
                      child: Text("YES"),
                    ),
                  ],
                ),
              ) ??
              false;
        }

        return WillPopScope(
          onWillPop: () {
            return _onBackPressed();
          },
          child: Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                children: [
                  Text(model.displayText),
                  BusyButton(
                    title: 'Subscribe to Topic - test',
                    onPressed: () {
                      model.subscribeToTopic();
                    },
                  ),
                  verticalSpaceLarge,
                  BusyButton(
                    title: 'Publish',
                    onPressed: () {
                      model.publishMessage(model.subscribedTopic);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
