import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:stacked/stacked.dart';

import 'add_device_viewModel.dart';

class AddDeviceView extends StatelessWidget {
  const AddDeviceView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<AddDeviceViewModel>.reactive(
      viewModelBuilder: () => AddDeviceViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Color.fromRGBO(39, 35, 67, 1),
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(39, 35, 67, 1),
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                model.goToLoginScreen();
              },
            ),
          ),
          body: Container(
            height: height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height / 20,
                ),
                Text(
                  "Add your device",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: height / 25,
                    fontFamily: 'Noah',
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: height / 40,
                ),
                Text(
                  "Make the most out of your device with \n the Aeolus application.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: height / 45,
                    fontFamily: 'Noah',
                    color: Colors.white70,
                  ),
                ),
                SizedBox(
                  height: height / 15,
                ),
                Container(
                  height: height / 3,
                  width: width / 2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/fan.png",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 10,
                ),
                MaterialButton(
                  child: Container(
                    alignment: Alignment.center,
                    height: height / 15,
                    width: width / 1.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Text(
                      'Add a device',
                      style: TextStyle(
                        fontSize: height / 35,
                        fontFamily: 'Noah',
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(39, 35, 67, 1),
                      ),
                    ),
                  ),
                  onPressed: () {
                    model.goToBluetoothScreen();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
