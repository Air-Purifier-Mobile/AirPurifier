import 'dart:convert';
import 'package:air_purifier/app/locator.dart';
import 'package:air_purifier/app/router.gr.dart';
import 'package:air_purifier/services/streaming_shared_preferences_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';

import 'authentication_service.dart';
import 'firestore_service.dart';

class PhoneAuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool isOtpSent = false;
  // phone number must begin with +91
  /*Authentication codes:
  0-function did not execute.
  1-user signed in/registered automatically.
  2-Incorrect phone number/sms quota exceeded.
  3-Prompt user to manually enter otp to create a new PhoneAuthCredential.
  4-No otp received. Re run.
  */
  UserCredential userCred;
  String verId;
  int _resendToken;
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  FirestoreService _firestoreService = locator<FirestoreService>();
  StreamingSharedPreferencesService _streamingSharedPreferencesService =
      locator<StreamingSharedPreferencesService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreStorageService = locator<FirestoreService>();
  bool retryOtp = false;
  String getUid() {
    return _firebaseAuth.currentUser.uid;
  }

  bool isUserLogged() {
    return _firebaseAuth.currentUser != null;
  }

  void userPersistenceCheck(String uid) {
    _streamingSharedPreferencesService.changeStringInStreamingSP(
        'userUID', uid);
    _firestoreService
        .retrieveUserDocument(_authenticationService.getUID())
        .then((temp) {
      if (!temp.exists || temp.data()['MAC'].isEmpty)
        _navigationService.clearStackAndShow(Routes.addDeviceView);
      else {
        List<String> mac =
            temp.data()['MAC'].map<String>((s) => s as String).toList();
        List<String> name =
            temp.data()["name"].map<String>((s) => s as String).toList();
        _streamingSharedPreferencesService.changeStringListInStreamingSP(
          "MAC",
          mac,
        );
        _streamingSharedPreferencesService.changeStringListInStreamingSP(
          "name",
          name,
        );
        _navigationService.clearStackAndShow(Routes.homeView);
      }
    });
  }

  Future signOut() async {
    //This function signs out the user
    await _firebaseAuth.signOut();
  }

  Future setOtpAndLogin(String otp) async {
    try {
      PhoneAuthCredential phoneAuthCredential =
          PhoneAuthProvider.credential(verificationId: verId, smsCode: otp);
      await _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((userCred) {
        print("\n------------Signed In with User-Cred------------\n");
        userCred.user.uid != null
            ? userPersistenceCheck(userCred.user.uid)
            : print(
                "\n------------Empty User Cred Login Unsuccessful------------\n");
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong. Try again.');
      return false;
    }
  }

  Future<int> loginWithPhoneNo({@required String phoneNo}) async {
    int authCode = 0;
    if (!retryOtp) {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: ("+91" + phoneNo).trim(),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential).then((userCred) {
            print(
                "\n-------------------Auto On first Time Detected OTP-------------------\n");
            userPersistenceCheck(userCred.user.uid);
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          //Fluttertoast.showToast(msg: 'Something went wrong. Try again.');
          authCode = 2;
        },
        codeSent: (String verificationId, int resendToken) async {
          authCode = 3;
          verId = verificationId;
          _resendToken = resendToken;
        },
        timeout: Duration(seconds: 30),
        codeAutoRetrievalTimeout: (String verificationId) {
          Fluttertoast.showToast(msg: 'Retry sending OTP');
          authCode = 4;
          retryOtp = true;
        },
      );
    } else {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: ("+91" + phoneNo).trim(),
        forceResendingToken: _resendToken,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential).then((userCred) {
            print(
                "\n-------------------Auto ON Retry Detected OTP-------------------\n");
            userPersistenceCheck(userCred.user.uid);
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          //Fluttertoast.showToast(msg: 'Something went wrong. Try again.');
          authCode = 2;
        },
        codeSent: (String verificationId, int resendToken) async {
          authCode = 3;
          verId = verificationId;
          _resendToken = resendToken;
        },
        timeout: Duration(seconds: 30),
        codeAutoRetrievalTimeout: (String verificationId) {
          Fluttertoast.showToast(msg: 'Retry sending OTP');
          authCode = 4;
          retryOtp = true;
        },
      );
    }
    return authCode;
  }
}
