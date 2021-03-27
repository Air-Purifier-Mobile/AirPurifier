import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_indicators/progress_indicators.dart';
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
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Choose Wifi Network"),
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.refresh,
                  ),
                  onPressed: () {
                    model.refresh();
                  }),
            ],
          ),
          body: !model.isBusy
              ? ListView.builder(
                  itemCount: model.ssids.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      key: Key(model.ssids[index]),
                      title: Text(
                        model.ssids[index],
                        style: TextStyle(fontSize: 20.0),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Fluttertoast.showToast(msg: model.ssids[index]);
                        },
                      ),
                    );
                  },
                )
              : Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(model.displayText),
                      FadingText("...."),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
