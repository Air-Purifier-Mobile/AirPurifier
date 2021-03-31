import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/services/phone_auth_service.dart';
import 'package:air_purifier/services/streaming_shared_preferences_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';

class PhoneAuthViewModel extends BaseViewModel {
  final PhoneAuthenticationService _authenticationService =
      locator<PhoneAuthenticationService>();
  final phoneNoController = TextEditingController();
  final otpController = TextEditingController();
  StreamingSharedPreferencesService streamingSharedPreferencesService =
      locator<StreamingSharedPreferencesService>();

  bool isOtpSeen = false;

  void verifyOtp() async {
    setBusy(true);
    await _authenticationService
        .setOtpAndLogin(
      otpController.text.trim(),
    )
        .then((value) {
      try {
        if (_authenticationService.isUserLogged()) {
          Fluttertoast.showToast(msg: 'Otp Verification Successful');
          setBusy(false);
        } else {
          print("\n-------------------Auto Detected OTP-------------------\n");
          Fluttertoast.showToast(msg: 'Otp Verification Failed');
          isOtpSeen = false;
          setBusy(false);
          notifyListeners();
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
        isOtpSeen = false;
        setBusy(false);
        notifyListeners();
      }
    });
  }

  checkInputParams() {
    if (phoneNoController.text.trim().length != 10)
      Fluttertoast.showToast(msg: 'Please Enter a valid number');
    else {
      streamingSharedPreferencesService.changeStringInStreamingSP(
          'phoneNo', phoneNoController.text.trim());
      Fluttertoast.showToast(msg: 'Please wait for OTP');
      signIn();
    }
  }

  Future signIn() async {
    setBusy(true);
    await _authenticationService
        .loginWithPhoneNo(
      phoneNo: phoneNoController.text.trim(),
    )
        .then((value) {
      if (value == 1) {
        isOtpSeen = true;
        notifyListeners();
      } else if (value == 2) {
        isOtpSeen = false;
        notifyListeners();
        //dialogue saying incorrect details
      } else if (value == 3) {
        //success
        isOtpSeen = true;
        notifyListeners();
      } else if (value == 4) {
        isOtpSeen = true;
        // re run no otp received
        notifyListeners();
      } else {
        isOtpSeen = true;
        notifyListeners();
      }
    });
    setBusy(false);
  }
}
