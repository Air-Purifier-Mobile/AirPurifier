import 'package:air_purifier/ui/shared/ui_helpers.dart';
import 'package:air_purifier/ui/widgets/busy_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home_viewModel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) => model.getPermissions(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(
                  Icons.logout,
                ),
                onPressed: () {
                  model.logout();
                },
              )
            ],
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 50.0,
                child: BusyButton(
                  title: "Get Location",
                  onPressed: () {
                    model.getPermissions();
                  },
                  image: null,
                ),
              ),
              verticalSpaceLarge,
              Text(
                model.position?.longitude.toString() ?? "",
              ),
              Text(
                model.position?.latitude.toString() ?? "",
              ),
              model.dataReady
                  ? Text(
                      (model.cityName +
                          "\n" +
                          model.description +
                          "\n" +
                          model.temperature +
                          "\n" +
                          model.feelsLike +
                          "\n" +
                          model.humidity +
                          "\n" +
                          model.minTemp +
                          "\n" +
                          model.maxTemp),
                    )
                  : Text("Fetching Weather Data"),
              verticalSpaceLarge,
              Center(
                child: Text("I am Home"),
              ),
              Container(
                height: 50.0,
                child: BusyButton(
                    title: "Log Out",
                    onPressed: () {
                      model.logout();
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}
