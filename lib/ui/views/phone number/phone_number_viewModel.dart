import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/app/router.gr.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PhoneNumberViewModel extends BaseViewModel {
  TextEditingController phoneNoController = TextEditingController();
  NavigationService _navigationService = locator<NavigationService>();
  void goToOtpScreen() {
    if (phoneNoController.text.length != 10)
      Fluttertoast.showToast(msg: "Enter valid phone number");
    else
      _navigationService.navigateTo(Routes.phoneAuthView,
          arguments: phoneNoController.text.trim());
  }
}
