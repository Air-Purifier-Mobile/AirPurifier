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
  String phoneNo = "";
  bool isOtpSeen = false;

  void onModelReady(String number) {
    phoneNo = number;
    Fluttertoast.showToast(msg: 'Please wait for OTP');
    signIn();
  }

  void verifyOtp(String otp) async {
    if (otp.length == 6) {
      setBusy(true);
      await _authenticationService.setOtpAndLogin(otp.trim()).then((value) {
        try {
          if (_authenticationService.isUserLogged()) {
            Fluttertoast.showToast(msg: 'Otp Verification Successful');
            setBusy(false);
          } else {
            print(
                "\n-------------------Auto Detected OTP-------------------\n");
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
    } else
      Fluttertoast.showToast(msg: 'Enter valid OTP');
  }

  Future signIn() async {
    setBusy(true);
    await _authenticationService
        .loginWithPhoneNo(
      phoneNo: phoneNo,
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
